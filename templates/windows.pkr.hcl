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
source "amazon-ebs" "windows" {
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
    owners      = ["{{ base.owner}}"]
  }
  communicator   = "winrm"
  winrm_username = "Administrator"
  winrm_use_ssl  = true
  winrm_insecure = true

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = {{ instance.volume_size }}
  }

{% if subnet_id %}
  subnet_id = "{{ subnet_id }}"
{% endif %}

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

  # I was hoping it would not be necessary to use this here, but it
  # seems WinRM doesn't start, even though I think it's told to in the
  # base image? Oh well.
  user_data_file = "{{ resource_basedir }}/windows/winrm_bootstrap.txt"
}

# https://www.packer.io/docs/provisioners
build {
  sources = ["source.amazon-ebs.windows"]

  provisioner "powershell" {
    inline = [
      "mkdir C:\\Tools"
    ]
  }

{% for file in files %}
  provisioner "file" {
    source      = "{{ file.src }}"
    destination = "C:\\Tools\\{{ file.dst }}"
  }
{% endfor %}

  provisioner "powershell" {
    environment_vars = [{% for e in env %}
      "{{ e }}",{% endfor %}
      {% for e in private_env %}
      "{{ e }}",{% endfor %}
    ]
    scripts = [
      "{{ module_basedir }}/base.ps1",
      "{{ module_basedir }}/awscli.ps1",{% for module in modules %}
      "{{ module_basedir }}/{{ module }}.ps1",{% endfor %}{% for module in security_modules %}
      "{{ module_basedir }}/{{ module }}.ps1",{% endfor %}{% for script in scripts %}
      "{{ script }}",{% endfor %}
    ]
  }

  provisioner "powershell" {
    inline = {{inline|tojson}}
  }

  provisioner "powershell" {
    inline = [
      # Remove system specific information from this image
      "& 'C:/Program Files/Amazon/EC2Launch/EC2Launch.exe' reset --block",
      "& 'C:/Program Files/Amazon/EC2Launch/EC2Launch.exe' sysprep --block"
    ]
  }

  post-processor "manifest" {
    output = "builds/${var.ami-prefix}manifest.json"

    strip_path = true
    custom_data = {
      ami_name        = "${local.ami_name}"
      source_ami_name = "${build.SourceAMIName}"
    }
  }
}
