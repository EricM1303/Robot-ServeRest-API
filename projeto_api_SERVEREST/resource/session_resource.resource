*** Settings ***
Library    RequestsLibrary
Library    OperatingSystem


*** Keywords ***
Criar Sessão
    [Arguments]    ${BASE_URL}
    ${header}    Create Dictionary    Content-Type=application/json
    Create Session    alias=api    url=${BASE_URL}    verify=True


Encerrar Sessão
    Delete All Sessions