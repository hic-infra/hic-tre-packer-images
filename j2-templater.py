#!/usr/bin/env python3
from argparse import ArgumentParser
from jinja2 import Environment, FileSystemLoader
import yaml

parser = ArgumentParser(description="HIC Packer templater")
parser.add_argument("template", help="Base template")
parser.add_argument("config", help="Packer image configuration file")
parser.add_argument("output", help="Output Packer file", nargs="?")
args = parser.parse_args()

# The template path includes ./hic-tre-packer-images so that this can be run
# from a parent directory, e.g. a private repo that contains this public
# hic-tre-packer-images repo as a submodule
env = Environment(loader=FileSystemLoader(searchpath=["./", "./templates", "./hic-tre-packer-images/templates"]))
template = env.get_template(args.template)
with open(args.config) as f:
    config = yaml.safe_load(f)

packer_hcl = template.render(config)

if args.output:
    with open(args.output, "w") as f:
        f.write(packer_hcl)
else:
    print(packer_hcl)
