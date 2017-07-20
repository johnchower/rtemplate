
[projtemp]: http://projecttemplate.net/

# rtemplate

## Introduction 

This is a generic repository contianing the skeleton of every custom analytics
report that I wrote for Gloo.  It's structure is a modification of the
structure for analyses provided by the R package [ProjectTemplate][projtemp]. I
modified the ProjectTemplate structure to address the fact that ProjectTemplate
is not smart about which data it loads and when. It just loads everything in
the `data`, `cache` and `munge` directories, whenever a script calls the
function `ProjectTemplate::load.project()`. So if, for example, an analysis
produces a large dataset which isn't needed every step of the way, then time is
wasted repeatedly re-loading it every time a script starts.

I solved this by creating "Reserve" directories where data, cached data, and
munge scripts wait dormant. When we need, for example, a dataset, we symlink it
from `dataReserve` into `data` before a script calls
`ProjectTemplate::load.data()`.  The naming convention for these directories is
to tack a "Reserve" on the end of the ProjectTemplate directory names. So, for
example, `cacheReserve/` links to `cache/`.

The `Makefile` controlls all of the symlinking through use of custom functions
written in `functions.mk`. Example recipes that make use of these functions are
included in the base `Makefile`.

## Running an existing analysis

If you need to run an existing analysis, you first need to install all R
packages that the analysis code uses. A list of all required packages is
maintained in the file `misc/package_list.r`. To install, you can simply run
the command `make packages`, and the script `src/install_packages.r` will take
care of it for you.

Once this is taken care of, simply run the `make` command and the Makefile will
piece together the analysis for you. The result will be a file in the `reports`
directory (usually the only one). If unsure, check the `.DEFAULT_GOAL` variable
defined at the top of the `Makefile`. 

## Making your own analysis

Download this repository and rename the top level directory to the name of your
project. Change the `projname` variable at the top of the Makefile, to match
the name of the directory containing the project. Also, change the `projname`
variable in `misc/example_munge.r`. This won't affect the functioning of the
code when run in batch mode, but it's useful for running code interactively.

## Boilerplate Recipes

1.  `README.html` - Generates a Github-style preview of your README.md using
    [grip](https://github.com/joeyespo/grip)
2.  `mkfileViz.png` - Generates a visualization of your makefile using
    [makefile2dot](https://github.com/vak/makefile2dot) 
3.  `clean` - Removes all files (except .gitignore) from the data, queries,
    munge, cache, and reports directory. Useful if you've linked files into
    those directories that you don't need to load anymore.
4.  `cleanCacheReserve` - Removes all files (except .gitignore) from the
    cacheReserve directory. Useful if you need to re-make any datasets that
    you've generated.
5.  `cleanDataReserve` - Same as cleanCacheReserve but with the dataReserve
    directory.
6.  `packages` - Installs all package dependencies needed for the project.
    Reads from the file `misc/package_list.r`.

## Database access

All analyses require a connection to the data warehouse. To set up this
connection, a file containing database credentials, named `authenticate.csv`,
must be provided to the Makefile, and the `auth_file` variable must be set so
that the Makefile can find it. An example `authenticate.csv` file is provided
as a template. For security reasons, I reccommend not storing
`authenticate.csv` in your project directory.
