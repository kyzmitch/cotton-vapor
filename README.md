# Cotton backend app
Cotton CRUD backend in Swift using Vapor

How to install
-----------------
### Prepare Vapor framework
Use following official doc https://docs.vapor.codes/getting-started/hello-world/. Project was created using `vapor new cotton-vapor -n` command.
- `brew install vapor`

### Install DB
There are two options:
1) UI which doesn't require root account https://postgresapp.com/downloads.html
2) Command line:
- `brew tap homebrew/core` to update brew
- `brew install postgresql`

### Run DB
TBD, not fully working steps:
1) `postgres`
2) `psql --dbname=cotton --host=localhost --port=5432 --no-password`

### Support HTTPS/TLS
- `brew install mkcert` install a little more easy to use tool instead of OpenSSL
- `mkcert -install`to create local certificate authority to mark cert as green in browser
- `mkcert localhost 127.0.0.1` create a new certificate for specific hostnames/domains
