## Free Electron / Bravo Onboarding

Getting familiar with Docker

## Owners & Contact

This project is owned by the [Free Electron](https://blacklane.atlassian.net/wiki/spaces/PREP/overview?homepageId=629702956) team. You can get in touch with us via:
- Slack: `#it-free-electron`
- Email: `it-free-electron@blacklane.com`

### Installation

**1. Clone the repository**

```
git clone git@github.com:blacklane/bravo-onboarding.git
````

** 2. Install Ruby Gems
```
$ bundle install
```

** 3. Run locally
```
$ ruby myapp.rb
```

### Docker

** 1. Build Docker Image

```
$ docker build --tag hello .
```

** 2. Run Docker Image

```
$ docker run -p 80:4567 hello
```

** 3. Open Localhost
```
$ open http://localhost
```