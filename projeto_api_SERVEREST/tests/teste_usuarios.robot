*** Settings ***
Library    OperatingSystem
Resource    ../resource/session_resource.resource
Resource    ../resource/usuarios_resource.resource

Suite Setup       Criar Sessão    https://serverest.dev/
Suite Teardown    Encerrar Sessão

*** Variables ***


*** Test Cases ***

Teste CRUD
    ${user_id}=    Criar usuário

    Visualizar usuário    ${user_id}

    Atualizar usuário     ${user_id}

    Deletar usuário       ${user_id}
