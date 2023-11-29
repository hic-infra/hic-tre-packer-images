variable "ami-prefix" {
  type    = string
  default = "{{ name }}-"
}

variable "git-commit" {
  type    = string
  default = "UNKNOWN"
}

variable "region" {
  type    = string
  default = "eu-west-2"
}

locals {
  ami_name = join("", [var.ami-prefix, formatdate("YYYYMMDD-hhmmss", timestamp())])
}

# https://www.packer.io/docs/builders/amazon/ebs
source "amazon-ebs" "ubuntu2004" {
  ami_name      = "${local.ami_name}"
  instance_type = "{{ instance.type }}"
  region        = "${var.region}"
  tags = {
    GitCommit = var.git-commit
  }

  source_ami_filter {
    filters = {
      name                = "{{ base.name }}"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true

    owners = ["{{ base.owner }}"]
  }

  ssh_username = "ubuntu"

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = {{ instance.volume_size }}
    delete_on_termination = true
  }

{% if s3_resources %}
  temporary_iam_instance_profile_policy_document {
    Statement {
      Action   = ["s3:Get*"]
      Effect   = "Allow"
      Resource = ["arn:aws:s3:::{{ s3_resources }}/*"]
    }
    Version = "2012-10-17"
  }
{% endif %}
}

# https://www.packer.io/docs/provisioners
build {
  sources = ["source.amazon-ebs.ubuntu2004"]

  provisioner "shell" {
    inline = [
      "sudo mkdir /opt/ami-setup",
      "sudo chown ubuntu /opt/ami-setup"
    ]
  }

{% for file in files %}
  provisioner "file" {
    source      = "{{ file.src }}"
    destination = "/opt/ami-setup/{{ file.dst }}"
  }
{% endfor %}

  provisioner "file" {
    destination = "/opt/ami-setup/"
    sources = [
      "{{ resource_basedir }}/ubuntu/vncserver@.service"
    ]
  }

  provisioner "shell" {
    remote_folder = "/opt/ami-setup/"
    environment_vars = [{% for e in env %}
      "{{ e }}",{% endfor %}
      {% for e in private_env %}
      "{{ e }}",{% endfor %}
    ]
    scripts = [
      "{{ module_basedir }}/cloudinit.sh",
      "{{ module_basedir }}/base.sh",{% for module in modules %}
      "{{ module_basedir }}/{{ module }}.sh",{% endfor %}{% for module in security_modules %}
      "{{ module_basedir }}/{{ module }}.sh",{% endfor %}{% for script in scripts %}
      "{{ script }}",{% endfor %}
    ]
  }

  provisioner "shell" {
    remote_folder = "/opt/ami-setup"
    inline = {{inline|tojson}}
  }

  post-processor "manifest" {
    output     = "builds/${var.ami-prefix}manifest.json"
    strip_path = true
    custom_data = {
      ami_name        = "${local.ami_name}"
      source_ami_name = "${build.SourceAMIName}"
    }
  }
}
