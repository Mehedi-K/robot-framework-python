*** Comments ***
# Page object for the shopping cart page.


*** Settings ***
Library     SeleniumLibrary
Resource    ../variables.robot
Resource    ../common.robot


*** Variables ***
${CART_ITEM}            css:[data-test="inventory-item"]
${CART_ITEM_NAME}       css:[data-test="inventory-item-name"]
${CHECKOUT_BUTTON}      css:[data-test="checkout"]
${CONTINUE_SHOPPING}    css:[data-test="continue-shopping"]


*** Keywords ***
Verify On Cart Page
    [Documentation]    Confirms the browser is on the cart page.
    Wait Until Location Contains    cart.html    timeout=${TIMEOUT}

Get Cart Item Count
    [Documentation]    Returns how many line items are in the cart.
    ${present}=    Run Keyword And Return Status    Page Should Contain Element    ${CART_ITEM}
    IF    not ${present}
        RETURN    ${0}
    END
    ${elements}=    Get WebElements    ${CART_ITEM}
    ${count}=    Get Length    ${elements}
    RETURN    ${count}

Cart Should Contain Product
    [Documentation]    Asserts a product with the given name is listed in the cart.
    [Arguments]    ${product_name}
    Page Should Contain Element
    ...    xpath=//*[@data-test="inventory-item-name"][text()="${product_name}"]

Cart Should Not Contain Product
    [Documentation]    Asserts a product with the given name is NOT listed in the cart.
    [Arguments]    ${product_name}
    Page Should Not Contain Element
    ...    xpath=//*[@data-test="inventory-item-name"][text()="${product_name}"]

Remove Product From Cart Page
    [Documentation]    Clicks "Remove" for the given product while on the cart page.
    [Arguments]    ${product_name}
    ${slug}=    Evaluate    "${product_name}".lower().replace(" ", "-")
    Click Via Javascript    css:[data-test="remove-${slug}"]
    Wait Until Page Does Not Contain Element    css:[data-test="remove-${slug}"]    timeout=${TIMEOUT}

Click Checkout
    [Documentation]    Starts the checkout flow from the cart page, retrying the
    ...    click if the SPA's client-side routing doesn't kick in immediately.
    Click Until Location Contains    ${CHECKOUT_BUTTON}    checkout-step-one.html
