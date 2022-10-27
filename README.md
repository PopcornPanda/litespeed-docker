# litespeed-docker
![example workflow](https://github.com/PopcornPanda/litespeed-docker/actions/workflows/build-docker.yml/badge.svg)

Docker for litespeed

You should mount Your website to directory: ```/var/www/vhosts/${LS_DOMAIN}/```

## Configuration options via ENV variables:

##### LS_UID 
UID of internal user in docker, should be the same as owner of files
- default: 1001

##### LS_GID
GID of internal user in docker, should be the same as owner of files
- default: 1001

##### LS_USERNAME
Username for internal user in docker
- default: app-runner

##### ADMIN_USER
Username for litespeed dashboard
- default: admin

##### ADMIN_PASS
Password for litespeed dashboard
- default: admin

##### MODSEC
Enable Mod Security with owasp rules
- default: 0 (False)

##### LS_DOMAIN
Domain name and vhost name for website inside docker
- default: localhost

##### LS_ALIASES
Aliases for vhost name for website inside docker
- default: *

##### LS_SERIAL
Serial key of litespeed license. Provide this if You want to use Your full license.
By default, docker uses a trial key.
- default: none 

#### reCaptcha options
##### CAPTCHA_ENABLED
Enable litespeed build-in recaptcha
- default: 0 (False)

##### CAPTCHA_ENABLED
Enable litespeed build-in recaptcha
- default: 0 (False)

##### CAPTCHA_SITE
Google recaptcha site key
- default: None

##### CAPTCHA_SECRET
Google recaptcha secret key
- default: None

##### CAPTCHA_TRIES
How many tries user has before deny
- default: 5

##### CAPTCHA_LEVEL
How often captcha should be tested: 0-100

This indicates a percent of appearence (100% means always)
- default: None 
