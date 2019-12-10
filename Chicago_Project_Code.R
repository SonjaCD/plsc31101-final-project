

#install.packages("maps")
#install.packages("ggmap")
library(tidyverse)
library(dplyr)
library(ggmap)
library(ggplot2)
library(maps)
library(igraph)


#Get working directory
setwd("/Users/gerdsonja/Desktop/CHICAGO_CONF")
getwd()

# Import data
chicago_data <- read.csv("chicago_edited.csv", stringsAsFactors = FALSE)

#Create two columns, lon and lat and add to dataframe
chicago_data <- cbind(chicago_data, geocode(paste(chicago_data$CITY, chicago_data$STATE, sep = "," )))

#Create column "address" joining city and state, add comma
chicago_data$address <- with(chicago_data, paste(CITY, STATE, sep = ","))

#Add city,state longitude and latitude info to "address"
mutate_geocode(chicago_data, address)

# Create a reduced dataset for committees only by filtering and selecting 
db_committees <- chicago_data
db_committees <- chicago_data %>%
  filter(CHAIRMEN == 1 | CREDENTIAL_COM == 1 | DRAFTING_COMM == 1 |
           STEERING_COMM == 1 | STEERING_COMM == 1 |
           RULES_COMM == 1 | NYIM == 1) 

db_committees <- db_committees %>%
  select (LAST, FIRST, TRIBE, NATIVE_COMMUNITY, RES_1961, 
          RURAL, CHAIRMEN, CREDENTIAL_COM, DRAFTING_COMM, 
          STEERING_COMM, RULES_COMM, NYIM, address, FEMALE)

summary(chicago_data)
summary(db_committees)

#plot registrant addresses
ggplot(chicago_data, aes(lon, lat)) +
  geom_point()

#United States map
united_states <- c(lat = 37.0902405, lon = -95.7128906)
us_map <- get_map(location = united_states, zoom = 4, scale = 1)

# view us_map
ggmap(us_map)

#That's kind of busy, but I want to see if the population is disbursed, so plot addresses for all registered
#combine us_map with chicago_data address (lon, lat) and make nodes red
ggmap(us_map)+
  geom_point(aes(lon, lat, color = "red"), data = chicago_data)
#The map has cut off two nodes in Alaska and one in Canada. That's not ideal, but it's hard to scale for Alaska. I can look for better options to cover the rest.

#combine us_map with chicago_data address (lon, lat) and color dots to indicate reservation status
ggmap(us_map)+
  geom_point(aes(lon, lat, color = RES_1961), data = chicago_data)
#We can see that reservations are more prevalent in the West, non-reservations in the East. this is expected and relates to historical policy as well as "termination" of tribal rights that took place throughout the 40s and 50s. 

# The geographic features of the map obscure the image. us_map is a function that turns a series of points along an outline into a data frame of those points
#get simple black USA map from maps 
 usa <- map_data("usa")

#get dimensions of usa map 
 dim(usa)

#view plain black USA map
 usa <- map_data("usa")
 ggplot() + geom_polygon(data = usa, aes(x=long, y = lat, group = group)) + 
   coord_fixed(1.3)
 
 #view black map with red dots representing locations where conference attendees lived
 usa <- map_data("usa")
 ggplot() + geom_polygon(data = usa, aes(x=long, y = lat, group = group)) + 
   coord_fixed(1.3)+
   geom_point(aes(lon, lat, color = "red"), data = chicago_data)
 #now alaska is plotted but not on the map. I can rescale again, but will leave for now for purpose of getting full idea of the data plot. Alaska has two representatives, but a large share of the population of indigenous people in the U.S.

 #create committee vertices dataframe
 committee_nodes <- db_committees
 
# group by each committee and assemble all combinations of 2 people who are connected by that committee
NYIM_edges <- committee_nodes %>% 
  group_by(NYIM) %>%
  filter(n()>=2) %>% group_by(NYIM) %>%
  do(data.frame(t(combn(.$LAST, 2)), stringsAsFactors=FALSE))

CHAIRMEN_edges <- committee_nodes %>% 
  group_by(CHAIRMEN) %>%
  filter(n()>=2) %>% group_by(CHAIRMEN) %>%
  do(data.frame(t(combn(.$LAST, 2)), stringsAsFactors=FALSE))

CREDENTIAL_COM_edges <- committee_nodes %>% 
  group_by(CREDENTIAL_COM) %>%
  filter(n()>=2) %>% group_by(CREDENTIAL_COM) %>%
  do(data.frame(t(combn(.$LAST, 2)), stringsAsFactors=FALSE))

DRAFTING_COMM_edges <- committee_nodes %>% 
  group_by(DRAFTING_COMM) %>%
  filter(n()>=2) %>% group_by(DRAFTING_COMM) %>%
  do(data.frame(t(combn(.$LAST, 2)), stringsAsFactors=FALSE))

STEERING_COMM_edges <- committee_nodes %>% 
  group_by(STEERING_COMM) %>%
  filter(n()>=2) %>% group_by(STEERING_COMM) %>%
  do(data.frame(t(combn(.$LAST, 2)), stringsAsFactors=FALSE))

RULES_COMM_edges <- committee_nodes %>% 
  group_by(RULES_COMM) %>%
  filter(n()>=2) %>% group_by(RULES_COMM) %>%
  do(data.frame(t(combn(.$LAST, 2)), stringsAsFactors=FALSE))


#write committee csvs to file
write.csv(CHAIRMEN_edges, 
          "/Users/gerdsonja/Desktop/CHICAGO_CONF/CHAIRMEN_edges.csv")
          
write.csv(CREDENTIAL_COM_edges, 
          "/Users/gerdsonja/Desktop/CHICAGO_CONF/CREDENTIAL_COM_edges.csv")

write.csv(DRAFTING_COMM_edges, 
          "/Users/gerdsonja/Desktop/CHICAGO_CONF/DRAFTING_COMM_edges.csv")
e
write.csv(NYIM_edges, 
          "/Users/gerdsonja/Desktop/CHICAGO_CONF/NYIM_edges.csv")

write.csv(RULES_COMM_edges, 
          "/Users/gerdsonja/Desktop/CHICAGO_CONF/RULES_COMM_edges.csv")

write.csv(STEERING_COMM_edges, 
          "/Users/gerdsonja/Desktop/CHICAGO_CONF/STEERING_COMM_edges.csv")

#I tried to create committee edges with code, but I wasn't able to figure out how to eliminate duplicate pairs in both directions without summing. Please see narrative for more. 

# Read in and name committee edges
committee_links <- read.csv("Committee_Edges.csv", stringsAsFactors = FALSE)

#check number of rows
nrow(committee_nodes)
nrow(committee_links)

#load igraph
library(igraph)

#create network object from committee_links (edges) and committee_nodes (vertices), links are not directed
net_committees <- graph_from_data_frame(d=committee_links,
                                        vertices=committee_nodes, directed=FALSE) 

#plot the network
plot(net_committees, vertex.size=5, vertex.label.cex=0.8)
#it doesn't look great, but the basic structure is as expected. There are many standard, and custom, formats to be found, so I will try some others.


#plot the network without vertex shapes and change colors and font size
plot(net_committees, vertex.shape="none", vertex.label=V(net_committees)$LAST, 
     vertex.label.font=2, vertex.label.color="blue",
     vertex.label.cex=.7, edge.color="gray85")
# not good fit for the data, even if I were to resize and 

# Circle layout
 circle <- layout_in_circle(net_committees)
 plot(net_committees, layout=circle, vertex.size=5, vertex.label.cex=0.8)
# My network is large for most of these format. I see a more customized solution (found via Stack Overflow)
 
#Trying a solution from Stack Overflow that is more tailored, since fiddling from R manual and trying on most common formats yields only minor (if any) improvements

#plot the network again, adjusting
 #**change labels to black, Label graph
plot(net_committees, edge.width = 1, 
     vertex.size=5, vertex.size2 = 3,
     vertex.label.cex=0.5, asp = .9, 
     margin = -0.1
     ) 

# list of cliques
#cliques(net_committees) 
#for some reason, this one is taking a long time and then giving me an R error that includes a bomb(!) so I stopped running it.

# clique sizes
sapply(cliques(net_committees), length) 

# cliques with max number of nodes
largest_cliques(net_committees) 
vcol <- rep("grey80", vcount(net_committees))
vcol[unlist(largest_cliques(net_committees))] <- "gold"
plot(as.undirected(net_committees), vertex.label=V(net_committees)$name, vertex.color=vcol)


#Community detection based on edge betweenness (Newman-Girvan)
#High-betweenness edges are removed sequentially (recalculating at each step) and the best partitioning of the network is selected.
ceb <- cluster_edge_betweenness(net_committees) 
dendPlot(ceb, mode="hclust")

#Another way to view cliques
plot(ceb, net_committees) 

#and more cliques
plot(ceb, net_committees, edge.width = 1, 
vertex.size=5, vertex.size2 = 3,
vertex.label.cex=0.5, asp = .9, 
margin = -0.1
)

# Evaluation mean distance (length of shortest paths btwn vertices in the network)
 mean_distance(net_committees, directed = FALSE)
 
# Find longest geodesic distance (path length) = diameter of network
 farthest_vertices(net_committees, directed = FALSE)

# Find degree of centrality for each person in the network 
degree(net_committees, mode = c("total"))
 
# Find raw betweenness score (high = highly influential)
betweenness(net_committees, directed = FALSE)
 
# Find normalized betweenness score
betweenness(net_committees, directed = FALSE, normalized = )
 
#Find centrality score for each vertex
# Confirms Warrior's importance in the network
# (Why is Winchester's score so low?)
# (look at scores of 1)
eigen_centrality(net_committees, directed = FALSE)$vector

# Count number of closed triangles in network (measure of local connectivity); more applicable at subcommittee level or when looking at small network
triangles(net_committees)

# Measure the probability that the adjacent vertices of a network are connected
transitivity(net_committees)

# Count the number of triangles each vertex is a part of (default = all)
count_triangles(net_committees, vids = )

# Find cliques in the network
largest.cliques(net_committees)

# Cliques Find cliques (complete subgraphs of an undirected graph)
# list of cliques
cliques(net_committees)       

largest_cliques(net_committees) 
vcol <- rep("grey80", vcount(net_committees))

vcol[unlist(largest_cliques(net_committees))] <- "gold"


# Do vertices with high connectivity connect preferentially to other vertices with high connectivity? 
assortativity.degree(net_committees, directed = FALSE)


 #write csvs to file
 write.csv(chicago_data, file = "/Users/gerdsonja/Desktop/CHICAGO_CONF/chicago_data.csv", row.names = FALSE)
 write.csv(chicago_data, file = "/Users/gerdsonja/Desktop/CHICAGO_CONF/committee_links.csv", row.names = FALSE)
 write.csv(chicago_data, file = "/Users/gerdsonja/Desktop/CHICAGO_CONF/committee_nodes.csv", row.names = FALSE)
 write.csv(chicago_data, file = "/Users/gerdsonja/Desktop/CHICAGO_CONF/db_committees.csv", row.names = FALSE)
 write.csv(chicago_data, file = "/Users/gerdsonja/Desktop/CHICAGO_CONF/usa.csv", row.names = FALSE)

 
 
 
 
 
