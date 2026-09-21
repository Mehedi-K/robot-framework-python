# Robot Framework + Python Test Automation

![Python](https://img.shields.io/badge/python-3.9%2B-blue?logo=python&logoColor=white)
![Robot Framework](https://img.shields.io/badge/robot%20framework-%E2%9C%93-brightgreen?logo=robotframework&logoColor=white)
![Selenium](https://img.shields.io/badge/selenium-4-43B02A?logo=selenium&logoColor=white)
![CI](https://github.com/Mehedi-K/robot-framework-python/actions/workflows/ci.yml/badge.svg)

A portfolio-grade UI + API test automation suite built with
[Robot Framework](https://robotframework.org/), Python, `SeleniumLibrary`, and
`RequestsLibrary`. It follows a page-object-style structure using Robot
**resource files** as page objects, and runs headless in CI on every push.

- **UI target:** [saucedemo.com](https://www.saucedemo.com/) — a demo
  e-commerce site purpose-built for Selenium practice. Tests cover login
  (valid, invalid, and locked-out users), product sorting, cart management,
  and the full checkout flow.
- **API target:** [reqres.in](https://reqres.in/api) — a public fake REST
  API. Tests cover the full user CRUD lifecycle (`GET`, `POST`, `PUT`,
  `DELETE`) and verify both status codes and response bodies.

## Project structure

```
robot-framework-python/
├── requirements.txt              # Python dependencies
├── .github/workflows/ci.yml      # GitHub Actions pipeline (headless run + artifact upload)
├── resources/
│   ├── variables.robot           # BASE_URL, API_BASE_URL, browser, timeouts, HEADLESS flag
│   ├── common.robot              # Shared Suite Setup/Teardown (browser lifecycle)
│   └── page_objects/
│       ├── login_page.robot      # Login form locators + keywords
│       ├── products_page.robot   # Inventory page: sorting, add/remove from cart
│       ├── cart_page.robot       # Cart page locators + keywords
│       └── checkout_page.robot   # Checkout steps 1-3 locators + keywords
├── tests/
│   ├── ui/
│   │   ├── login.robot           # Valid login, invalid login, locked-out user
│   │   ├── sorting.robot         # Sort by name / price, ascending / descending
│   │   ├── cart.robot            # Add/remove products, cart badge count
│   │   └── checkout.robot        # Full end-to-end checkout flow
│   └── api/
│       └── users_api.robot       # GET/POST/PUT/DELETE against /api/users
└── results/                      # Robot output (log.html, report.html, output.xml) — gitignored
```

Page objects are implemented as Robot **resource files**: each defines its
own locators (as `*** Variables ***`) and the keywords that act on them, and
test suites in `tests/` compose those keywords instead of talking to
`SeleniumLibrary` directly.

## Prerequisites

- Python 3.9+
- Google Chrome (any recent version — Selenium 4.6+ ships **Selenium
  Manager**, which resolves the matching `chromedriver` automatically, so no
  separate driver/driver-manager install is required)
- `pip`

## Setup

```bash
git clone https://github.com/Mehedi-K/robot-framework-python.git
cd robot-framework-python
python3 -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

## Running the tests

Run everything (UI + API), with a visible browser:

```bash
robot -d results tests/
```

Run headless (what CI does):

```bash
robot -d results --variable HEADLESS:True tests/
```

`HEADLESS` can also be set via an environment variable instead of a Robot
`--variable` flag:

```bash
HEADLESS=True robot -d results tests/
```

Run only the UI or only the API suite:

```bash
robot -d results tests/ui/
robot -d results tests/api/
```

Run a single suite or filter by tag:

```bash
robot -d results tests/ui/login.robot
robot -d results --include login tests/
```

After a run, open `results/report.html` for the summary and `results/log.html`
for the detailed, clickable execution log.

## Continuous Integration

`.github/workflows/ci.yml` runs the full suite headless on every push/PR to
`main`, using the Chrome that's preinstalled on GitHub's `ubuntu-latest`
runners. The `results/` directory (`log.html`, `report.html`, `output.xml`)
is uploaded as a build artifact on every run, including failed ones, so a
failure can be triaged straight from the Actions tab without re-running
locally.

## Notes on the targets under test

- **saucedemo.com** exposes several demo accounts, all sharing the password
  `secret_sauce`: `standard_user` behaves normally, `locked_out_user` is
  rejected with an error message. Both are exercised here.
- **reqres.in** is a public mock API: its `PUT`/`DELETE`/`POST` endpoints are
  simulated (they validate input and return realistic responses/status
  codes, but don't persist data server-side). Requests are sent with an
  `x-api-key: reqres-free-v1` header for forward compatibility — as of
  writing, reqres.in's `/api/users` endpoints also work fine without any key,
  but the free-tier key is included per reqres.in's own docs in case that
  changes.
