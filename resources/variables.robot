*** Comments ***
# Global variables shared across all test suites.
# HEADLESS can be supplied via OS environment variable (%{HEADLESS}) or
# overridden on the command line, e.g. `robot --variable HEADLESS:True tests/`


*** Variables ***
# --- UI target -------------------------------------------------------------
${BASE_URL}                https://www.saucedemo.com
${BROWSER}                 chrome
${HEADLESS}                %{HEADLESS=False}
${TIMEOUT}                 10s
${IMPLICIT_WAIT}           2s

# --- UI credentials ----------------------------------------------------------
${STANDARD_USER}           standard_user
${LOCKED_OUT_USER}         locked_out_user
${PROBLEM_USER}            problem_user
${PASSWORD}                secret_sauce

# --- API target --------------------------------------------------------------
${API_BASE_URL}             https://reqres.in/api
