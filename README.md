# bbcp - Bitburner local file upload tool

Tool to upload local files to BitBurner Home via the Steam version's API.

## Building and Installing / Uninstalling

The following packages are needed to install this project:
- [argc](https://github.com/sigoden/argc): Main build tool and command runner
- [pandoc](https://github.com/jgm/pandoc): For compiling the manpage
- curl: Used in the script to make the API requests

All these packages are likely available from your preferred package manager, if
they aren't installed already.

When all the dependencies are installed, just run `argc install` from project
root to install the package. If you want to uninstall, run `argc uninstall` from
project root.

## Setting up BitBurner

With the Steam version running, go to the top bar, click the "API Server" drop
down. From there you can start and enable (start on game boot) the local API.

Also click "Copy Auth Token" and store that in the `BB_API_TOKEN` environment
variable for the tool to work.

