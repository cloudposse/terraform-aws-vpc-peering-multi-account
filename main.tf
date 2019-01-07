locals {
  enabled = "${var.enabled == "true"}"
  count   = "${local.enabled ? 1 : 0}"
}
