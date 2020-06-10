# EMIP
Scripts used for Data Analysis of EMIP 2020

* EMIP_stats.R - generate frequency table of messages per user and average word count during the middle of the workshop (6-3-2020)
* EMIP_stats2.R - same as EMIP_stats.R, but ran during the end of the workshop (6-5-2020) and exports to a separate directory (final)
* EMIP_export-to-SentiStrength.R - exports dataset in a format easily processed by [SentiStrength](http://sentistrength.wlv.ac.uk/)
* EMIP_import-from-SentiStrength.R - imports data processed by [SentiStrength](http://sentistrength.wlv.ac.uk/), cleans it up, and re-exports it as csv
* EMIP_wordcloud.R - generates word cloud of each chat channel and the entire Discord server as a whole
