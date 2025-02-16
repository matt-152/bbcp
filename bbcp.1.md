% BBCP(1)
% Matthew Delaney \<MattDelaney\_948@protonmail.com\>
% February 16, 2025

# NAME

bbcp - Copy local files to Bitburner Home

# SYNOPSIS

**bbcp** \[SRC\]\.\.\. \<DST\>

# DESCRIPTION

Copy local files to Bitburner Home.

Uses the Steam version\'s API. Files must be valid script files (js, ts, etc.).

# OPTIONS

**-h**, **\--help**

**-V**, **\--version**

\[*SRC*\]\.\.\.

: Local files to upload. If \"-\", read from stdin.

\<*DST*\>

: Destination file/directory.

# ENVIRONMENT VARIABLES

*BB_API_TOKEN*\*

: Required. From API Server \> Copy Auth Token

*BB_API_URL*

: default: http://localhost:9990

# SETTING UP BITBURNER

With the Steam version running, go to the top bar, click the "API Server" drop
down. From there you can start and enable (start on game boot) the local API.

Also click "Copy Auth Token" and store that in the `BB_API_TOKEN` environment
variable for the tool to work.

# VERSION

1.0.1
