# TODO: document the fact that the user needs realpath installed.
# Preamble. Define variables and default goal (what runs when you say 'make')
auth_file := ~/.auth/authenticate # Text file containing database credentials
sql_access := TRUE # Does the person running the code have access to the database?
projname := rtemplate

# Canned recipes

# Run a query and save the result as a csv file in data_reserve
# Requires the following variables:
# 	dbname - character
# 		The name of the database to run queries against
define run_query
Rscript misc/loop_link.r --projname $(projname)   --sourcedir queries_reserve --targetdir queries --filenames $(filter queries_reserve%.sql,$^) ;
Rscript misc/run_queries.r --auth_file_location $(auth_file) --dbname $(dbname)
rm queries/*
endef

# Create a new cached dataset in cache_reserve/
# Reqires the following variables:
# 	cache_loading - logical
# 	munging - logial
# 	outname - character
define update_cache
Rscript misc/loop_link.r --projname $(projname)  --sourcedir munge_reserve --targetdir munge --filenames $(filter munge_reserve%.r,$^) ;
Rscript misc/loop_link.r --projname $(projname)  --sourcedir data_reserve --targetdir data --filenames $(filter data_reserve%.csv,$^) ;
Rscript misc/loop_link.r --projname $(projname)  --sourcedir cache_reserve --targetdir cache --filenames $(filter cache_reserve%.RData,$^) ;
Rscript misc/update_cache.r --cache_loading $(cache_loading) --munging $(munging) --outname $(outname); \
endef

dbname := insightsbeta
data_reserve/test_query1.csv: queries_reserve/test_query1.sql
	$(update_data_reserve)
mkfileViz.png: makefile2dot.py Makefile
	python makefile2dot.py <Makefile |dot -Tpng > mkfileViz.png

clean: 
	rm data/* ; \
	rm queries/* ; \
	rm cache/* ; \
	rm reports/* ; \
	rm munge/*

clean_data_reserve:
	rm data_reserve/*
.PHONY: clean
