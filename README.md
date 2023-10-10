# Cotton backend app
Cotton CRUD backend in Swift using Vapor. Main goals are:
- ability to sync web browser tabs between multiple iOS/Android clients
- show friends top sites
- privacy related features (e.g. VPN, DNS over HTTPS, etc.)

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
- copy generated certificate files to `./Resources/Certs`

How to build
-----------------
Xcode is not available on Linux, so that, have to build from command line. Also, it is not trivial to set custom build directory in Xcode, e.g. to be able to copy some resources to the same folder with app executable.
- `swift package --build-path ./Build/Debug build`
