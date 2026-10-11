resource "oci_generative_ai_model" "generative_ai_models" {
  for_each = var.generative_ai_models

  base_model_id  = each.value.base_model_id
  compartment_id = each.value.compartment_id
  defined_tags   = each.value.defined_tags
  description    = each.value.description
  display_name   = each.value.display_name
  freeform_tags  = each.value.freeform_tags
  vendor         = each.value.vendor
  version        = each.value.version

  fine_tune_details {
    dedicated_ai_cluster_id = each.value.fine_tune_details.dedicated_ai_cluster_id
    dynamic "training_config" {
      for_each = each.value.fine_tune_details.training_config != null ? [each.value.fine_tune_details.training_config] : []
      content {
        early_stopping_patience             = training_config.value.early_stopping_patience
        early_stopping_threshold            = training_config.value.early_stopping_threshold
        learning_rate                       = training_config.value.learning_rate
        log_model_metrics_interval_in_steps = training_config.value.log_model_metrics_interval_in_steps
        lora_alpha                          = training_config.value.lora_alpha
        lora_dropout                        = training_config.value.lora_dropout
        lora_r                              = training_config.value.lora_r
        num_of_last_layers                  = training_config.value.num_of_last_layers
        total_training_epochs               = training_config.value.total_training_epochs
        training_batch_size                 = training_config.value.training_batch_size
        training_config_type                = training_config.value.training_config_type
      }
    }
    training_dataset {
      bucket       = each.value.fine_tune_details.training_dataset.bucket
      dataset_type = each.value.fine_tune_details.training_dataset.dataset_type
      namespace    = each.value.fine_tune_details.training_dataset.namespace
      object       = each.value.fine_tune_details.training_dataset.object
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

