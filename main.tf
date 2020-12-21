data "ibm_resource_group" "group" {
  name = "Default"
}

resource "ibm_resource_instance" "es_instance_1" {
  name              = "terraform-integration-1"
  service           = "messagehub"
  plan              = "standard" # "lite", "enterprise-3nodes-2tb"
  location          = "us-south" # "us-east", "eu-gb", "eu-de", "jp-tok", "au-syd"
  resource_group_id = data.ibm_resource_group.group.id

  # parameters = {
  #   service-endpoints     = "private"                    # for enterprise instance only, Options are: "public", "public-and-private", "private". Default is "public" when not specified.
  #   private_ip_allowlist = "[10.0.0.0/32,10.0.0.1/32]" # for enterprise instance only. Specify 1 or more IP range in CIDR format.
  #   # Refer private service endpoint and IP allow list to restrict access documentation, (/docs/EventStreams?topic=EventStreams-restrict_access) for more details.
  #   throughput   = "150"  # for enterprise instance only. Options are: "150", "300", "450". Default is "150".
  #   storage_size = "2048" # for enterprise instance only. Options are: "2048", "4096", "6144", "8192", "10240", "12288". Default is "2048".
  #   Note: When throughput is "300", storage_size starts from "4096",  when throughput is "450", storage_size starts from "6144".
  #   Refer support combinations of throughput and storage_size documentation (/docs/EventStreams?topic=EventStreams-ES_scaling_capacity#ES_scaling_combinations) for more details.
  # }

  # timeouts {
  #   create = "15m" # use 3h when creating enterprise instance, add more 1h for each level of non-default throughput, add more 30m for each level of non-default storage_size
  #   update = "15m" # use 1h when updating enterprise instance, add more 1h for each level of non-default throughput, add more 30m for each level of non-default storage_size
  #   delete = "15m"
  # }
}

resource "ibm_event_streams_topic" "es_topic_1" {
  resource_instance_id = ibm_resource_instance.es_instance_1.id
  name                 = "my-es-topic"
  partitions           = 1
  config = {
    "cleanup.policy"  = "compact,delete"
    "retention.ms"    = "86400000"
    "retention.bytes" = "1073741824"
    "segment.bytes"   = "536870912"
  }
}
