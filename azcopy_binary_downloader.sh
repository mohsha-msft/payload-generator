#!/bin/bash
# shellcheck disable=SC2034
location="azcopybinaries/10.13.0"
mkdir -p "$location"
wget https://azureblobstrgmohitcanada.blob.core.windows.net/azcopybinaries/azcopyV10.13.0.zip
unzip azcopyV10.13.0.zip -d "$location"
rm azcopyV10.13.0.zip


