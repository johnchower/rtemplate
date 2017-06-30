# ##############
# Boilerplate Recipes
# ##############

mkfileViz.png: makefile2dot.py Makefile
	python makefile2dot.py <Makefile |dot -Tpng > mkfileViz.png

README.html: README.md
	grip README.md --export README.html

clean: 
	$(call clean_directory,data) ; \
	$(call clean_directory,queries) ; \
	$(call clean_directory,cache) ; \
	$(call clean_directory,munge) ; \
	$(call clean_directory,reports)

cleanCacheReserve: clean
	$(call clean_directory,cacheReserve)

cleanDataReserve: cleanCacheReserve
	$(call clean_directory,dataReserve)

reports/report_template.pdf: misc/report_template.Rmd
	$(call knit_report)

.PHONY: clean cleanReserve
