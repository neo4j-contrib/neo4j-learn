# Makefile for the Neo4j Manual in French.
#
# Note: requires mvn to unpack some stuff first.
PROJECTNAME      = java-course

ifdef PROJECT
	PROJECTNAME = $(PROJECT)
endif

BUILDDIR         = $(CURDIR)/target
TOOLSDIR         = $(BUILDDIR)/tools
SRCDIR     		 = $(CURDIR)
STATICSRCDIR     = $(CURDIR)/src/resources/
RESOURCEDIR      = $(BUILDDIR)/classes
SRCFILE          = $(SRCDIR)/src/asciidoc/$(PROJECTNAME).asciidoc
IMGDIR           = $(SRCDIR)/images
IMGTARGETDIR     = $(BUILDDIR)/classes/images
IMGSRCDIR        = $(CURDIR)/src/resources/images
CSSDIR           = $(CURDIR)/src/resources/css
JSDIR            = $(CURDIR)/src/resources/js
CONFDIR          = $(SRCDIR)/conf
TOOLSCONFDIR     = $(TOOLSDIR)/main/resources/conf
SINGLEHTMLDIR    = $(BUILDDIR)/html
SINGLEHTMLFILE   = $(SINGLEHTMLDIR)/$(PROJECTNAME).html
EXTENSIONSRC     = $(TOOLSDIR)/bin/extensions
EXTENSIONDEST    = ~/.asciidoc
SCRIPTDIR        = $(TOOLSDIR)/build
ASCIDOCDIR       = $(TOOLSDIR)/bin/asciidoc
ASCIIDOC         = $(ASCIDOCDIR)/asciidoc.py
A2X              = $(ASCIDOCDIR)/a2x.py


ifdef VERBOSE
	V = -v
	VA = VERBOSE=1
endif

ifdef KEEP
	K = -k
	KA = KEEP=1
endif

ifdef VERSION
	VERSNUM =$(VERSION)
else
	VERSNUM =-neo4j-version
endif

ifdef IMPORTDIR
	IMPDIR = --attribute importdir="$(IMPORTDIR)"
else
	IMPDIR = --attribute importdir="$(BUILDDIR)/docs"
	IMPORTDIR = "$(BUILDDIR)/docs"
endif

ifneq (,$(findstring SNAPSHOT,$(VERSNUM)))
	GITVERSNUM =master
else
	GITVERSNUM =$(VERSION)
endif

ifndef VERSION
	GITVERSNUM =master
endif

VERS =  --attribute neo4j-version=$(VERSNUM)

GITVERS = --attribute gitversion=$(GITVERSNUM)

ASCIIDOC_FLAGS = $(V) $(VERS) $(GITVERS) $(IMPDIR)

A2X_FLAGS = $(K) $(ASCIIDOC_FLAGS)

.PHONY: preview help

help:
	@echo "Please use 'make <target>' where <target> is one of"
	@echo "  preview     to generate a preview"
	@echo "For verbose output, use 'VERBOSE=1'".
	@echo "To keep temporary files, use 'KEEP=1'".
	@echo "To set the version, use 'VERSION=[the version]'".
	@echo "To set the importdir, use 'IMPORTDIR=[the importdir]'".
	@echo "To set project root name of the root asciidoc file, use 'PROJECT=[projectname]'".

#dist: installfilter offline-html html html-check text text-check pdf manpages upgrade cleanup yearcheck

preview: initialize installextensions simple-asciidoc

cleanup:
	#
	#
	# Cleaning up.
	#
	#
ifndef KEEP
	rm -rf "$(DOCBOOKFILE)"
	rm -rf "$(BUILDDIR)/"*.xml
	rm -rf "$(ANNOTATEDDIR)/"*.xml
	rm -rf "$(FOPDIR)/images"
	rm -rf "$(FOPFILE)"
	rm -rf "$(UPGRADE)/"*.xml
	rm -rf "$(UPGRADE)/"*.html
endif

initialize:
	#
	#
	# Setting correct file permissions.
	#
	#
	find $(TOOLSDIR) \( -path '*.py' -o -path '*.sh' \) -exec chmod 0755 {} \;

copy-resources:
	#
	#
	# copy static content over to destination dirs.
	#
	#
	rsync -u "$(STATICSRCDIR)html/"* "$(SINGLEHTMLDIR)/"
	rsync -u "$(STATICSRCDIR)images/"* "$(SINGLEHTMLDIR)/images"
	rsync -u "$(STATICSRCDIR)js/"* "$(SINGLEHTMLDIR)/js"
	rsync -u "$(STATICSRCDIR)css/"* "$(SINGLEHTMLDIR)/css"

installextensions: initialize
	#
	#
	# Installing asciidoc extensions.
	#
	#
	mkdir -p $(EXTENSIONDEST)
	cp -fr "$(EXTENSIONSRC)/"* $(EXTENSIONDEST)

simple-asciidoc: initialize installextensions copy-resources
	#
	#
	# Building HTML straight from the AsciiDoc sources.
	#
	#
	mkdir -p "$(SINGLEHTMLDIR)/images"
	mkdir -p "$(SINGLEHTMLDIR)/css"
	mkdir -p "$(SINGLEHTMLDIR)/js"
	"$(ASCIIDOC)" $(ASCIIDOC_FLAGS) -a toc2 -b html5 --conf-file="$(TOOLSCONFDIR)/asciidoc.conf"  --conf-file="$(CONFDIR)/asciidoc.conf" --attribute=docinfo1 --out-file "$(SINGLEHTMLFILE)" "$(SRCFILE)"
	rsync -u "$(IMGTARGETDIR)/"* "$(SINGLEHTMLDIR)/images"
	rsync -u "$(TOOLSDIR)/main/resources/css/"* "$(SINGLEHTMLDIR)/css"
	rsync -u "$(IMGSRCDIR)/"* "$(SINGLEHTMLDIR)/images"
	rsync -u "$(CSSDIR)/"* "$(SINGLEHTMLDIR)/css"
	rsync -u "$(JSDIR)/"* "$(SINGLEHTMLDIR)/js"
	rsync -u "$(TOOLSDIR)/main/resources/js/"* "$(SINGLEHTMLDIR)/js"


