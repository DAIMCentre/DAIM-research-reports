# Rebuild the Overleaf zip. Run this after changing daimreport.cls, main.tex,
# references.bib, README.md or the logo, or the download will go stale.
#
# Only the files needed to compile are included. main.pdf is deliberately left
# out: Overleaf produces its own output, and a stale PDF in the project is
# confusing. Aletheia.pdf and .gitignore are not needed either.
#
# The zip name becomes the Overleaf project name, so keep it descriptive.

Set-Location $PSScriptRoot

$zip = 'DAIM-Research-Report-Template.zip'
$contents = 'main.tex', 'daimreport.cls', 'references.bib', 'README.md', 'assets'

if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path $contents -DestinationPath $zip -CompressionLevel Optimal

Write-Host ("{0} rebuilt, {1:N0} KB" -f $zip, ((Get-Item $zip).Length / 1KB)) -ForegroundColor Green
