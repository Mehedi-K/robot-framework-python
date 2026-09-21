*** Comments ***
# Page object for https://www.saucedemo.com/ (login screen).


*** Settings ***
Library     SeleniumLibrary
Resource    ../variables.robot
Resource    ../common.robot


*** Variables ***
${USERNAME_INPUT}      id:user-name
${PASSWORD_INPUT}      id:password
${LOGIN_BUTTON}         id:login-button
${ERROR_MESSAGE}        css:[data-test="error"]


*** Keywords ***
Open Login Page
    [Documentation]    Navigates to the base URL and waits for the login form to render.
    Go To    ${BASE_URL}
    Wait Until Element Is Visible    ${USERNAME_INPUT}    timeout=${TIMEOUT}

Login As
    [Documentation]    Fills in the login form and submits it.
    [Arguments]    ${username}    ${password}
    Wait Until Element Is Visible    ${USERNAME_INPUT}    timeout=${TIMEOUT}
    Wait Until Element Is Enabled    ${USERNAME_INPUT}    timeout=${TIMEOUT}
    Input Text    ${USERNAME_INPUT}    ${username}
    Textfield Value Should Be    ${USERNAME_INPUT}    ${username}
    Wait Until Element Is Enabled    ${PASSWORD_INPUT}    timeout=${TIMEOUT}
    Input Password    ${PASSWORD_INPUT}    ${password}
    Click Via Javascript    ${LOGIN_BUTTON}

Verify Login Successful
    [Documentation]    Asserts the user landed on the inventory page.
    Wait Until Location Contains    inventory.html    timeout=${TIMEOUT}

Verify Error Message Contains
    [Documentation]    Asserts the login error banner shows the expected text.
    [Arguments]    ${expected_text}
    Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=${TIMEOUT}
    Element Should Contain    ${ERROR_MESSAGE}    ${expected_text}
