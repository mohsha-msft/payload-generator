container_name="publishresults"
path="/mnt/f/RandomData/base"
sas_validity_in_hrs=24

while getopts s:p: flag
do
    case "${flag}" in
        s) sas_validity_in_hrs=${OPTARG};;
        p) path=${OPTARG};;
        *)
            echo "Invalid flag";
                  exit 1;
              ;;
    esac
done

go run containers_handler.go "pubRes" "$locationB"

source="placeholder1"
destination="placeholder2"
i=0
while IFS="," read -r Location
do
 if [[ $i -eq 0 ]]
 then
  source=$Location
 else
   destination=$Location
 fi
 i=$i+1
done < publishResultsLocation.csv

azcopy_binaries/10.13.0/drop/azcopy_linux_amd64 copy $source $destination "--recursive"

#rm *.txt