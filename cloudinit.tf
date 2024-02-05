data "template_file" "server_1" {
    template = "${file("${path.module}/templates/cloudinit/cloudinit-1.tpl")}"
}

data "template_cloudinit_config" "server_1" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.server_1.rendered}"
  }
}

data "template_file" "server_2" {
    template = "${file("${path.module}/templates/cloudinit/cloudinit-2.tpl")}"
}

data "template_cloudinit_config" "server_2" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.server_2.rendered}"
  }
}