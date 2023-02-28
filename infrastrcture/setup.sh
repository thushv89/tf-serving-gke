while getopts u:p:r: flag
do
    case "${flag}" in
        u) userEmail=${OPTARG};;
        p) project=${OPTARG};;
        r) region=${OPTARG};;
    esac
done

if [[ $BASH_SOURCE = */* ]]; then
    scriptDir=${BASH_SOURCE%/*}
else
    scriptDir=.
fi
echo "The script is located in ${scriptDir}"

basicConfigDir="${scriptDir}./gcp_config"
mkdir -p .gcp_config
echo "Setting up the config with userEmail=${userEmail}, project=${project} and region=${region}"
echo "{\"gcp_user\":\"${userEmail}\", \"gcp_project_id\":\"${project}\", \"gcp_region\":\"${region}\"}" | tr -d '\n'  > ${basicConfigDir}/basic_config.json