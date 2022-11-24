variable "create" {
  description = "Determines whether cluster resources will be created"
  type        = bool
  default     = true
}

################################################################################
# Cluster
################################################################################

variable "name" {
  description = "Name of the MSK cluster"
  type        = string
  default     = "DemoMSK" # to avoid: Error: cluster_name must be 1 characters or higher
}

variable "kafka_version" {
  description = "Specify the desired Kafka software version"
  type        = string
  default     = "2.8.1"
}

variable "number_of_broker_nodes" {
  description = "The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets"
  type        = number
  default     = 3
}

variable "enhanced_monitoring" {
  description = "Specify the desired enhanced MSK CloudWatch monitoring level. See [Monitoring Amazon MSK with Amazon CloudWatch](https://docs.aws.amazon.com/msk/latest/developerguide/monitoring.html)"
  type        = string
  default     = "PER_TOPIC_PER_PARTITION"
}

variable "broker_node_client_subnets" {
  description = "A list of subnets to connect to in client VPC ([documentation](https://docs.aws.amazon.com/msk/1.0/apireference/clusters.html#clusters-prop-brokernodegroupinfo-clientsubnets))"
  type        = list(string)
  default     = ["subnet-025a13e0cd5a72374","subnet-0cadc32aa94d9580b","subnet-0cc9ffdcad17f533f"]
}

variable "broker_node_ebs_volume_size" {
  description = "The size in GiB of the EBS volume for the data drive on each broker node"
  type        = number
  default     = 100
}

variable "broker_node_instance_type" {
  description = "Specify the instance type to use for the kafka brokers. e.g. kafka.m5.large. ([Pricing info](https://aws.amazon.com/msk/pricing/))"
  type        = string
  default     = "kafka.m5.large"
}

variable "broker_node_security_groups" {
  description = "A list of the security groups to associate with the elastic network interfaces to control who can communicate with the cluster"
  type        = list(string)
  default     = []
}

variable "client_authentication_tls_certificate_authority_arns" {
  description = "List of ACM Certificate Authority Amazon Resource Names (ARNs)"
  type        = list(string)
  default     = []
}

variable "client_authentication_sasl_iam" {
  description = "Enables IAM client authentication"
  type        = bool
  default     = false
}

variable "client_authentication_sasl_scram" {
  description = "Enables SCRAM client authentication via AWS Secrets Manager"
  type        = bool
  default     = false
}

variable "encryption_in_transit_client_broker" {
  description = "Encryption setting for data in transit between clients and brokers. Valid values: `TLS`, `TLS_PLAINTEXT`, and `PLAINTEXT`. Default value is `TLS`"
  type        = string
  default     = "PLAINTEXT"
}

variable "encryption_in_transit_in_cluster" {
  description = "Whether data communication among broker nodes is encrypted. Default value: `true`"
  type        = bool
  default     = null
}

variable "encryption_at_rest_kms_key_arn" {
  description = "You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest. If no key is specified, an AWS managed KMS ('aws/msk' managed service) key will be used for encrypting the data at rest"
  type        = string
  default     = null
}

variable "jmx_exporter_enabled" {
  description = "Indicates whether you want to enable or disable the JMX Exporter"
  type        = bool
  default     = true
}

variable "node_exporter_enabled" {
  description = "Indicates whether you want to enable or disable the Node Exporter"
  type        = bool
  default     = true
}

variable "cloudwatch_logs_enabled" {
  description = "Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs"
  type        = bool
  default     = true
}

variable "firehose_logs_enabled" {
  description = "Indicates whether you want to enable or disable streaming broker logs to Kinesis Data Firehose"
  type        = bool
  default     = false
}

variable "firehose_delivery_stream" {
  description = "Name of the Kinesis Data Firehose delivery stream to deliver logs to"
  type        = string
  default     = null
}

variable "s3_logs_enabled" {
  description = "Indicates whether you want to enable or disable streaming broker logs to S3"
  type        = bool
  default     = false
}

variable "s3_logs_bucket" {
  description = "Name of the S3 bucket to deliver logs to"
  type        = string
  default     = null
}

variable "s3_logs_prefix" {
  description = "Prefix to append to the folder name"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Create, update, and delete timeout configurations for the cluster"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to assign to the resources created"
  type        = map
  default     = {
    "Terraform" = "true"
    "Environment" = "Demo"

  }
}

################################################################################
# Configuration
################################################################################

variable "configuration_name" {
  description = "Name of the configuration"
  type        = string
  default     = "TestConfigDemoMSK"
}

variable "configuration_description" {
  description = "Description of the configuration"
  type        = string
  default     = null
}

variable "configuration_server_properties" {
  description = "Contents of the server.properties file. Supported properties are documented in the [MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html)"
  type        = map
  default     = {
    "auto.create.topics.enable" = "true"
	"default.replication.factor" = 3
	"min.insync.replicas" = 2
	"num.io.threads" =8
	"num.network.threads" = 5
	"num.partitions" = 1
	"num.replica.fetchers" = 2
	"replica.lag.time.max.ms" = 30000
	"socket.receive.buffer.bytes" = 102400
	"socket.request.max.bytes" = 104857600
	"socket.send.buffer.bytes" = 102400
	"unclean.leader.election.enable" = "true"
	"zookeeper.session.timeout.ms" = 18000
	"delete.topic.enable" = "true"
	"log.retention.hours" = 8
  }
}

################################################################################
# Secret(s)
################################################################################

variable "create_scram_secret_association" {
  description = "Determines whether to create SASL/SCRAM secret association"
  type        = bool
  default     = false
}

variable "scram_secret_association_secret_arn_list" {
  description = "List of AWS Secrets Manager secret ARNs to associate with SCRAM"
  type        = list(string)
  default     = []
}

################################################################################
# CloudWatch Log Group
################################################################################

variable "create_cloudwatch_log_group" {
  description = "Determines whether to create a CloudWatch log group"
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_name" {
  description = "Name of the Cloudwatch Log Group to deliver logs to"
  type        = string
  default     = "DemoMSKCWLog"
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the log group"
  type        = number
  default     = 0
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = null
}

################################################################################
# Storage Autoscaling
################################################################################

variable "scaling_max_capacity" {
  description = "Max storage capacity for Kafka broker autoscaling"
  type        = number
  default     = 250
}

variable "scaling_role_arn" {
  description = "The ARN of the IAM role that allows Application AutoScaling to modify your scalable target on your behalf. This defaults to an IAM Service-Linked Role"
  type        = string
  default     = null
}

variable "scaling_target_value" {
  description = "The Kafka broker storage utilization at which scaling is initiated"
  type        = number
  default     = 70
}

