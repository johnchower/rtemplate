# TODO: document the fact that the user needs realpath installed. 
# (misc/loop_link.r depends on it) 

include functions.mk

include boilerplate.mk

# Preamble. Define variables and default goal (what runs when you say 'make')
auth_file := ~/.auth/authenticate.csv # Text file containing database credentials
sql_access := TRUE # Does the person running the code have access to the database?
projname := rtemplate
cache_loading := TRUE
munging := TRUE

# ############
# Recipes
# ############
cacheReserve/m0.doubled.RData: mungeReserve/m0.r dataReserve/testdata.csv
	$(call update_cache,m0.doubled)
	
# ##############
# Examples
# ##############

# cacheReserve/m1.user_pa_cat_count.RData: mungeReserve/m1.r dataReserve/user_pa_facts.csv cacheReserve/m0.pa_cat.RData
# 	$(call update_cache,m1.user_pa_cat_count)


# dataReserve/user_pa_facts.csv: queriesReserve/user_pa_facts.sql
# 	$(call run_query,testDB)

# cacheReserve/m0.pa_cat.RData: dataReserve/pa_cat.csv mungeReserve/m0.r
# 	$(call update_cache,m0.pa_cat)

# dataReserve/pa_cat.csv: inputData/pa_cat.csv
# 	$(link_inputData)
 
# reports/test_report.html: src/test_report.Rmd dataReserve/testdata.csv cacheReserve/m0.doubled.RData
# 	$(call knit_report) ; \
