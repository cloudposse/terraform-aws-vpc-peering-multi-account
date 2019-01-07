locals {
  enabled = "${var.enabled == "true"}"
  count   = "${local.enable ? 1 : 0}"
}
