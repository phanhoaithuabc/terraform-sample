# Getting Started with GCP

## Example Two

We're going to authenticate using a service account key and use Terraform Cloud to run the configuration. The configuration will create a project based on a prefix name, enable some services, and return the project-id as output. We're first going to need to set up a service account key with the proper permissions and then add the contents of the service key as an environment variable in Terraform Cloud.

You'll need to have a GCP organization to follow along with this one. If you don't already have an organization set up, it's not terribly difficult to do. Follow along with the directions [here](https://cloud.google.com/resource-manager/docs/creating-managing-organization#setting-up). The account you're using will need permissions to make organization level changes. Assuming you're the one setting all this up, you probably already have the necessary permissions.

The next set of directions are based heavily on [this tutorial](https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform) from GCP. You should already be logged in with to the Google Cloud SDK with an account that has the necessary permissions in your organization. Next we'll get the organization id and billing account to use for the Terraform configuration and other commands.

In both commands, we are selecting the first result from the list of organizations and billing accounts. If you have multiple of either, you may need to tweak the commands to find the proper result.

```bash
ORG_ID=$(gcloud organizations list --format=json | jq .[0].name -r | cut -d'/' -f2)
BILLING_ACCOUNT=$(gcloud beta billing accounts list --format=json | jq .[0].name -r | cut -d'/' -f2)
```

Next up, we'll create an admin project to hold all the resources used to manage a project separate from the created projects. We'll call this project `terraform-admin-#####`.

```bash
PROJECT_ID="terraform-admin-${RANDOM}"

gcloud projects create ${PROJECT_ID} \
  --organization ${ORG_ID} \
  --set-as-default

gcloud beta billing projects link ${PROJECT_ID} \
  --billing-account ${BILLING_ACCOUNT}
```

Now we are going to create the service account that Terraform Cloud will use to create new project. We're going to download the service account key file, and later copy it into an environment variable in our Terraform Cloud configuration. We're also giving the service account the necessary permissions in the organization and project.

```bash
gcloud iam service-accounts create terraform \
  --display-name "Terraform Cloud account"

gcloud iam service-accounts keys create ~/${PROJECT_ID}-key.json \
  --iam-account terraform@${PROJECT_ID}.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/viewer

gcloud organizations add-iam-policy-binding ${ORG_ID} \
  --member serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/resourcemanager.projectCreator

gcloud organizations add-iam-policy-binding ${ORG_ID} \
  --member serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/billing.user

```

And finally we'll enable some APIs, because that's how things work in GCP:

```bash
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable serviceusage.googleapis.com
```

Now in Terraform Cloud, go ahead and create a Workspace called `gcp-getting-started` that uses a CLI-driven workflow. Then create the following variables in the workspace:

* `billing_account`
* `org_id`

Use the values stored in `$ORG_ID` and `$BILLING_ACCOUNT` and set the values as sensitive.

```bash
echo $BILLING_ACCOUNT
echo $ORG_ID
```

Next we will set the environment variable for the GCP credentials. Copy the contents of the the service account key file:

```bash
jq . -c ~/${PROJECT_ID}-key.json
```

And create an environment variable named `GOOGLE_CREDENTIALS` with the value set as sensitive. If you get an error that there are newlines, paste the string into an editor and see where the newline is.

Now we should be ready to create a project using Terraform. From the `ExampleTwo` directory, run the following.

```bash
# If you aren't logged into Terraform Cloud
terraform login

terraform init

terraform apply -auto-approve
```

The output from the run will be the project ID. You could now use this project to create resources!

You can clean things up by destroying the Terraform config, deleting the workspace, and deleting the admin project in GCP:

```bash
terraform destroy -auto-approve

gcloud projects delete ${PROJECT_ID} --quiet

rm ~/${PROJECT_ID}-key.json
```