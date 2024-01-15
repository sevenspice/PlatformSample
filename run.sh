currentDirectory=`pwd | awk -F "/" '{ print $NF }'`
rm -rf "$currentDirectory.pdx"
pdc -k source "$currentDirectory.pdx"
PlaydateSimulator "$currentDirectory.pdx"
