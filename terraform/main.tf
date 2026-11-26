resource "opentelekomcloud_lts_group_v2" "LogGroup" {
  group_name  = "bug-encrypted-lts-custom-tag_log_group"
  ttl_in_days = 1

  tags = {
    "app_group" = "bug-encrypted-lts-custom-tag"
  }
}
resource "opentelekomcloud_lts_stream_v2" "log_stream" {
  group_id    = opentelekomcloud_lts_group_v2.LogGroup.id
  stream_name = "log_stream"

  tags = {
    "app_group" = "bug-encrypted-lts-custom-tag"
  }
}

resource "opentelekomcloud_fgs_function_v2" "myfunction" {

  name = "bug-encrypted-lts-custom-tag"
  app  = "default"

  handler = "index.handler"

  runtime = "Python3.10"

  initializer_handler = null
  initializer_timeout = null

  code_type     = "inline"
  func_code     = filebase64(format("${path.module}/code.py"))
  code_filename = "index.py"

  description      = "Test function"
  memory_size      = 128
  timeout          = 3
  max_instance_num = 1

  enable_lts_log = true

  log_group_id   = opentelekomcloud_lts_group_v2.LogGroup.id
  log_group_name = opentelekomcloud_lts_group_v2.LogGroup.group_name

  log_topic_id   = opentelekomcloud_lts_stream_v2.log_stream.id
  log_topic_name = opentelekomcloud_lts_stream_v2.log_stream.stream_name

  lts_custom_tag = {
    "tag1" = "Tag1"
    "tag2" = "Tag2"
  }

  tags = {
    "app_group" = "bug-encrypted-lts-custom-tag"
  }

}
