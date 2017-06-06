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
		--filenames '$(filter $(1)%.$(3),$^)' ; \
	     fi 


# Remove all files in a given directory, including symlinks, excluding dotfiles
# Arguments 
# $(1) The directory path, relative to the location of this Makefile
# TODO Add the ability to remove broken symlinks
clean_directory = find -L ./$(1) -type f \( ! -iname ".*" \) -exec /bin/rm {} \;


# Link a set of files from inputData into dataReserve/
link_inputData = $(call link_files,inputData,dataReserve,csv)

# Run a set of queries and save the results as csv files in dataReserve
# Arguments
# $(1) 	dbname - character
# 		The name of the database to run queries against
run_query = $(call link_files,queriesReserve,queries,sql) ; \
	    Rscript misc/run_queries.r \
	    	--auth_file_location $(auth_file) \
		--dbname $(1) \
		--projname $(projname) ; \
		$(call clean_directory,queries)

# Create a new cached dataset in cacheReserve/
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

# Knit a report from an Rmd file
knit_report = $(call link_files,dataReserve,data,csv) ; \
	$(call link_files,cacheReserve,cache,RData) ; \
	Rscript ./misc/knit_report.r \
		--markdownpath $(filter %.Rmd,$^) \
		--targetpath $@ \
		--projname $(projname) ; \
	$(call clean_directory,cache) ; \
	$(call clean_directory,data)
