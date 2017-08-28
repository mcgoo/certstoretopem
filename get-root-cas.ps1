# Generate a ca-bundle.crt from the Windows Certificate Store

# Limitations
#
# the windows cert store on any given computer only contains a subset of the 
# available root certs. when verification against an unknown root cert is 
# attempted, windows will go out to windows update to see if the cert is available
# and if so will add it to the local store.
#

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function eku_contains_server  {
    param($eku)
    $eku | ForEach-Object {
        if($_.ObjectId -eq "1.3.6.1.5.5.7.3.1") {      
             return $true
        }
    }
    return $false
}

$all = ""
Get-ChildItem -path cert:\LocalMachine\AuthRoot | ForEach-Object {

    if ( eku_contains_server -eku $_.EnhancedKeyUsageList ) {
        $all += $_.FriendlyName
        $all += "`n"
        $all += "=" * $_.FriendlyName.length
        $all += "`n"
        $all += "-----BEGIN CERTIFICATE-----`n"
        $der = $_.export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert)
        $all += [System.Convert]::ToBase64String($der, [System.Base64FormattingOptions]::InsertLineBreaks)
        $all += "`n-----END CERTIFICATE-----`n`n"
    }
}

write-output $all | out-file "ca-bundle.crt" -encoding utf8
