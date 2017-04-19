$local = Get-Location;

If(!(test-path $local/code)){
  Write-Host 'Folder code not exist....creating';
  New-Item -ItemType Directory -Path $local/code
}

If (vagrant plugin list | out-string -stream | select-string vbguest) {
  Write-Host 'VBGuest Installed already'
}
Else {
  vagrant plugin install vagrant-vbguest
}

vagrant up