*** Comments ***
# Shared Suite Setup / Teardown keywords for all UI suites.
# Centralizes browser creation so every test suite gets the same
# headless-aware Chrome configuration (Selenium 4.6+ Selenium Manager
# resolves the chromedriver automatically - no driver manager dependency
# needed).


*** Settings ***
Library     SeleniumLibrary
Resource    variables.robot


*** Keywords ***
Open Browser With Options
    [Documentation]    Opens Chrome (headless when ${HEADLESS} is true) and
    ...    navigates to ${BASE_URL}, then applies the standard timeouts.
    ${options}=    Get Chrome Options
    Open Browser    ${BASE_URL}    ${BROWSER}    options=${options}
    Set Selenium Timeout    ${TIMEOUT}
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}
    Maximize Browser Window

Get Chrome Options
    [Documentation]    Builds a selenium.webdriver.ChromeOptions object,
    ...    adding headless / CI-friendly flags when required.
    ${is_headless}=    Convert To Boolean    ${HEADLESS}
    ${options}=    Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver
    IF    ${is_headless}
        Call Method    ${options}    add_argument    --headless\=new
        Call Method    ${options}    add_argument    --window-size\=1920,1080
    END
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --disable-notifications
    Call Method    ${options}    add_argument    --disable-infobars
    RETURN    ${options}

Close All Browsers And Cleanup
    [Documentation]    Suite Teardown counterpart to `Open Browser With Options`.
    Close All Browsers

Click Via Javascript
    [Documentation]    Clicks ${locator} by dispatching a native click event
    ...    through JavaScript instead of SeleniumLibrary's coordinate-based
    ...    native click. Saucedemo's SPA occasionally drops the native
    ...    WebDriver click in headless Chrome (the element is visible,
    ...    enabled and on top, but nothing happens) - a JS-dispatched click
    ...    on the located element is reliable.
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=${TIMEOUT}
    Wait Until Element Is Enabled    ${locator}    timeout=${TIMEOUT}
    ${element}=    Get WebElement    ${locator}
    Execute Javascript    arguments[0].click();    ARGUMENTS    ${element}

Click Until Location Contains
    [Documentation]    Clicks ${locator} (via JavaScript, see `Click Via
    ...    Javascript`) and confirms the URL changed to contain
    ...    ${url_fragment}, retrying the click itself a couple of times as a
    ...    Robot-native safety net (not a blind, fixed-length `Sleep`) in
    ...    case the element wasn't quite ready yet.
    [Arguments]    ${locator}    ${url_fragment}    ${retries}=3x    ${retry_interval}=1s
    Wait Until Keyword Succeeds    ${retries}    ${retry_interval}
    ...    Click And Verify Location Changed    ${locator}    ${url_fragment}

Click And Verify Location Changed
    [Arguments]    ${locator}    ${url_fragment}
    Click Via Javascript    ${locator}
    Wait Until Location Contains    ${url_fragment}    timeout=3s
