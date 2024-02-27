# HIC TRE Packer Images
[![CI](https://github.com/hic-infra/hic-tre-packer-images/actions/workflows/ci.yml/badge.svg)](https://github.com/hic-infra/hic-tre-packer-images/actions/workflows/ci.yml)

Packer templates for building TRE AMIs

HIC build AMIs (Amazon Machine Images) for use in the HIC TRE using [Packer](https://www.packer.io/).
These AMIs are all very similar so we've written some tools to make it easier to template them.

## Prerequisites

You must install Packer and Python 3.
You will also need access to an AWS account.

If you are using a recent version of Packer you may also need to install the Amazon plugin:
```
packer plugins install github.com/hashicorp/amazon
```

## Usage

Two example configurations are provided in the `configs` directory, one for Windows 2019 and one for Ubuntu 22.04 desktop.

To generate the packer `pkr.hcl` files run
```
make packer
```
This runs the [`j2-templater.py`](./j2-templater.py) script which takes a configuration YAML file from `./configs/` and outputs the `pkr.hcl` file under `./builds/`.

To build all AMIs run
```
make images
```
If successful this will output a `<CONFIG>-manifest.json` file under `./builds/` for each input configuration.

To build a single AMI, e.g. for [`./configs/hic-windows-2019-example.yml`](./configs/hic-windows-2019-example.yml), run
```
make builds/hic-windows-2019-example-manifest.json
```

## Modules

The modules under `./modules/` are used by the packer templates to build the AMIs.
Some of these install commercial software that is either free, or requires a license.
You are responsible for checking the requirements.

In some cases secret variables are required to use some modules, e.g. registration keys, or an AWS S3 bucket containing the software installer.
