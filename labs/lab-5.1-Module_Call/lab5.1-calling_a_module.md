# Creating an Azure Redis Cache using Terraform Module

Lab Objective:
- Utilize the Terraform module to create an Azure Redis Cache instance.

## Preparation

If you did not complete lab 4.6, you can simply copy the solution code from that lab (and do terraform apply) as the starting point for this lab.

## Lab

Explore the Terraform Registry to understand the available modules for Azure Redis Cache. Specifically, we will use the module from:

* [Claranet Redis Module on Terraform Registry](https://registry.terraform.io/modules/claranet/redis/azurerm/7.7.0)

Select version 7.7.0 for this lab.

Review the module documentation to understand its usage. Pay special attention to the required and optional input arguments. This module provides an abstraction over the Azure Redis Cache resource, simplifying its creation and configuration.

Create a new file named `redis.tf` in your Terraform project.

Using the module documentation as a reference, add a module configuration to create an Azure Redis Cache instance. Although this module supports various configurations, we will focus on a basic setup for this lab.

Key points for the module configuration:

* Explicitly specify the version as "7.7.0".
* Use inputs from your current Terraform configuration where applicable, ensuring consistency with your existing resources.
* Append a unique suffix to the `client_name` for the Redis instance to avoid naming conflicts.
* Exclude settings from the module that were not present in your existing resources.

After setting up the module, compare your code to the solution provided below.

<details>
<summary>Click to see the solution for the Redis module configuration</summary>

```hcl
module "redis" {
  source  = "claranet/redis/azurerm"
  version = "7.7.0"

  client_name              = "aztf-labs-redis-${random_integer.suffix.result}"
  environment              = "labs"
  location                 = local.region
  location_short           = "use"
  stack                    = "labs"
  resource_group_name      = azurerm_resource_group.lab.name
  logs_destinations_ids    = []

  capacity                 = 1
  cluster_shard_count      = 2
  data_persistence_enabled = false
  allowed_cidrs            = ["10.0.0.0/16"]

  extra_tags               = local.common_tags
}
```
</details>

### Terraform Commands

1. Initialize your Terraform configuration:
   ```
   terraform init
   ```
2. Validate your configuration:
   ```
   terraform validate
   ```
3. Plan and review the changes:
   ```
   terraform plan
   ```
4. Apply the changes:
   ```
   terraform apply
   ```

:bangbang: NOTE: Azure takes a while to create the Redis cache.  Expect it to be 10 minutes or more.

### Discussion Questions

1. Why is `terraform init` necessary when adding a new module?
2. How does using a module simplify the process of creating an Azure Redis Cache?
3. What are the benefits of appending a unique suffix to resource names in a shared environment?

---

## Working with Private Terraform Modules

### Objective:
- Learn how to use private modules hosted on Terraform Cloud.
- Modify the existing Terraform configuration to use a private version of the Redis module.

### Explore Terraform Cloud's Private Module Registry

Terraform Cloud offers the capability to host private modules, making them accessible only to your organization. This feature is particularly useful for custom modules tailored to your organization's specific needs.

1. **Explore Private Modules**: Log in to your Terraform Cloud account and navigate to your organization's private module registry. 

2. **Locate the Redis Module**: In the Terraform Cloud web interface, search for the "redis" module within the private module registry. Note the differences between the public and private versions of the module.

### Update Terraform Configuration

Now, update your Terraform configuration to use the private version of the Redis module hosted on Terraform Cloud.

1. **Modify `redis.tf`**: Change the source of the Redis module to point to the private module hosted on Terraform Cloud. The new source should be something like `"app.terraform.io/ABC-Labs/redis/azurerm"`. Make sure to use the correct organization name and module path.

   ```hcl
   module "redis" {
     source  = "app.terraform.io/ABC-Labs/redis/azurerm"
     version = "0.1.0"

     # ... (rest of the configuration remains the same)
   }
   ```

2. **Apply the Changes**: 
   - Run `terraform init` to initialize the new module source.
   - Validate and apply your configuration as usual.

### Terraform Commands

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

### Discussion and Reflection

- Discuss the benefits of using private modules in Terraform Cloud. How does it enhance module management and security within an organization?
- Reflect on the process of transitioning from a public module to a private module. What considerations are important when making this transition?

