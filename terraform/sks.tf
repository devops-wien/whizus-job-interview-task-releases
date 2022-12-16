locals {
  prefix = "jit-releases"
}

resource "exoscale_security_group" "sks" {
  name = "${local.prefix}-sks"
}

resource "exoscale_security_group_rules" "sks" {
  security_group = exoscale_security_group.sks.name

  ingress {
    description              = "VXLAN (Calico)"
    protocol                 = "UDP"
    ports                    = ["4789"]
    user_security_group_list = [exoscale_security_group.sks.name]
  }

  ingress {
    description = "Kubelet"
    protocol    = "TCP"
    ports       = ["10250"]
    user_security_group_list = [exoscale_security_group.sks.name]
  }

  ingress {
    description = "NodePort services"
    protocol    = "TCP"
    cidr_list   = ["0.0.0.0/0", "::/0"]
    ports       = ["30000-32767"]
  }
}

resource "exoscale_sks_cluster" "cluster" {
  zone          = var.zone
  name          = "${local.prefix}-sks"
  service_level = "starter"
  version       = "1.25.4"
  depends_on    = [exoscale_security_group.sks]
  auto_upgrade  = false
  exoscale_ccm  = true
}

resource "exoscale_sks_nodepool" "nodepool" {
  count              = var.nodepool_enabled ? 1 : 0

  zone               = "at-vie-1"
  cluster_id         = exoscale_sks_cluster.cluster.id
  name               = "${local.prefix}-sks-nodepool"
  instance_type      = "standard.medium"
  instance_prefix    = "default-medium"
  size               = 1
  disk_size          = 50
  security_group_ids = [exoscale_security_group.sks.id]
}

resource "exoscale_sks_kubeconfig" "kubeconfig" {
  zone       = var.zone
  cluster_id = exoscale_sks_cluster.cluster.id

  user   = "admin@${local.prefix}"
  groups = ["system:masters"]
}

resource "local_sensitive_file" "kubeconfig_file" {
  filename        = "${pathexpand("~/.kube/config.d/whizus/job-interviews")}/${exoscale_sks_cluster.cluster.name}.config.yaml"
  content         = replace(exoscale_sks_kubeconfig.kubeconfig.kubeconfig, " ${exoscale_sks_cluster.cluster.id}", " ${exoscale_sks_cluster.cluster.name}")
  file_permission = "0600"
}