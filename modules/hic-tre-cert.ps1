# Install the HIC CA certificate
@"
-----BEGIN CERTIFICATE-----
MIIFhzCCA2+gAwIBAgIUGkv4GNM1HgQ9SYiUkSFuQ8GOg+UwDQYJKoZIhvcNAQEF
BQAwbDELMAkGA1UEBhMCR0IxPjA8BgNVBAoMNUhlYWx0aCBJbmZvcm1hdGljcyBD
ZW50cmUgKEhJQyksIFVuaXZlcnNpdHkgb2YgRHVuZGVlMR0wGwYDVQQDDBRoaWMt
dHJlLmR1bmRlZS5hYy51azAeFw0yNDA4MDYxMjI0MzFaFw0zNDA4MDQxMjI0MzFa
MGwxCzAJBgNVBAYTAkdCMT4wPAYDVQQKDDVIZWFsdGggSW5mb3JtYXRpY3MgQ2Vu
dHJlIChISUMpLCBVbml2ZXJzaXR5IG9mIER1bmRlZTEdMBsGA1UEAwwUaGljLXRy
ZS5kdW5kZWUuYWMudWswggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCz
64v2cNSAC8IvzMzzGT7n2CcsdO9u2iZkJYIVWoR/sYo+ScPn5DUWILMPUc8gTOQh
fOoOk8SBS2zoUSoIr1Z6hNqkkar6YvkZgqA9hs7AmKC7SxQPCQMHDndAKKy/PmR5
FbSKmZV+6KStEmcNCJ6hWqiP3rRV9wjGfS+wsUe52lHIbIlQSb3KPZ+7wXr/Rwby
D2eb+RAVszNX06nFTHPx44CTftxTW4BTB9hgpfcn8GYIkNPTj1A3lifYJ1Y1MC2j
R7ZUCSx6kum9TBj/zXztQejvxw7JrYbf0BX1iXQ88W74r4OnLB+xP9h1OEhMZ5hQ
+4dq4xngcI11B7VRf0QDcoAPt9u0b/CNKj4nXWR+7MNSoOR5dYt0GneMqwqA7MLY
vw+Al7N2IOmG0BgIOz25ZIEiL4VTDHZuwEsLuvr0kVbPygZGeLDrSj5k7GrLzILO
ei/dGt7lrK92NzGEJDv3x72cLvwthHMLefVE+nFJLJnQuVhuoi7L2c4oxsSuE9nJ
M3TpZ3pJIIiksghlrKDey5Bfkr/yOpNIWz53oKGXBT4JgihagBxfvILIjPVhE/5q
zt3Wic8UiIgSmHnh1BSMwhd/yPAfIUVsYUEURFyebmcN33VSzUP8qO5tycOuAYDX
qg4MHgjLchvlbE71mN1+SHA/w7aok40ujvRxIEVbDQIDAQABoyEwHzAdBgNVHQ4E
FgQUQVp7Aq/wQN19Ax32zbaH4VrJlJQwDQYJKoZIhvcNAQEFBQADggIBAFw/TQOy
LM2dXTpBJ0hPwpjwaDNHlGkI4KWuIIZANlnAcxRTNiRhm3Km8HUo2tat6dq/Y+6p
Td329tYzHsMYkECfuvjWDsVlfqFHalxlPEPgmo2cuKIgNi3sGMK9Eh3NwHFxH/5W
h8q6gis+5wSzJ23jEMaEl3p/wkvaZnazDePq66Wi5LNeXiD1vsTXedfsg+FynhDr
SqLOftAem/d5eNP1QWHUAcLHYdmzeZ9xSuTlNcv0/EqqG4NAf5qc4C9O1uvIm8kR
koJQIUs7sBOFaY1OzYnnaF96OYBbvfeoqYkMYbSKqYpmaKRgRffwajkjaGxZwcNs
FzlvfAKi3SDN4ryhIMb4uCRfUwzOXQ0Kx3TNitTrLGI7dI10al6ZcjNIURJTRhrl
eFrVvY2Vhrt5yxHaKf6Po/Sts+/D0P6C/UxdKyyxOVH/auju2xX4ETvR7Qm5g0Er
9N/EmmP5xDCv6QdS+YQk8K39aUvtK30LafCofBNcN91bpEiWKEGBZJfsrsJYwoan
TaVEtXbOrFKFgzFeVOFfycfSahb85bdWy3Fpnj4UWc5rPrIM0bl2bAH6ZgtmqYaq
3vMj23QxEFtXi10HnVuPU4fXoIdurGiktpsi+bkAvED7pm8T64Fiky8HPF5okuof
Y0yM9+mo8F2AD8Y/LGuxWBsxTK317zfQiRLc
-----END CERTIFICATE-----
"@ | Out-File -FilePath C:\workdir\hic-tre.dundee.ac.uk.crt

Get-Item C:\workdir\hic-tre.dundee.ac.uk.crt | `
  Import-Certificate -CertStoreLocation Cert:\LocalMachine\Root
