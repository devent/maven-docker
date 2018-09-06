# Apache Archiva

## Description

* https://archiva.apache.org

> Apache Archiva™ is an extensible repository management software that helps taking care of your own personal or enterprise-wide build artifact repository. It is the perfect companion for build tools such as Maven, Continuum, and ANT. 

### Key Features

* running as an unprivileged user on port 8080;
* static files copied to /var/www/html to be served by Nginx or Apache;
* seperate data directory;
* configurable database backend;

## Environment Parameters

| Variable | Default | Description |
| ------------- | ------------- | ----- |
| ARCHIVA_REQUEST_LOG_DIR | `/var/log/archiva` | Request log directory. |
| ARCHIVA_JETTY_LOGS_PATTERN | `request-yyyy_mm_dd.log` | Jetty logs pattern. |
| ARCHIVA_JETTY_PORT | `8080` | Jetty HTTP port. |
| JAVA_INITIAL_MEMORY | 500 | Initial Java heap memory. |
| JAVA_MAX_MEMORY | 500 | Maximum Java heap memory. |
| JAVA_MAX_PERM_SIZE | 128m | Maximum Java perm memory. |
| DB_TYPE | derby | Database type: derby or mysql. |

If database type is set to `mysql`:

| Variable | Default | Description |
| ------------- | ------------- | ----- |
| DB_NAME | archiva_users | Database name. |
| DB_USER | archiva | Database user name. |
| DB_PASSWORD | archiva | Database password. |
| DB_HOST | db | Database host. |
| DB_PORT | 3306 | Database port. |

## Exposed Ports

| Port | Description |
| ------------- | ----- |
| 8080  | http |

## Directories

| Path | Description |
| ------------- | ----- |
| `/var/www/html`  | www-root directory. |
| `/data` | Archiva data directory. |

## Input Configration

| Source | Destination |
| ------------- | ------------- |
| `/conf-in/*.xml` | `/var/www/html/conf` |
| `/conf-in/*.conf` | `/var/www/html/conf` |
| `/lib-in/*.jar` | `/var/www/html/lib` |

## Test

The docker-compose file `test.yaml` can be used to startup the test containers.

```
make test | tee log.txt
```

## License

Apache Archiva is licensed under the [Apache License, version 2.0](http://www.apache.org/licenses/) license.

This docker image is licensed under the [MIT](https://opensource.org/licenses/MIT) license.

Copyright 2018 Erwin Müller

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
