#1) Итак сначала читаем с клавиатуры название проекта
$ProjectName=Read-Host -Prompt 'Input project name'
#... описание проекта
$Description=Read-Host -Prompt 'Input project description'
#Cоздадим репозиторий
$AccessToken = '8ce2a' #Generated by github settings!
#Сервеная сторона
#Когда пользователь хочет отправить the server authentication credentials it may use the Authorization field.
#
#The Authorization field is constructed as follows:
#
#The username and password are combined with a single colon.
#The resulting string is encoded using the RFC2045-MIME variant of Base64, except not limited to 76 char/line.
#The authorization method and a space i.e. "Basic " is then put before the encoded string.
#For example, if the user agent uses Aladdin as the username and OpenSesame as the password then the field is formed as follows:
#
#Authorization: Basic QWxhZGRpbjpPcGVuU2VzYW1l
#по википедии нам нужно преобразовать наш акстокен в 64 бит строку
$Base64Token = [System.Convert]::ToBase64String([char[]]$AccessToken);
#..дальше нам нужно по википедии cлово Basic и наш акстокен
$Headers =@{
Authorization = 'Basic {0}' -f $Base64Token;
};
$Body = @{
  name = $ProjectName;
  description =$Description;
}|ConvertTo-Json;
$result =Invoke-RestMethod -Headers $Headers -Uri https://api.github.com/user/repos -Body $Body -Method post | Format-Wide -Property clone_url -Column 1 | out-string
#| Select-String -Pattern "https://github.com/*"
$result = $result.trim()
If (-Not (Test-Path .\$ProjectName))
{

  New-Item .\$ProjectName -type directory | out-null
}
Set-Location -Path .\$ProjectName
If (-Not (Test-Path .\node_modules))
{

npm i gulp -save-dev -silent
}
If (-Not (Test-Path .\node_modules\browser-sync))
{

npm i browser-sync -save-dev -silent
}
New-Item .\gulpfile.js -ItemType "file" | out-null
$receivedContent = Get-Content -Path "..\__template\gulpfile.js"
Set-Content .\gulpfile.js -Value $receivedContent
If (-Not ( Test-Path ".\index.html" ))
{
New-Item .\index.html -ItemType "file" | out-null
#work/_template/index.html
$receivedContent = Get-Content -Path "..\__template\index.html"
Set-Content .\index.html -Value $receivedContent
}
#npm init
If (-Not (Test-Path .\$ProjectName))
{
  New-Item .\package.json -ItemType "file" | out-null
  Set-Content .\package.json -Value @"
  {
    "name": "$ProjectName",
    "version": "1.0.0",
    "description": "$Description",
    "main": "gulpfile.js",
    "dependencies": {
      "browser-sync": "^2.12.8",
      "gulp": "^3.9.1"
    },
    "devDependencies": {},
    "scripts": {
      "test": "echo \"Error: no test specified\" && exit 1"
    },
    "author": "",
    "license": "ISC"
  }
"@
}
New-Item .\.gitignore -ItemType "file" | out-null
#Get-Content from template
$receivedContent = Get-Content -Path "..\__template\.gitignore"
Set-Content .\.gitignore -Value $receivedContent
git init
git add .
git commit -m "First project commit"
git remote add currentRepo $result
git push currentRepo master
gulp watch

# SIG # Begin signature block
# MIIFuQYJKoZIhvcNAQcCoIIFqjCCBaYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUDlDZOuPgbU2C8gCu+9eg6Zj+
# qhKgggNCMIIDPjCCAiqgAwIBAgIQz/RnNYpemY5NuvIzjFmVzzAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xNjAyMTgxNTU3MjBaFw0zOTEyMzEyMzU5NTlaMBoxGDAWBgNVBAMTD1Bvd2Vy
# U2hlbGwgVXNlcjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANpqT6Qt
# n2ti0mzsf9R6JOzlVDlwagaW4TGMzPQ/+xnikiVA8tXTFgKw5F8lEw/UVTG/BDeS
# yyeknTpoPhg///hisy55+kGabxtXXu5IJdQiqBpDbB5jbLTHb4rDtHtOaK5GYxEM
# HuW9XuZzSE8GcpFwjA7g8aaV7NmjJ5ALww6hCnoua47xFJnSf+FZ1id4TU8OVeo1
# FNq2UzjQwkE8gxBugNgpvNTLxcXa0eqvSADRgvF6sz/jCpG8EWBjuVxBMKq384xc
# fMr6G0RRAyzkD+pdZKejefElPGScOGVCRKkcFa/R/sSjBr8xKN9VNYUNZWOh9MHZ
# lZQDgjYBUnaZjskCAwEAAaN2MHQwEwYDVR0lBAwwCgYIKwYBBQUHAwMwXQYDVR0B
# BFYwVIAQr6SFQbkyestk9Xe8A6y8/6EuMCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwg
# TG9jYWwgQ2VydGlmaWNhdGUgUm9vdIIQi2lIpyC1A6dLoCDA/FTNCzAJBgUrDgMC
# HQUAA4IBAQCQOEmI3EQ7pqRtx7cxqR+SqFAF9EwdVdNvB5xj3DV0v9UjsTbFiHoY
# zXvPlq3rL0YpMc9rCpojJb1r+GEfdrKTseKww2fpdG5ELw2QYqyAil42DlcDY1W5
# olPEu0y9gGDefsqFFok+VSsVsB/CIxq+vfUAnFI48alJa/dxLVybMSt60bTNuOI+
# aU2eA58pTnfCuesVat7NVsXRVy9I9VqLXCeqNCn6IW6X9j1/vpLTEEonA2xFSVpX
# DIgocPdHKi08jOCFnpl1AN9+9Az87A/3eOET53VE8CsrQozqdOyC/KvDUXJ+/ULw
# jSCZFfXOGjt+T1lUKDX7pFOAheI0Ap+aMYIB4TCCAd0CAQEwQDAsMSowKAYDVQQD
# EyFQb3dlclNoZWxsIExvY2FsIENlcnRpZmljYXRlIFJvb3QCEM/0ZzWKXpmOTbry
# M4xZlc8wCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJ
# KoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQB
# gjcCARUwIwYJKoZIhvcNAQkEMRYEFDYgk734n8Jz/ap6ek8jETcm/RLGMA0GCSqG
# SIb3DQEBAQUABIIBAHarhYgBD8CnMOrMY0zPqlHJXCfgYYY0KXeXbM7m+KUY9JkT
# jnSgSuXDGZTpp1pv3oyVRgvBh/KcZ1ytbEpKFVp18fmwMiezKzBQuVjcP+toUpPL
# ETXpNsoCZI50LopBBjHyGC8Xi6maQ3+F9tTFZEvlvmxYzMcBP5BIYrdPvu0WJypJ
# 6ZoCe7XGlGLmIHxenGwhYNW2M+rJEPmxkeXirNO5xFz4PcwyS+sGfCsStWufYpW7
# Bs47Lwo1ZpvKubpylDhmkey6trwddGIo1BGMsGftlMV8JjUZEQv8DSds6kxU3p8K
# 7UpWukW3sL1n4gt7I4bCA0kdCUKhN6BhZaxNM3s=
# SIG # End signature block
