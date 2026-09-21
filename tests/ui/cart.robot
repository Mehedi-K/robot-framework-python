*** Settings ***
Documentation       Shopping cart scenarios: adding/removing products and badge count.

Resource            ../../resources/common.robot
Resource            ../../resources/page_objects/login_page.robot
Resource            ../../resources/page_objects/products_page.robot
Resource            ../../resources/page_objects/cart_page.robot

Test Setup          Log In As Standard User
Test Teardown       Close All Browsers And Cleanup

Test Tags           ui    cart


*** Test Cases ***
Add Single Product To Cart Updates Badge
    [Documentation]    Adding one product shows a badge count of 1.
    Add Product To Cart    Sauce Labs Backpack
    ${count}=    Get Cart Badge Count
    Should Be Equal As Strings    ${count}    1

Add Multiple Products To Cart Updates Badge
    [Documentation]    Adding several products accumulates the badge count.
    Add Product To Cart    Sauce Labs Backpack
    Add Product To Cart    Sauce Labs Bike Light
    Add Product To Cart    Sauce Labs Bolt T-Shirt
    ${count}=    Get Cart Badge Count
    Should Be Equal As Strings    ${count}    3

Remove Product From Products Page Updates Badge
    [Documentation]    Removing a product from the inventory page updates the badge.
    Add Product To Cart    Sauce Labs Backpack
    Add Product To Cart    Sauce Labs Bike Light
    Remove Product From Cart    Sauce Labs Backpack
    ${count}=    Get Cart Badge Count
    Should Be Equal As Strings    ${count}    1

Cart Page Lists Added Products
    [Documentation]    Products added on the inventory page appear on the cart page.
    Add Product To Cart    Sauce Labs Backpack
    Add Product To Cart    Sauce Labs Bike Light
    Go To Cart
    Verify On Cart Page
    ${count}=    Get Cart Item Count
    Should Be Equal As Integers    ${count}    2
    Cart Should Contain Product    Sauce Labs Backpack
    Cart Should Contain Product    Sauce Labs Bike Light

Remove Product From Cart Page
    [Documentation]    Removing a product from the cart page updates the cart contents.
    Add Product To Cart    Sauce Labs Backpack
    Add Product To Cart    Sauce Labs Bike Light
    Go To Cart
    Remove Product From Cart Page    Sauce Labs Backpack
    Cart Should Not Contain Product    Sauce Labs Backpack
    Cart Should Contain Product    Sauce Labs Bike Light
    ${count}=    Get Cart Item Count
    Should Be Equal As Integers    ${count}    1


*** Keywords ***
Log In As Standard User
    [Documentation]    Opens a fresh browser and logs in, so no session/cookie
    ...    state leaks between test cases.
    Open Browser With Options
    Open Login Page
    Login As    ${STANDARD_USER}    ${PASSWORD}
    Verify Login Successful
    Verify On Products Page
