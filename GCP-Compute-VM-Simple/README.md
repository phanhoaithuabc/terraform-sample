# Getting Started with GCP

## Authentication

Just like the AWS and Azure providers, there are multiple ways to authenticate to GCP. It really breaks down into three categories:

* CLI based login
* Identity based login
* File based login

Let's break those three options down a bit.

### CLI based login

You can authenticate using the identity associated with the Google Cloud SDK (aka gcloud CLI). Once you authenticate with the command `gcloud auth application-default login`, those credentials are cached locally. Terraform can find those creds and use them. This is similar to using `az login` or `aws configure` to set local credentials. It is also the preferred way to authenticate on your local workstation.

### Identity based login

If you are running Terraform from GCP, then you can take advantage of the account associated with the resource running Terraform. This is similar to an EC2 instance identity or Azure MSI. The *machine* has an identity and you can grant that identity permissions. Terraform will automatically discover the machine identity and use it, unless you override the provider authentication with a different form.

### File based login

Finally, you can authenticate using a service account key, which is a JSON file. You can pass the file location or the contents of that file directly to the provider using the `credentials` argument, or you can set the path or contents using one of three environment variables: `GOOGLE_CREDENTIALS`, `GOOGLE_CLOUD_KEYFILE_JSON`, `GCLOUD_KEYFILE_JSON`.

Why three different environment variables? Good question! Next question please. 

Just kidding! As far as I can tell, there is no difference between the three. Each is probably maintained for some backward compatibility thing. Personally, I would use `GOOGLE_CREDENTIALS` since it's the shortest and easiest for me to remember. YMMV.

## Enabling APIs

If the credentials you are using for your project have the proper permissions, you can enable APIs in your Terraform configuration directly. That might be overly permissive in your org, so check with internal best practices first. The syntax looks like this:

```terraform
resource "google_project_service" "service" {
  for_each = toset([
    "compute.googleapis.com",
    "appengine.googleapis.com",
    "appengineflex.googleapis.com",
    "cloudbuild.googleapis.com"

  ])

  service = each.key

  project            = google_project.project.project_id
  disable_on_destroy = false
}
```

There's many options here. You could create the project in your Terraform configuration, enable the proper APIs, and then create the necessary resources. You could have a separate Terraform configuration that creates projects for you and gives you a project ID with the proper APIs already enabled. Or you could have a manual process that creates projects, assigns permissions, and enables the proper APIs. I guess it all depends on your organization's preference.
