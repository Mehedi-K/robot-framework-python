*** Comments ***
# Page object for the inventory ("Products") page.


*** Settings ***
Library     SeleniumLibrary
Library     Collections
Library     String
Resource    ../variables.robot
Resource    ../common.robot


*** Variables ***
${INVENTORY_LIST}          css:[data-test="inventory-list"]
${INVENTORY_ITEM_NAME}     css:[data-test="inventory-item-name"]
${INVENTORY_ITEM_PRICE}    css:[data-test="inventory-item-price"]
${SORT_DROPDOWN}           css:[data-test="product-sort-container"]
${CART_LINK}               css:[data-test="shopping-cart-link"]
${CART_BADGE}              css:[data-test="shopping-cart-badge"]


*** Keywords ***
Verify On Products Page
    [Documentation]    Confirms the inventory list is displayed.
    Wait Until Element Is Visible    ${INVENTORY_LIST}    timeout=${TIMEOUT}

Sort Products By
    [Documentation]    Selects a sort option. Valid values: az, za, lohi, hilo.
    [Arguments]    ${sort_value}
    Wait Until Element Is Visible    ${SORT_DROPDOWN}    timeout=${TIMEOUT}
    Select From List By Value    ${SORT_DROPDOWN}    ${sort_value}

Get All Product Names
    [Documentation]    Returns the list of product names in their current display order.
    Wait Until Element Is Visible    ${INVENTORY_ITEM_NAME}    timeout=${TIMEOUT}
    ${elements}=    Get WebElements    ${INVENTORY_ITEM_NAME}
    ${names}=    Create List
    FOR    ${element}    IN    @{elements}
        ${text}=    Get Text    ${element}
        Append To List    ${names}    ${text}
    END
    RETURN    ${names}

Get All Product Prices
    [Documentation]    Returns the list of product prices (as numbers) in their current display order.
    Wait Until Element Is Visible    ${INVENTORY_ITEM_PRICE}    timeout=${TIMEOUT}
    ${elements}=    Get WebElements    ${INVENTORY_ITEM_PRICE}
    ${prices}=    Create List
    FOR    ${element}    IN    @{elements}
        ${text}=    Get Text    ${element}
        ${clean}=    Remove String    ${text}    $
        ${price}=    Convert To Number    ${clean}
        Append To List    ${prices}    ${price}
    END
    RETURN    ${prices}

Convert Product Name To Slug
    [Documentation]    Converts a product name (e.g. "Sauce Labs Backpack") into
    ...    the slug saucedemo uses in its data-test attributes (sauce-labs-backpack).
    [Arguments]    ${product_name}
    ${slug}=    Evaluate    "${product_name}".lower().replace(" ", "-")
    RETURN    ${slug}

Add Product To Cart
    [Documentation]    Clicks "Add to cart" for the given product name, and
    ...    confirms the button flipped to "Remove" so the click is known to
    ...    have registered before moving on.
    [Arguments]    ${product_name}
    ${slug}=    Convert Product Name To Slug    ${product_name}
    Click Via Javascript    css:[data-test="add-to-cart-${slug}"]
    Wait Until Element Is Visible    css:[data-test="remove-${slug}"]    timeout=${TIMEOUT}

Remove Product From Cart
    [Documentation]    Clicks "Remove" for the given product name (from the
    ...    products page), and confirms the button flipped back to "Add to cart".
    [Arguments]    ${product_name}
    ${slug}=    Convert Product Name To Slug    ${product_name}
    Click Via Javascript    css:[data-test="remove-${slug}"]
    Wait Until Element Is Visible    css:[data-test="add-to-cart-${slug}"]    timeout=${TIMEOUT}

Get Cart Badge Count
    [Documentation]    Returns the number shown on the cart badge, or 0 if no badge is shown (empty cart).
    ${visible}=    Run Keyword And Return Status    Element Should Be Visible    ${CART_BADGE}
    IF    ${visible}
        ${count}=    Get Text    ${CART_BADGE}
        RETURN    ${count}
    END
    RETURN    0

Go To Cart
    [Documentation]    Opens the shopping cart page.
    Click Until Location Contains    ${CART_LINK}    cart.html
