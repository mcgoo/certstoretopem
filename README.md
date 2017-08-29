# certstoretopem - Dump Windows Certificate Store in PEM suitable for use with OpenSSL [![Build status](https://ci.appveyor.com/api/projects/status/4ibw0tvtokn9b1k8/branch/master?svg=true)](https://ci.appveyor.com/project/mcgoo/certstoretopem/branch/master)



When run, `certstoretopem` dumps all certificates that are valid for server authentication from the user's root certificate store to stdout in PEM format.

Install with `cargo install --git https://github.com/mcgoo/certstoretopem`

The repo also contains a powershell script `get-root-cas.ps1` with the same functionality.

These programs only dump certificates that are present on the local machine - when presented with an unknown certificate, Windows will contact Windows Update and download and store other certificates if required. Certificates that are not part of the initially installed set that have not been subsequently downloaded will not be present in the output.