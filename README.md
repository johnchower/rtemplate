
[projtemp]: http://projecttemplate.net/

# rtemplate

## Introduction
This is a generic repository contianing the skeleton of every custom analytics
report that we'll be doing at Gloo.

It's structure is based off of the ProjectTemplate structure.
[ProjectTemplate][projtemp] is an R package designed to provide a consistent
structure to R analyses. It's aim is to "automate the boring stuff" such as
directory structure, data loading, and munging. Though I agreed with the
philosophy of ProjectTemplate, and found the tools it provides useful, I found
it lacking in a couple of key ways. This repository was created to address
those shortcomings.

The primary shortcoming I sought to fix was that ProjectTemplate is not smart
about which data it loads and when. Throughout the course of an analysis,
certain datasets become obsolete, or no longer needed. ProjectTemplate's
solution of caching these datasets in a designated directory is good, but the
behavior of loading data from cache leaves much to be desired. Essentially,
it's all-or-nothing. You either load all of the cached data, or none of it. I
sought a solution where each R script loads only those datasets it needs. Of
course, I could write boilerplate code at the beginning of each script to do
this, but this would defeat one of the main reasons I started 
using ProjectTemplate in the first place.

The solution to this was to create "Reserve" directories where data, cached
data, and munge scripts wait dormant. When we need a dataset, we symlink it
from dataReserve into data, and then ProjectTemplate will take care of the
loading for us. The naming convention for these directories is to tack a
"Reserve" on the end of the ProjectTemplate directory names. So, for example,
cacheReserve/ links to cache/. 

A second feature I wanted to add on to Project Template is the ability to use
it gracefully with a Makefile. This brought us the way out. If the Make recipe
can read the prerequisites, it can pass those to a script that can link the
prerequisites into the corresponding ProjectTemplate directories.

## Getting Started

Download this repository and rename the top level directory to the name of your 
project. Also change the "projname" variable at the top of Makefile:

## Directory Structure

The following directories are ProjectTemplate directories. See the
[ProjectTemplate][projtemp] documentation to learn how they work.

## Makefile Structure

## R Style and Architecture

## Boilerplate Recipes

rtemplate provides a set of boilerplate recipes in boilerplate.mk that make
working with stuff easier. For example, stuff.

1.  `README.html` - Generates a Github-style preview of your README.md using
    [grip](https://github.com/joeyespo/grip)
2.  `mkfileViz.png` - Generates a visualization of your makefile using
    [makefile2dot](https://github.com/vak/makefile2dot) 
3.  `clean` - Removes all files (except .gitignore) from the data, queries,
    munge, cache, and reports directory. Useful if you've linked files into
    those directories that you don't need to load anymore.
4.  `cleanReserve` - Removes all files (except .gitignore) from the dataReserve
    and cacheReserve directories. Useful if you need to re-make any datasets
    that you've generated.
