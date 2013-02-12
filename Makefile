# Makefile for the Neo4j Manual.
#

# Project Configuration
project_name               = java-hello-world
language                   = en

# Minimal setup
target                     = target
build_dir                  = $(CURDIR)/$(target)
config_dir                 = $(CURDIR)/conf
tools_dir                  = $(build_dir)/tools
make_dir                   = $(tools_dir)/make

include $(make_dir)/context-manual.make
html5_dir_name             = html5/$(project_name)

