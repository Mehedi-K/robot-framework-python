*** Comments ***
# Page object covering the three checkout steps: information, overview, complete.


*** Settings ***
Library     SeleniumLibrary
Resource    ../variables.robot
Resource    ../common.robot


*** Variables ***
${FIRST_NAME_INPUT}    id:first-name
${LAST_NAME_INPUT}     id:last-name
${POSTAL_CODE_INPUT}   id:postal-code
${CONTINUE_BUTTON}     css:[data-test="continue"]
${CHECKOUT_ERROR}      css:[data-test="error"]
${FINISH_BUTTON}       css:[data-test="finish"]
${CANCEL_BUTTON}       css:[data-test="cancel"]
${SUMMARY_TOTAL}       css:[data-test="total-label"]
${COMPLETE_HEADER}     css:[data-test="complete-header"]
${COMPLETE_TEXT}       css:[data-test="complete-text"]


*** Keywords ***
Fill Checkout Information
    [Documentation]    Fills in step one of checkout (customer information) and
    ...    continues, expecting a successful move to step two. For negative
    ...    cases (e.g. a required field left blank) use `Fill Checkout Fields`
    ...    and `Click Continue` separately instead.
    [Arguments]    ${first_name}    ${last_name}    ${postal_code}
    Fill Checkout Fields    ${first_name}    ${last_name}    ${postal_code}
    Click Until Location Contains    ${CONTINUE_BUTTON}    checkout-step-two.html

Fill Checkout Fields
    [Documentation]    Fills in step one's form fields without submitting.
    [Arguments]    ${first_name}    ${last_name}    ${postal_code}
    Wait Until Element Is Visible    ${FIRST_NAME_INPUT}    timeout=${TIMEOUT}
    Wait Until Keyword Succeeds    3x    0s
    ...    Type Checkout Fields And Confirm They Held    ${first_name}    ${last_name}    ${postal_code}

Type Checkout Fields And Confirm They Held
    [Documentation]    Keystrokes sent before the React form finishes wiring its
    ...    handlers are reset to empty on its next render (seen intermittently
    ...    on CI with Chrome 154), so re-read the values after a short settle.
    [Arguments]    ${first_name}    ${last_name}    ${postal_code}
    Input Text    ${FIRST_NAME_INPUT}    ${first_name}
    Input Text    ${LAST_NAME_INPUT}    ${last_name}
    Input Text    ${POSTAL_CODE_INPUT}    ${postal_code}
    Sleep    0.5s
    Textfield Value Should Be    ${FIRST_NAME_INPUT}    ${first_name}
    Textfield Value Should Be    ${LAST_NAME_INPUT}    ${last_name}
    Textfield Value Should Be    ${POSTAL_CODE_INPUT}    ${postal_code}

Click Continue
    [Documentation]    Clicks Continue on step one without asserting the outcome
    ...    (used for negative scenarios where an error is expected instead).
    Click Via Javascript    ${CONTINUE_BUTTON}

Verify On Checkout Overview Page
    [Documentation]    Confirms step two (order overview) is displayed.
    Wait Until Location Contains    checkout-step-two.html    timeout=${TIMEOUT}
    Wait Until Element Is Visible    ${SUMMARY_TOTAL}    timeout=${TIMEOUT}

Get Order Total
    [Documentation]    Returns the "Total:" label text from the order overview.
    Wait Until Element Is Visible    ${SUMMARY_TOTAL}    timeout=${TIMEOUT}
    ${text}=    Get Text    ${SUMMARY_TOTAL}
    RETURN    ${text}

Complete Checkout
    [Documentation]    Clicks Finish on the order overview page and confirms
    ...    the browser actually navigated to the confirmation page.
    Click Until Location Contains    ${FINISH_BUTTON}    checkout-complete.html

Verify Order Complete
    [Documentation]    Asserts the order confirmation page is shown.
    Wait Until Location Contains    checkout-complete.html    timeout=${TIMEOUT}
    Wait Until Element Is Visible    ${COMPLETE_HEADER}    timeout=${TIMEOUT}
    Element Text Should Be    ${COMPLETE_HEADER}    Thank you for your order!
