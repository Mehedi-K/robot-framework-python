*** Settings ***
Documentation       Login scenarios for saucedemo.com: valid login, invalid
...                 credentials, and the locked-out-user error case.

Resource            ../../resources/common.robot
Resource            ../../resources/page_objects/login_page.robot

Test Setup          Set Up Login Test
Test Teardown       Close All Browsers And Cleanup

Test Tags           ui    login


*** Test Cases ***
Valid Login With Standard User
    [Documentation]    A user with valid credentials reaches the inventory page.
    Login As    ${STANDARD_USER}    ${PASSWORD}
    Verify Login Successful

Invalid Login With Wrong Password
    [Documentation]    An incorrect password is rejected with an error message.
    Login As    ${STANDARD_USER}    wrong_password
    Verify Error Message Contains    Username and password do not match

Locked Out User Cannot Login
    [Documentation]    The locked_out_user account is refused with a clear error.
    Login As    ${LOCKED_OUT_USER}    ${PASSWORD}
    Verify Error Message Contains    locked out

Login With Empty Credentials Shows Error
    [Documentation]    Submitting the form with no username shows a validation error.
    Login As    ${EMPTY}    ${EMPTY}
    Verify Error Message Contains    Username is required


*** Keywords ***
Set Up Login Test
    [Documentation]    Opens a fresh browser for each test so no session/cookie
    ...    state leaks between test cases.
    Open Browser With Options
    Open Login Page
