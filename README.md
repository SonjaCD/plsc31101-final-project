This is a template you can use for your final projects (as well other projects where you need to post replication code.) Fill in each section with information on your own project.

## Short Description

In this project, I utilize maps and graphs using R to consider a mid-size social network that is characterized by well-defined cliques, and relatively even distribution of population (throughout the United States). in the course of collecting data, I encounter limitations associated with archival scanning and text recognition. I consider solutions using Adobe and Tesseract, but these ultimately do not prove useful at my level of skill. I therefore hand-code my data. 

To visualize my data, I use ggmaps to make basic US maps and ggplot to consider disbursement of nodes. I also use igraph to plot the networks. I comment on roadblocks I encounter along the way and the general (or sometimes specific) strategies and packages I employ in attempting to resolve these. I also discuss/recommend tutorials and links that were helpful to me in the process of learning and employing different programs, R in particular. 



## Dependencies


1. R, 3.6.1


## Files


1. Narrative.Rmd: Provides a 3-5 page narrative of the project, main challenges, solutions, and results.
2. Narrative.pdf: A knitted pdf of Narrative.Rmd. 
3. Slides.XXX: Your lightning talk slides, in whatever format you prefer.

#### Code/
Chicago_Project_Code.R: Includes discussion of processing of data into various datasets. Conducts descriptive analysis of the data, producing the visualizations found in the Results directory.

#### Data/

1. chicago_edited.csv: original, dataset that contains all variables considered in the project as well as several others that in process or incomplete
2. chicago_data.csv: replica of chicago_edited, reduced by several columns
3. committee_links - contains all the edges in the graphs
4. committee_nodes - contains all the nodes in the graphs, along with several attributes
5. db_committees: contains list of nodes (individuals with) with following attributes :
"NATIVE_COMMUNITY": NativeLives in Native community?
"RES_1961": Lives on Reservation?
"RURAL: Lives in rural location?"
"address": contains city, state, lon, lat
Committee Membership = 6 variables: "CHAIRMEN", "CREDENTIAL_COM", "DRAFTING_COMM"
, "NYIC" (NATIVE YOUTH INDIAN COUNCIL), "STEERING COMMITTEE", "RULES COMMITTEE"


#### Results/

1. distribution map.pdf -  map of regional distribution of attendees
2. res_map.pdf - map of the US in 1961, plotted with home address of conference attendees
3.  names_NoNode.pdf - graph of network with aesthetic nodes
4. net_committees - map of the network
5. cliques.pdf - identifies cliques and graphs with color
6. net_committees - 1 - the main committees/nodes dataset, with 
7. big_clique.pdf - plots graph and highlights biggest clique. 
8. Output_db_committees - summary of committees overall
9. Output_Full.jpg - summary 
10. Output_db_committees.jpg - summary




