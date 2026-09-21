*** Settings ***
Documentation       Full end-to-end checkout flow: login -> add to cart -> checkout -> order complete.

Resource            ../../resources/common.robot
Resource            ../../resources/page_objects/login_page.robot
Resource            ../../resources/page_objects/products_page.robot
Resource            ../../resources/page_objects/cart_page.robot
Resource            ../../resources/page_objects/checkout_page.robot

Test Setup          Log In As Standard User
Test Teardown       Close All Browsers And Cleanup

Test Tags           ui    checkout


*** Test Cases ***
Complete Checkout With Single Product
    [Documentation]    A user can buy a single product end to end.
    Add Product To Cart    Sauce Labs Backpack
    Go To Cart
    Verify On Cart Page
    Click Checkout
    Fill Checkout Information    John    Doe    12345
    Verify On Checkout Overview Page
    ${total}=    Get Order Total
    Should Match Regexp    ${total}    Total: \\$\\d+\\.\\d{2}
    Complete Checkout
    Verify Order Complete

Complete Checkout With Multiple Products
    [Documentation]    A user can buy several products end to end.
    Add Product To Cart    Sauce Labs Backpack
    Add Product To Cart    Sauce Labs Bike Light
    Add Product To Cart    Sauce Labs Bolt T-Shirt
    Go To Cart
    ${count}=    Get Cart Item Count
    Should Be Equal As Integers    ${count}    3
    Click Checkout
    Fill Checkout Information    Jane    Smith    98765
    Verify On Checkout Overview Page
    Complete Checkout
    Verify Order Complete

Checkout Requires First Name
    [Documentation]    Leaving the first name blank blocks checkout with an error.
    Add Product To Cart    Sauce Labs Backpack
    Go To Cart
    Click Checkout
    Fill Checkout Fields    ${EMPTY}    Doe    12345
    Click Continue
    Wait Until Element Is Visible    ${CHECKOUT_ERROR}    timeout=${TIMEOUT}
    Element Should Contain    ${CHECKOUT_ERROR}    First Name is required


*** Keywords ***
Log In As Standard User
    [Documentation]    Opens a fresh browser and logs in, so no session/cookie
    ...    state leaks between test cases.
    Open Browser With Options
    Open Login Page
    Login As    ${STANDARD_USER}    ${PASSWORD}
    Verify Login Successful
    Verify On Products Page
