## Free Electron / Bravo Onboarding

Sinatra webapp built as part of engineering onboarding. 

Topics covered
- BL's commit and PR standards
- Ticket flow and organization
- Docker
- Repo organization
- BL Ruby code patterns using BL's rubocop configuration
- Various testing types and what business logic is considered within tests
- Testing with stub requests

## Owners & Contact

This project is owned by the [Free Electron](https://blacklane.atlassian.net/wiki/spaces/PREP/overview?homepageId=629702956) team. You can get in touch with us via:
- Slack: `#it-free-electron`
- Email: `it-free-electron@blacklane.com`

## Installation

**1. Clone the repository**

```
git clone git@github.com:blacklane/bravo-onboarding.git
````

**2. Install Ruby Gems**
```
$ bundle install
```

**3. Run locally**
```
$ ruby myapp.rb
```

### Docker

**1. Build Docker Image**

```
$ docker build --tag hello .
```

**2. Run Docker Image**

```
$ docker run -p 80:4567 hello
```

**3. Open Localhost**
```
$ open http://localhost
```
