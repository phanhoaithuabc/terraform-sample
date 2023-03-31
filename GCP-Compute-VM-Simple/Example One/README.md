# Getting Started with GCP

## Example One

Let's start really simple by creating a compute instance in an existing project with our local credentials. To do this, we'll first need to login into GCP and create a project to use. You will need a GCP account and the Google Cloud SDK installed locally. You can install the SDK by following the directions [here](https://cloud.google.com/sdk/docs/install).

Once you've installed the SDK, go ahead and run the following command to log in:

```bash
gcloud init
```

You're going to be prompted to log in. Select Y to login. Then you'll be provided with a link and hopefully a new browser window to log in from. In the browser window, select the Google account associated with your GCP account. Grant the Google Cloud SDK the permissions to access your account. 

Back at the command line, you'll be prompted to select a project or create a new one. Select an existing project, we'll create a new one shortly. The configuration is saved as `default`. If you haven't created a billing account, you'll need to do that now from the portal. Once we have a project created, we need to associate it with a billing account before we can spin up resources.

Now we'll create our new project and set Terraform up to use our current login:

```bash
PROJECT_ID=taconet-${RANDOM}
gcloud projects create $PROJECT_ID --set-as-default

gcloud auth application-default login
```

Once the project is created, we need to associate billing info with our new project. You'll need to either install the alpha commands for the Google Cloud SDK, or go to the console. If you're doing it through the console:

* Go into the cloud console
* Go into billing -> Account Management
* Select the My Projects tab
* Click on the Actions button for the new project and Change Billing
* Select the proper billing account and save the change

You'd think that's it, but wait there's more. **BEFORE** we use Terraform, we need to enable the Compute Engine service API.

```bash
gcloud services enable compute.googleapis.com
```
 
Finally, we get to do some Terraform stuff. From the `ExampleOne` directory, run the following:

```bash
terraform init

terraform validate

terraform plan -var gcp_project=${PROJECT_ID} -out ex1.tfplan

terraform apply ex1.tfplan
```

This will deploy a Compute Engine instance with a public IP address and Apache installed. We can verify by going to the address shown in the Terraform output. It may take up to 5 minutes for Apache to install after the instance is available.

Once you're done, you can clean up by running the following:

```bash
terraform destroy -var gcp_project=${PROJECT_ID} -auto-approve

gcloud projects delete ${PROJECT_ID} --quiet
```
