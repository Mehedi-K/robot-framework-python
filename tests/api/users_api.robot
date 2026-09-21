*** Settings ***
Documentation       CRUD scenarios against the reqres.in fake REST API (/api/users).
...                 reqres.in currently answers unauthenticated requests, but some
...                 endpoints/tiers may require the community "free" API key, so it
...                 is sent on every request here for forward compatibility (see
...                 https://reqres.in for current requirements).

Library             RequestsLibrary
Library             Collections
Resource            ../../resources/variables.robot

Suite Setup         Create Reqres Session

Test Tags           api    users


*** Variables ***
&{API_HEADERS}       x-api-key=reqres-free-v1    Content-Type=application/json


*** Test Cases ***
Get List Of Users Returns Paginated Data
    [Documentation]    GET /users returns a 200 and a non-empty, well-formed page of users.
    &{params}=    Create Dictionary    page=1
    ${response}=    GET On Session    reqres    /users    params=${params}    expected_status=200
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    data
    ${users}=    Set Variable    ${response.json()}[data]
    Should Not Be Empty    ${users}
    Dictionary Should Contain Key    ${users}[0]    email
    Dictionary Should Contain Key    ${users}[0]    first_name

Get Single User Returns Correct User
    [Documentation]    GET /users/{id} returns the requested user's details.
    ${response}=    GET On Session    reqres    /users/2    expected_status=200
    ${user}=    Set Variable    ${response.json()}[data]
    Should Be Equal As Integers    ${user}[id]    2
    Should Contain    ${user}[email]    @reqres.in
    Dictionary Should Contain Key    ${user}    first_name
    Dictionary Should Contain Key    ${user}    last_name

Get Single User That Does Not Exist Returns 404
    [Documentation]    GET /users/{id} with an unknown id returns 404.
    ${response}=    GET On Session    reqres    /users/23    expected_status=404
    Should Be Equal As Integers    ${response.status_code}    404

Create User Returns Created Resource
    [Documentation]    POST /users creates a new user and echoes back the payload.
    &{payload}=    Create Dictionary    name=Morpheus    job=Leader
    ${response}=    POST On Session    reqres    /users    json=${payload}    expected_status=201
    Should Be Equal As Integers    ${response.status_code}    201
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${body}[name]    Morpheus
    Should Be Equal As Strings    ${body}[job]    Leader
    Dictionary Should Contain Key    ${body}    id
    Dictionary Should Contain Key    ${body}    createdAt

Update User With Put Returns Updated Resource
    [Documentation]    PUT /users/{id} updates the user and returns the new values.
    &{payload}=    Create Dictionary    name=Morpheus    job=Zion Resident
    ${response}=    PUT On Session    reqres    /users/2    json=${payload}    expected_status=200
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${body}[name]    Morpheus
    Should Be Equal As Strings    ${body}[job]    Zion Resident
    Dictionary Should Contain Key    ${body}    updatedAt

Delete User Returns No Content
    [Documentation]    DELETE /users/{id} removes the user and returns 204 with no body.
    ${response}=    DELETE On Session    reqres    /users/2    expected_status=204
    Should Be Equal As Integers    ${response.status_code}    204
    Should Be Empty    ${response.content}


*** Keywords ***
Create Reqres Session
    [Documentation]    Creates a shared HTTP session with the API base URL and headers.
    Create Session    reqres    ${API_BASE_URL}    headers=${API_HEADERS}
