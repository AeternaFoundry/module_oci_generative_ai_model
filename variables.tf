variable "generative_ai_models" {
  description = <<EOT
Map of generative_ai_models, attributes below
Required:
    - base_model_id
    - compartment_id
    - fine_tune_details (block):
        - dedicated_ai_cluster_id (required)
        - training_config (optional, block):
            - early_stopping_patience (optional)
            - early_stopping_threshold (optional)
            - learning_rate (optional)
            - log_model_metrics_interval_in_steps (optional)
            - lora_alpha (optional)
            - lora_dropout (optional)
            - lora_r (optional)
            - num_of_last_layers (optional)
            - total_training_epochs (optional)
            - training_batch_size (optional)
            - training_config_type (required)
        - training_dataset (required, block):
            - bucket (required)
            - dataset_type (required)
            - namespace (required)
            - object (required)
Optional:
    - defined_tags
    - description
    - display_name
    - freeform_tags
    - vendor
    - version
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    base_model_id  = string
    compartment_id = string
    defined_tags   = optional(map(string))
    description    = optional(string)
    display_name   = optional(string)
    freeform_tags  = optional(map(string))
    vendor         = optional(string)
    version        = optional(string)
    fine_tune_details = object({
      dedicated_ai_cluster_id = string
      training_config = optional(object({
        early_stopping_patience             = optional(number)
        early_stopping_threshold            = optional(number)
        learning_rate                       = optional(number)
        log_model_metrics_interval_in_steps = optional(number)
        lora_alpha                          = optional(number)
        lora_dropout                        = optional(number)
        lora_r                              = optional(number)
        num_of_last_layers                  = optional(number)
        total_training_epochs               = optional(number)
        training_batch_size                 = optional(number)
        training_config_type                = string
      }))
      training_dataset = object({
        bucket       = string
        dataset_type = string
        namespace    = string
        object       = string
      })
    })
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.generative_ai_models : (
        contains([for v in ["OBJECT_STORAGE"] : lower(v)], lower(v.fine_tune_details.training_dataset.dataset_type))
      )
    ])
    error_message = "must be one of: \"OBJECT_STORAGE\""
  }
  validation {
    condition = alltrue([
      for k, v in var.generative_ai_models : (
        v.fine_tune_details.training_config == null || (contains([for v in ["LORA_TRAINING_CONFIG", "TFEW_TRAINING_CONFIG", "VANILLA_TRAINING_CONFIG"] : lower(v)], lower(v.fine_tune_details.training_config.training_config_type)))
      )
    ])
    error_message = "must be one of: \"LORA_TRAINING_CONFIG\", \"TFEW_TRAINING_CONFIG\", \"VANILLA_TRAINING_CONFIG\""
  }
}

