*** Settings ***
Documentation       Product sorting scenarios on the inventory page.

Library             Collections
Resource            ../../resources/common.robot
Resource            ../../resources/page_objects/login_page.robot
Resource            ../../resources/page_objects/products_page.robot

Test Setup          Log In As Standard User
Test Teardown       Close All Browsers And Cleanup

Test Tags           ui    sorting


*** Test Cases ***
Sort Products By Name Ascending
    [Documentation]    "Name (A to Z)" sorts product names alphabetically ascending.
    Sort Products By    az
    ${names}=    Get All Product Names
    ${expected}=    Evaluate    sorted($names)
    Lists Should Be Equal    ${names}    ${expected}

Sort Products By Name Descending
    [Documentation]    "Name (Z to A)" sorts product names alphabetically descending.
    Sort Products By    za
    ${names}=    Get All Product Names
    ${expected}=    Evaluate    sorted($names, reverse=True)
    Lists Should Be Equal    ${names}    ${expected}

Sort Products By Price Low To High
    [Documentation]    "Price (low to high)" sorts products by ascending price.
    Sort Products By    lohi
    ${prices}=    Get All Product Prices
    ${expected}=    Evaluate    sorted($prices)
    Lists Should Be Equal    ${prices}    ${expected}

Sort Products By Price High To Low
    [Documentation]    "Price (high to low)" sorts products by descending price.
    Sort Products By    hilo
    ${prices}=    Get All Product Prices
    ${expected}=    Evaluate    sorted($prices, reverse=True)
    Lists Should Be Equal    ${prices}    ${expected}


*** Keywords ***
Log In As Standard User
    [Documentation]    Opens a fresh browser and logs in, so no session/cookie
    ...    state leaks between test cases.
    Open Browser With Options
    Open Login Page
    Login As    ${STANDARD_USER}    ${PASSWORD}
    Verify Login Successful
    Verify On Products Page
