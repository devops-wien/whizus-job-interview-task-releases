locals {
  prefix = "jit-releases"
}

resource "exoscale_security_group" "sks" {
  name = "${local.prefix}-sks"
}

resource "exoscale_security_group_rule" "sks_calico" {
  type                   = "INGRESS"
  security_group_id      = exoscale_security_group.sks.id
  description            = "VXLAN (Calico)"
  protocol               = "UDP"
  start_port             = 4789
  end_port               = 4789
  user_security_group_id = exoscale_security_group.sks.id
}

resource "exoscale_security_group_rule" "sks_kubelet" {
  type                   = "INGRESS"
  security_group_id      = exoscale_security_group.sks.id
  description            = "Kubelet"
  protocol               = "TCP"
  start_port             = 10250
  end_port               = 10250
  user_security_group_id = exoscale_security_group.sks.id
}

resource "exoscale_security_group_rule" "sks_nodeport_v4" {
  type              = "INGRESS"
  security_group_id = exoscale_security_group.sks.id
  description       = "NodePort services"
  protocol          = "TCP"
  cidr              = "0.0.0.0/0"
  start_port        = 30000
  end_port          = 32767
}

resource "exoscale_security_group_rule" "sks_nodeport_v6" {
  type              = "INGRESS"
  security_group_id = exoscale_security_group.sks.id
  description       = "NodePort services"
  protocol          = "TCP"
  cidr              = "::/0"
  start_port        = 30000
  end_port          = 32767
}


resource "exoscale_sks_cluster" "cluster" {
  zone          = var.zone
  name          = "${local.prefix}-sks"
  service_level = "starter"
  version       = "1.30.1"
  depends_on = [exoscale_security_group.sks]
  auto_upgrade  = false
  exoscale_ccm  = true
}

resource "exoscale_sks_nodepool" "nodepool" {
  count = var.nodepool_enabled ? 1 : 0

  zone            = "at-vie-1"
  cluster_id      = exoscale_sks_cluster.cluster.id
  name            = "${local.prefix}-sks-nodepool"
  instance_type   = "standard.medium"
  instance_prefix = "default-medium"
  size            = 1
  disk_size       = 50
  security_group_ids = [exoscale_security_group.sks.id]
}

resource "exoscale_sks_kubeconfig" "kubeconfig" {
  zone       = var.zone
  cluster_id = exoscale_sks_cluster.cluster.id

  user = "admin@${local.prefix}"
  groups = ["system:masters"]
}

resource "local_sensitive_file" "kubeconfig_file" {
  filename        = "${pathexpand("~/.kube/config.d/whizus/job-interviews")}/${exoscale_sks_cluster.cluster.name}.config.yaml"
  content = replace(exoscale_sks_kubeconfig.kubeconfig.kubeconfig, " ${exoscale_sks_cluster.cluster.id}", " ${exoscale_sks_cluster.cluster.name}")
  file_permission = "0600"
}