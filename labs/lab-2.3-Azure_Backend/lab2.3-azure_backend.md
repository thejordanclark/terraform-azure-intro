# Using Azure Backend

Lab Objective:
- Save Terraform state to backend in Azure storage

## Preparation

If you did not complete lab 2.2, you can simply copy the code from that lab as the starting point for this lab.

## Lab

Since we will want to show migration of state from local to remote, run terraform apply to ensure there is current state:

```
terraform apply
```

(If there was current state already, then the apply will show nothing to create; otherwise accept the changes to apply.)

![Nonempty Terraform state](./images/tf-show-apply.png "Nonempty Terraform state")

### Authenticate to Azure CLI

If you are running this lab in the Azure Cloud Shell, then Azure CLI authentication was already automatically done when you opened Cloud Shell.  

> If you are running this lab from a terminal shell outside of the Azure portal, then you would need to use the Azure CLI to authenticate by typing "az login" which will direct you to a browser login page to log into the Azure CLI.

### Update Terraform configuration

We will be configuring a backend to store the terraform state in an Azure storage blob.  The storage account and container were already set up prior to the class.  The backend state will be stored in a new blob created in the container.

Edit “main.tf” to add a backend for Azure.  Add the following as a sub-block in the terraform block.  *Make sure you are putting the new code inside the terraform block and not at the end of the file or another arbitrary location.*

```
  cloud {
    organization = "ABC-Labs"
    workspaces {
      name = "labs-XX"
  }
```

Your resulting terraform block should look as follows:
```
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  cloud {
    organization = "ABC-Labs"
    workspaces {
      name = "labs-XX"
  }
  required_version = ">= 1.3.0"
}
```

This will now direct the state to be saved in Terraform Cloud.  Since you changed the backend configuration, you will need to run terraform init again, but before we can do that we need to authenticate `terraform` with Terraform Cloud. We can do that by running terraform login.

Run:

```
terraform login
```

Follow the login instructions using the login information for TFC that the instructor provided.  The instruction will walk you through creating an access token for "terraform login".  You will copy that login token and provided it for terraform.  Once successfully logged in terraform will provide steps for an example configuration.  Skip that example as we will be building our own.

Now that your terraform has access to TFC we can now run terraform init.

Run:

```
terraform init
```

Terraform will then prompt you to migrate the existing state from the “terraform.tfstate” file to the backend in Azure.

Type “yes”

_Note: the screenshot may not match exactly as it shows using Azure backend instead of TFC._

![Terraform init with remote backend](./images/tf-init.png "Terraform init with remote backend")

Terraform will copy the state to TFC.  The state will be saved in a new TFC storage blob referenced in the backend configuration above.

Notice that the terraform.tfstate file is left remaining.  You should delete the file to avoid confusion.

```
rm terraform.tfstate*
```

To confirm that the state still exists, use terraform show.

```
terraform show
```

![Terraform remote state](./images/tf-remote-state.png "Terraform remote state")

---

By adding the Terraform Cloud section to the terraform block will now execute the plan and apply on TFC.  Running in the "Triggered via CLI" mode.  We now see that in the CLI when running terraform plan.

Run:

```
terraform plan
```

Notice the "Running plan in Terraform Cloud".  The CLI even provides links to vew the run in TFC.  Will a browser connect to it to view the plan info in TFC.

Now explore how the terraform apply is also run in TFC.

Run:

```
terraform apply
```

If you are new to Terraform Cloud.  Explore the interface, try to understand the data represented.

You may notice some variables set in your workspace.  Those variables that start with "ARM_" have been added to allow your TFC workspace to authenticate back to Azure to manage resources in your Azure subscription.
