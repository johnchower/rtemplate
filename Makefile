# TODO: document the fact that the user needs realpath installed. 
# (misc/loop_link.r depends on it) 

include functions.mk

include boilerplate.mk

# ########
# Preamble
# Define variables and default goal (what runs when you say 'make')
# ########

auth_file := ~/.auth/authenticate.csv # Text file containing database credentials
sql_access := TRUE # Does the person running the code have access to the database?
projname := rtemplate
cache_loading := TRUE
munging := TRUE

# ############
# Recipes
# Place your project-specific recipes below
# ############

# ##############
# Examples
# These examples should cover most of the recipes you'll need to write.
# ##############

# Create a cached dataset from a munge script

# cacheReserve/m1.user_pa_cat_count.RData: mungeReserve/m1.r dataReserve/user_pa_facts.csv cacheReserve/m0.pa_cat.RData
# 	$(call update_cache,m1.user_pa_cat_count)

# cacheReserve/m0.pa_cat.RData: dataReserve/pa_cat.csv mungeReserve/m0.r
# 	$(call update_cache,m0.pa_cat)


# Create a csv dataset from a sql query
# dataReserve/user_pa_facts.csv: queriesReserve/user_pa_facts.sql
# 	$(call run_query,testDB)

# Link an input csv into dataReserve
# dataReserve/pa_cat.csv: inputData/pa_cat.csv
# 	$(link_inputData)

# Knit a pdf report
# reports/test_report.html: src/test_report.Rmd dataReserve/testdata.csv cacheReserve/m0.doubled.RData
# 	$(call knit_report) ; \
