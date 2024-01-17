$currentDirectory = split-path . -Leaf
Remove-Item -Force -Recurse ".\$currentDirectory.pdx"
pdc -k source "$currentDirectory.pdx"
PlaydateSimulator "$currentDirectory.pdx"
