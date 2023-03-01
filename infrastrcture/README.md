## Prerequisites
### On Linux
* Open up a terminal
* `cd` into the `${PROJECT_DIR}`
### On Windows
* Open up powershell
* cd into the `${PROJECT_DIR}`
* Type `bash` and it will take you to a bash environment

Make sure `gcloud` is [installed](https://cloud.google.com/sdk/docs/install).

Run `gcloud auth login` and complete your GCP login

## Steps
1. Make sure you have [installed terraform](https://developer.hashicorp.com/terraform/downloads)
2. cd into `./infrastructure`
3. Run `./setup.sh -u <user name> -p <project id> -r <region>`, this will be stored in a json file locally.
4. Run `terraform init`, this will install the provide plugin and local modules
5. I have decoupled the creation of the GCS bucket, as creating and deleting it everytime you spin down the cluster would be cumbersome (as we need this bucket to hold our model, it's preferred to keep it fixed once it's created.)
   1. So first time you run `plan` or `apply`, use `terraform plan/apply -var="include_module_storage=true"` which will create the bucket for you. You can leave this option out in the consecutive runs, so that the bucket won't be affected by the terraform changes you run.
6. Run `terraform plan`, this will show you the changes terraform will be making
7. Run `terraform apply`
  * This will create a service account with necessary permissions and bind your personal account to the service account, so you can run commands as the service account
  * Next, it will create the cluster
  * Optionally, it can create the GCS bucket for storing the model and other config 
7. If you want to spin down the resources, run `terraform destroy`

## Notes
* On Windows, you may have to use `terraform.exe` instead of `terraform`

