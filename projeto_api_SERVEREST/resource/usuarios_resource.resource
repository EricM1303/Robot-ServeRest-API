*** Settings ***
Library    RequestsLibrary
Library    OperatingSystem
Library    Collections

*** Variables ***
${message_response_delete}    Registro excluído com sucesso

*** Keywords ***

Criar usuário
    ${body}    Get File    path=${EXECDIR}\\projeto_api_SERVEREST\\data-driven\\user_create_template.json

    # Enviar as requisições
    ${header}      Create Dictionary    Content-Type=application/json
    ${response}    POST On Session    
    ...    alias=api    url=/usuarios    
    ...    headers=${header}    
    ...    data=${body}   
    ...    expected_status=201

    ${user_id}=    Get From Dictionary    
    ...    dictionary=${response.json()}    
    ...    key=_id

    Log To Console    
    ...    message=Usuário criado: ${user_id}

    RETURN    ${user_id}


Visualizar usuário
    [Arguments]    ${user_id}

    ${response}=    GET On Session
    ...    alias=api
    ...    url=/usuarios
    ...    expected_status=200

    ${usuarios}=    Get From Dictionary
    ...    dictionary=${response.json()}
    ...    key=usuarios

    FOR    ${usuario}    IN    @{usuarios}

        ${id}=    Get From Dictionary    dictionary=${usuario}    key=_id
        IF    '${id}' == '${user_id}'

            ${nome}=    Get From Dictionary    dictionary=${usuario}    key=nome
            ${email}=    Get From Dictionary    dictionary=${usuario}    key=email

            Log To Console    Usuario encontrado: ${nome} | ${email}
            RETURN    ${None}
        END
    END

    Fail    Usuario não encontrado


Atualizar usuário
    [Arguments]    ${user_id}
    ${body}    Get File    path=${EXECDIR}\\projeto_api_SERVEREST\\data-driven\\user_update_template.json

    # Enviar as requisições
    ${header}      Create Dictionary    Content-Type=application/json
    ${response}    PUT On Session    
    ...    alias=api    url=/usuarios/${user_id}
    ...    headers=${header}    
    ...    data=${body}
    ...    expected_status=200
    
    #                                                         response.json()['id'] -> navegar no dicionário
    ${response_message}    Get From Dictionary    dictionary=${response.json()}    key=message
    Log Many    ${response_message}
  

Deletar usuário
    [Arguments]    ${user_id}
    # Enviar as requisições
    ${header}      Create Dictionary    Content-Type=application/json
    
    ${id}    Convert To String    
    ...    item=${user_id}
    
    ${response}    DELETE On Session    
    ...    alias=api    
    ...    url=/usuarios/${id}   
    ...    expected_status=200

    ${log_message}    Get From Dictionary    
    ...    dictionary=${response.json()}    key=message
    
    IF    '${log_message}' == '${message_response_delete}'
        Log To Console    Usuário excluído com sucesso!

    ELSE IF    '${log_message}' != '${message_response_delete}'
        Log To Console    Ocorreu um erro ao excluir usuário!
    END
    