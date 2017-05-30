# TODO: document the fact that the user needs realpath installed. 
# (misc/loop_link.r depends on it) 

# Preamble. Define variables and default goal (what runs when you say 'make')
auth_file := ~/.auth/authenticate.csv # Text file containing database credentials
sql_access := TRUE # Does the person running the code have access to the database?
projname := rtemplate
cache_loading := TRUE
munging := TRUE

# ##############
# Functions
# ##############

# Link a set of files from one directory into another
# Arguments
# $(1) sourcedir argument to pass to loop_link.r
# $(2) targetdir argument to pass to loop_link.r
# $(3) file extension - only link files with this extension
link_files = if [ -n "$(filter $(1)%.$(3),$^)" ]; \
	     then Rscript misc/loop_link.r \
		--projname $(projname) \
		--sourcedir $(1) \
		--targetdir $(2) \
		--filenames $(filter $(1)%.$(3),$^) ; \
	     fi 


# Remove all files in a given directory, including symlinks, excluding dotfiles
# Arguments 
# $(1) The directory path, relative to the location of this Makefile
# TODO Add the ability to remove broken symlinks
define clean_directory
find -L ./$(1) -type f \( ! -iname ".*" \) -exec /bin/rm {} \;
endef


# Link a set of files from inputData into dataReserve/
define link_inputData
$(call link_files,inputData,dataReserve,csv)
endef

# Run a query and save the result as a csv file in dataReserve
# TODO Turn into a 'single line' definition, like link_files
# Arguments
# $(1) 	dbname - character
# 		The name of the database to run queries against
define run_query
$(call link_files,queriesReserve,queries,sql)
Rscript misc/run_queries.r --auth_file_location $(auth_file) --dbname $(1) --projname $(projname)
find ./queries -type f \( ! -iname ".*" \) -exec /bin/rm {} \;
endef

# Create a new cached dataset in cacheReserve/
# TODO Currently munge files reqire you to hardcode in the value of 
# 'outname'. Make it so that you don't have to do that. (e.g., munge 
# scripts always output an object of the same name, like munge_out.
# update_cache.r assigns that to the value of outname before caching.
# Arguments
# $(1)  Name of dataset to create (without .RData extension)
define update_cache
$(call link_files,mungeReserve,munge,r)
$(call link_files,dataReserve,data,csv)
$(call link_files,cacheReserve,cache,RData)
Rscript misc/update_cache.r --outname $(1)
mv cache/$(1).RData cacheReserve/
$(call clean_directory,munge)
$(call clean_directory,data)
$(call clean_directory,cache)
endef

# ##############
# Actual Recipes
# ##############

mkfileViz.png: makefile2dot.py Makefile
	python makefile2dot.py <Makefile |dot -Tpng > mkfileViz.png

clean: 
	$(call clean_directory,data) ; \
	$(call clean_directory,queries) ; \
	$(call clean_directory,cache) ; \
	$(call clean_directory,munge) ; \
	$(call clean_directory,reports)

cleanReserve: clean
	$(call clean_directory,cacheReserve) ; \
	$(call clean_directory,dataReserve)

.PHONY: clean cleanReserve

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
