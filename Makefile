SOURCEDIR ?= configs
BUILDDIR ?= builds
TEMPDIR ?= build-tmp
REPO_DIR ?= .

CONFIGS = $(wildcard $(SOURCEDIR)/*.yml)
IMAGES = $(patsubst $(SOURCEDIR)/%.yml,$(BUILDDIR)/%-manifest.json,$(CONFIGS))
PKR = $(patsubst $(SOURCEDIR)/%.yml,$(BUILDDIR)/%.pkr.hcl,$(CONFIGS))
LOGS = $(patsubst $(SOURCEDIR)/%.yml,$(BUILDDIR)/%.log,$(CONFIGS))

TEMPLATE ?= templates/default.j2

PACKER_FLAGS ?= -color=true

images: $(IMAGES)

packer: $(PKR)

# Use TEMPDIR and mv afterwards so if a step fails the target is not updated

$(BUILDDIR)/%-manifest.json: $(BUILDDIR)/%.pkr.hcl
	@mkdir -p $(TEMPDIR)
	set -o pipefail; packer build $(PACKER_FLAGS) \
		$< | tee $(TEMPDIR)/$(basename $(basename $<)).log
	mv $(TEMPDIR)/$(basename $(basename $<)).log $(basename $(basename $<)).log

$(BUILDDIR)/%.pkr.hcl: $(SOURCEDIR)/%.yml
	@mkdir -p $(BUILDDIR) $(TEMPDIR)/$(BUILDDIR)
	python $(REPO_DIR)/j2-templater.py $(TEMPLATE) $< $(TEMPDIR)/$@
	packer validate $(TEMPDIR)/$@
	mv $(TEMPDIR)/$@ $@

clean:
	rm -f $(IMAGES)
	rm -f $(PKR)
	rm -f $(LOGS)
	rm -rf $(BUILDDIR)
	rm -rf $(TEMPDIR)
