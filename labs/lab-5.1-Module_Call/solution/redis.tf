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