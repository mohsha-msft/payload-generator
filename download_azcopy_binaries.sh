#!/bin/bash
# shellcheck disable=SC2034
sudo apt-get install unzip
#versions=("10.4.3" "10.5.1" "10.7.0" "10.8.0" "10.12.0" "10.13.0")
versions=("10.4.3" "10.5.1" "10.7.0" "10.8.0" "10.12.0" "10.13.0")
for version in "${versions[@]}"
do
   echo "Downloading AzCopy: $version"
   location="azcopy_binaries/$version"
   mkdir -p "$location"
   zip_name="azcopyV$version.zip"
   wget "https://azureblobstrgmohitcanada.blob.core.windows.net/azcopybinaries/$zip_name"
   unzip $zip_name -d $location
   rm azcopyV$version.zip
done

