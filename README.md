# certstoretopem - Dump Windows Certificate Store in PEM suitable for use with OpenSSL 

When run, `certstoretopem` dumps all certificates that are valid for server authentication from the user's root certificate store to stdout in PEM format.

Install with `cargo install https://github.com/mcgoo/certstoretopem`

The repo also contains a powershell script `get-root-cas.ps1` with the same functionality.