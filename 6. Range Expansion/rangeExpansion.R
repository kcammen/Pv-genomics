library(VariantAnnotation)
library(data.table)
library(parallel)
library(SNPRelate)
library(rworldmap)
library(geosphere)
library(rnaturalearth)
library(sf)
library(ggplot2)
library(ggrepel)
library(ggspatial)
library(ggnewscale)

vcf <- readVcf("InputFiles/final_merged_depthmask2_bialleleSNPsonly_maf05_California_renamed_miss05_miss01.LDpruned.vcf") #needs to be unzipped

#Downsample to same # per pop
popfile <- read.table("InputFiles/popfile_wCalifornia.tsv")
filter_popfile <- popfile[which(popfile$Sample %in% colnames(vcf)),] #removes individuals with large amounts of missing data
filter_popfile_noCA <- filter_popfile[-which(filter_popfile$Pop == "CAL"), ]
pop_counts <- table(filter_popfile_noCA$Pop)
n_per_pop <- min(pop_counts) #4 (Svalbard)

set.seed(123)
keep_samples <- unlist(
  tapply(filter_popfile_noCA$Sample, filter_popfile_noCA$Pop, function(x) {
    sample(x, n_per_pop)
  })
)
keep_samples <- c(keep_samples, "PV293")

vcf_balanced <- vcf[, keep_samples]

#Convert to genotype matrix
gt <- geno(vcf_balanced)$GT

gt_to_num <- function(x) {
  if (x %in% c("0/0", "0|0")) return(0)
  if (x %in% c("0/1", "1/0", "0|1", "1|0")) return(1)
  if (x %in% c("1/1", "1|1")) return(2)
  return(NA)
}

geno_num <- apply(gt, c(1,2), gt_to_num)
dim(geno_num) #12122 37

geno_num <- t(geno_num)
dim(geno_num) #37 12122

rownames(geno_num) <- colnames(vcf_balanced)
colnames(geno_num) <- rownames(gt)  # variant IDs

geno_num <- as.matrix(geno_num)
storage.mode(geno_num) <- "numeric"

write.table(
  geno_num,
  file = "Output Files/GT.snapp",
  sep = ",",
  quote = FALSE,
  row.names = TRUE,
  col.names = FALSE
)

#Create a coords file
coords <- popfile[which(popfile$Sample %in% keep_samples),]
coords$outgroup <- ifelse(coords$Pop == "CAL", 1, 0) 

sampling_sites <- read.csv("InputFiles/Sampling Sites.csv")
sampling_sites <- sampling_sites[,c("Abbreviation", "Latitude", "Longitude")]
colnames(sampling_sites)[1] <- "Pop"

coords <- coords %>%
  left_join(sampling_sites, by = "Pop")

coords$Latitude[which(coords$Pop == "CAL", )] <- 36.6
coords$Longitude[which(coords$Pop == "CAL", )] <- -121.9

coords <- coords %>%
  mutate(region = case_when(
    Pop == "NFL" ~ "western",
    Pop == "HUD" ~ "western",
    Pop == "GOM" ~ "western",
    Pop == "GRN" ~ "Arctic",
    Pop == "ICE" ~ "Arctic",
    Pop == "SVA" ~ "Arctic",
    Pop == "WAD" ~ "eastern",
    Pop == "KAT" ~ "eastern",
    Pop == "KAL" ~ "eastern",
    TRUE ~ NA_character_
  ))

colnames(coords)
colnames(coords) <- c("id", "pop", "outgroup", "latitude", "longitude", "region")
coords <- coords[,c(1,5,4,3,6,2)]
str(coords)

setdiff(coords$Sample, rownames(geno_num))

write.table(coords,file = "Output Files/coord.csv",row.names = FALSE,quote = FALSE,col.names = TRUE,sep=",")

#prepare raw data for range expansion analyses
raw.data<- load.data.snapp(snapp.file="Output Files/GT.snapp",
                            coords.file="Output Files/coord.csv",
                            n.snp=-1,
                            sep=',', ploidy=2)
str(raw.data) #allele coding has been polarized by outgroup, no longer includes outgroup, and has dropped sites where outgroup was uninformative
str(raw.data$coords) #no longer includes outgroup

pop_sim <- make.pop(raw.data, ploidy=2)

#calculate psi for columns i,j, both resampled down to n samples
#perform binomial test to test significance of directionality index
PSIs <- get.all.psi.mc.bin(pop_sim,n=4,cores=10)
psi_table <- round(PSIs$psi, 2)
colnames(psi_table) <- c("GOM","GRN","HUD","ICE","KAL","KAT","NFL","SVA", "WAD")
rownames(psi_table) <- c("GOM","GRN","HUD","ICE","KAL","KAT","NFL","SVA", "WAD")
psi_table <- psi_table[c("HUD", "GOM","NFL","GRN","ICE","SVA","KAT", "KAL", "WAD"), c("HUD", "GOM","NFL","GRN","ICE","SVA","KAT", "KAL", "WAD")]
write.csv(psi_table, "Output Files/psi_table.csv")

#ψ > 0: population i (row) appears to be farther from the expansion origin than population j (column); pop i was colonized after pop j
#ψ < 0: population j appears to be farther from the expansion origin than population i
#ψ ≈ 0: no directional signal between the pair

rowSums(psi_table)
# order samples by summing all its psi; small sum psi = closer to orgin; larger sum psi = farthest along expansion

round(PSIs$pvals, 2)
psi_table_p <- round(PSIs$pvals, 2)
colnames(psi_table_p) <- c("GOM","GRN","HUD","ICE","KAL","KAT","NFL","SVA", "WAD")
rownames(psi_table_p) <- c("GOM","GRN","HUD","ICE","KAL","KAT","NFL","SVA", "WAD")
psi_table_p <- psi_table_p[c("HUD", "GOM","NFL","GRN","ICE","SVA","KAT", "KAL", "WAD"), c("HUD", "GOM","NFL","GRN","ICE","SVA","KAT", "KAL", "WAD")]
write.csv(psi_table_p, "Output Files/psi_table_p.csv")

#Prepare data for TDoA estimations of range expansion origin
tdoa.psi <- prep.tdoa.data(pop_sim$coords, PSIs$psi)
str(tdoa.psi)    

### estimate FST using SNPrelate ###
GTs <- geno_num[coords$outgroup==0,]
dim(GTs)
name <- paste0(sample(1:10000000,1),".gds")
snpgdsCreateGeno(name, genmat = t(GTs),sample.id = rownames(GTs), snp.id =colnames(GTs), snpfirstdim=TRUE) ### sample ID should be 1: how many individuals you have
file_gds <- snpgdsOpen(name)
snpgdsSummary(file_gds)    

a <- apply(cbind(pop_sim$coords$latitude,pop_sim$coords$longitude),1,paste,collapse="")
b <- apply(cbind(coords$latitude,coords$longitude),1,paste,collapse="")
coords$pop <- pop_sim$coords$pop[match(b,a)]
    
keep <- coords$outgroup ==0
fst <- snpgdsFst(file_gds, population=as.factor(coords[keep,]$pop), sample.id = coords[keep,]$id, method="W&C84") #global Fst
    
nPops <- nrow(pop_sim$coords)
ij <- as.matrix(expand.grid(pop_sim$coords$pop,pop_sim$coords$pop))
FST <- matrix(NA, ncol = length(pop_sim$coords$pop), nrow = length(pop_sim$coords$pop),  dimnames = list(pop_sim$coords$pop, pop_sim$coords$pop))
    
FST[ij] <-   unlist(apply(ij,1,function(x){
  if(x[1]!=x[2]){
    #print(x)
    keep <- which(coords$pop%in%x & coords$outgroup==0)
    capture.output(fst<-snpgdsFst(file_gds, population=as.factor(coords[keep,]$pop), sample.id = coords[keep,]$id, method="W&C84")$Fst,file = "NULL")  
        
  }else{
    #print(x)
    fst <- NA
  }
  return(fst)
}))
FST <- FST[pop_sim$coords$pop,pop_sim$coords$pop]
    
FSTs <- data.table(mean_Fst_pop=mean(FST,na.rm = TRUE), #average of pairwise estimates
                   global_Fst=fst$Fst, #weighted Fst estimate
                   mean_fst_SNP=fst$MeanFst) #average of Fst estimates across SNPs
    
snpgdsClose(file_gds)
system(paste0("rm ",name))
    
ij <- as.matrix(expand.grid(1:nPops,1:nPops))
    
tmp <- cbind(pop_sim$coords$latitude,pop_sim$coords$longitude)
pop_distances <- data.table(ij,Eucl=as.matrix(dist(tmp))[ij])
pop_distances[,Fst:=as.vector(FST)]
pop_distances[,PSI:=as.vector(PSIs$psi)]
pop_distances[,pval_psi:=as.vector(PSIs$pvals)]
pop_distances[,Counts:=as.vector(PSIs$cnts)]

### TDOA analyses ###
bbox <- get.sample.bbox(pop_sim$coords)
    
origin_psi <- single.origin_mod(tdoa.psi, bbox,  pop.coords=coords,
                                pct=0.01,
                                xlen=100, ylen=100, 
                                exclude.ocean=F,
                                exclude.land=T)

pdf("Plots/Origin_PSI.pdf", width = 4, height = 2.9)
plot.origin.results(origin_psi, add.likely.origin = TRUE, add.sample.het = FALSE)
dev.off()
#plots likelihood of each grid point being the origin, with white/yellow = high and red = low, and gray = not possible
#Note that X marking inferred origin is not plotted correctly due to lat/long transformation mismatch

psi_dt <- as.data.table(as.table(psi_table))
setnames(psi_dt, c("pop1","pop2","psi"))

p_dt <- as.data.table(as.table(psi_table_p))
setnames(p_dt, c("pop1","pop2","p"))

edges <- merge(psi_dt, p_dt,
               by = c("pop1","pop2"))

edges <- edges[pop1 != pop2] #remove diagonal
  
edges[, `:=`(
  from = ifelse(psi > 0, pop2, pop1),
  to   = ifelse(psi > 0, pop1, pop2),
  weight = abs(psi)
)]
  
sampling_sites <- as.data.table(sampling_sites)

edges <- merge(
  edges,
  sampling_sites[, .(Pop, Longitude, Latitude)],
  by.x = "from",
  by.y = "Pop"
)

setnames(edges,
         c("Longitude","Latitude"),
         c("lon_from","lat_from"))

edges <- merge(
  edges,
  sampling_sites[, .(Pop, Longitude, Latitude)],
  by.x = "to",
  by.y = "Pop"
)

setnames(edges,
         c("Longitude","Latitude"),
         c("lon_to","lat_to"))

marine_dists_df <- read.table("Output Files/marine_dists.csv", sep = ",", header = TRUE, row.names = 1)
marine_dists_df <- as.data.table(marine_dists_df)

#Calculate distance to origin
# Download world landmass as 'sf' object
land <- ne_countries(scale = "medium", returnclass = "sf")
land_proj <- st_transform(land, crs = 3035) #Project using  EPSG:3035 (ETRS89 / LAEA Europe) so that we can end up with distance in km instead of degrees

# Create a raster template covering the area of interest
bbox_proj <- st_bbox(c(xmin = -100, xmax = 25, ymin = 40, ymax = 80), crs = st_crs(4326)) %>%
  st_transform(3035) %>% st_bbox()
r <- raster(extent(bbox_proj), res = 5000)  # ~10 km resolution
crs(r) <- sf::st_crs(3035)$proj4string

# Rasterize land as 1, water as NA (we'll invert this next)
land_raster <- rasterize(land_proj, r, field = 1, background = NA)

# Invert: water = 1, land = NA
water_raster <- is.na(land_raster)
water_raster[water_raster == 0] <- NA  # set land pixels to NA explicitly
water_raster[water_raster == 1] <- 1   # water pixels = 1

# Use 8-direction movement (diagonals allowed)
tr <- transition(water_raster, transitionFunction = function(x) 1, directions = 8)

# Geographically correct the transition matrix
tr_geo <- geoCorrection(tr, type = "c")

#Read in sampling site coordinates
site_info <- read.csv("InputFiles/Sampling Sites.csv", stringsAsFactors = FALSE)
site_points <- st_as_sf(site_info[1:9,c(2,5,6)], coords = c("Longitude", "Latitude"), crs = 4326)  # WGS84
site_points_proj <- st_transform(site_points, crs = 3035)
site_coords <- st_coordinates(site_points_proj)  # for gdistance

origin_coords <- st_coordinates(origin_loc)

# Compute marine least-cost distance matrix
origin_marine_dists_m <- costDistance(tr_geo, origin_coords, site_coords) # in m
origin_marine_dists_km <- origin_marine_dists_m / 1000
print(origin_marine_dists_km)

dist_from_origin <- cbind.data.frame(sampling_sites$Pop[1:9], as.vector(origin_marine_dists_km))
colnames(dist_from_origin) <- c("Pop", "Dist (km)")
write.csv(dist_from_origin, "Output Files/dist_from_origin.csv")

for(i in 1:nrow(sampling_sites[Pop != ""])) {
  sampling_sites$dist_origin[i] <- origin_marine_dists_km[i]
}

edges <- merge(
  edges,
  sampling_sites[, .(Pop, dist_origin)],
  by.x = "from",
  by.y = "Pop"
)

setnames(edges,
         "dist_origin",
         "dist_frompop_origin")

edges <- merge(
  edges,
  sampling_sites[, .(Pop, dist_origin)],
  by.x = "to",
  by.y = "Pop"
)

setnames(edges,
         "dist_origin",
         "dist_topop_origin")

dist_long <- rbind(
  marine_dists_df[, .(from = pop1, to = pop2, dist)],
  marine_dists_df[, .(from = pop2, to = pop1, dist)]
)

edges <- merge(
  edges,
  dist_long,
  by = c("from", "to"),
  all.x = TRUE
)

edges_signif <- edges[p < 0.05] #keep only significant psi values

edges_sig_outward <- edges_signif[dist_topop_origin > dist_frompop_origin] #keeps only edges that move away from the origin

setnames(edges_sig_outward, "dist", "geo_dist")

edges_sig_outward_geolimit <- edges_sig_outward[geo_dist < 3100]

setorder(edges_sig_outward_geolimit, from, -weight)

lines <- lapply(seq_len(nrow(edges_sig_outward_geolimit)), function(i) {
  st_linestring(matrix(
    c(edges_sig_outward_geolimit$lon_from[i], edges_sig_outward_geolimit$lat_from[i],
      edges_sig_outward_geolimit$lon_to[i],   edges_sig_outward_geolimit$lat_to[i]),
    ncol = 2, byrow = TRUE
  ))
})

edge_lines <- st_sf(
  edges_sig_outward_geolimit,
  geometry = st_sfc(lines, crs = 4326)
)  
  
edge_lines_proj <- st_transform(edge_lines, 3035)

edge_lines_proj$w_scaled <- scales::rescale(edge_lines_proj$weight, to = c(0.1, 1))

# Download world landmass as 'sf' object
land <- ne_countries(scale = "medium", returnclass = "sf")
land_proj <- st_transform(land, crs = 3035) #Project using  EPSG:3035 (ETRS89 / LAEA Europe) so that we can end up with distance in km instead of degrees

# Project bounds corners to CRS units
bbox_proj <- st_bbox(c(xmin = -100, xmax = 25, ymin = 40, ymax = 80), crs = st_crs(4326)) %>%
  st_transform(3035) %>% st_bbox()
xlim <- st_bbox(bbox_proj)[c("xmin", "xmax")]
ylim <- st_bbox(bbox_proj)[c("ymin", "ymax")]

#Read in sampling site coordinates
site_info <- read.csv("InputFiles/Sampling Sites.csv", stringsAsFactors = FALSE)
site_points <- st_as_sf(site_info, coords = c("Longitude", "Latitude"), crs = 4326)  # WGS84
site_points_proj <- st_transform(site_points, crs = 3035)

site_points_proj$Region <- factor(site_points_proj$Region, levels = c("western", "Arctic", "eastern"))
site_points_proj$SiteNo <- factor(site_points_proj$SiteNo, levels = c("1", "2", "3"))
site_points_proj$Abbreviation <- factor(site_points_proj$Abbreviation, levels = c("HUD", "GOM", "NFL", "GRN", "ICE", "SVA", "KAT", "WAD", "KAL"))

RangeExpansionMap <- ggplot() +
  geom_sf(data = land_proj, fill = "gray80", color = "white") +
  geom_sf(data = site_points_proj[1:9,], aes(color = Region), size = 1) +
  geom_sf(data = edge_lines_proj,
          linewidth = 0.15,
          color = "black", 
          arrow = arrow(
  type = "open",
  length = unit(0.15, "cm"))
  ) +
scale_color_manual(values = c("turquoise4", "darkred", "orange2")) +
  scale_shape_manual(values = c(4, 21, 24)) +
  geom_text_repel(
    data = site_points_proj,
    aes(x = st_coordinates(site_points_proj)[,1],
        y = st_coordinates(site_points_proj)[,2],
        label = Abbreviation),
    size = 2,
    max.overlaps = 50
  ) +
  coord_sf(xlim = xlim, ylim = ylim, expand = FALSE, label_graticule = "none") +
  annotation_scale(location = "bl", 
                   width_hint = 0.15, height = grid::unit(0.02, "npc"),
                   pad_x = unit(0.1, "cm"), pad_y = unit(0.1, "cm"), 
                   text_cex = 0.5) +  # Scale bar
  theme_minimal() +
  theme(legend.position = "none", axis.title = element_blank())
RangeExpansionMap
ggsave("Plots/RangeExpansionPaths_3100.pdf")
  
xlen=100
ylen=100
s1<-seq(bbox[1,1],bbox[1,2], length.out=xlen)
s2<-seq(bbox[2,1],bbox[2,2], length.out=ylen)

grid <- expand.grid(
  x = s1,
  y = s2
)
    
rel_points <- st_as_sf(grid, coords = c("x", "y"), crs = 4326)  # WGS84
rel_points_proj <- st_transform(rel_points, crs = 3035)

rel <- (origin_psi[[1]]>0) * (origin_psi[[2]]-min(origin_psi[[2]],na.rm=T)) /
    (max(origin_psi[[2]],na.rm=T)-min(origin_psi[[2]],na.rm=T))+0.001

#find the origin
tmp <- origin_psi$rsq
tmp[origin_psi$d0 <= 0] <- NA
best <- which(tmp == max(tmp, na.rm = TRUE), arr.ind = TRUE) #33,11 = row 1033
    
origin_loc <- rel_points_proj[1033,]

rel_points_proj$rel <- as.vector(rel)

n.levels = 100
color.function=colorRampPalette(heat.colors(100)[1:90])
color.negative=NA_character_

levels <- c(0,quantile(rel[rel>0.001], 0:n.levels/n.levels, na.rm=T) + 
              1e-6 * 0:n.levels/n.levels)
cols <- c(color.negative, color.function(n.levels-1))

rel_points_proj$rel_bin <- cut(
  rel_points_proj$rel,
  breaks = levels,
  include.lowest = TRUE
)
bin_levels <- levels(rel_points_proj$rel_bin)
names(cols) <- bin_levels[1:length(cols)]

RangeExpansionMap_wOrigin <- ggplot() +
  geom_sf(data = rel_points_proj, aes(color = rel_bin), show.legend = FALSE) +  
  scale_color_manual(values = cols, drop = FALSE, na.value = "transparent") +
  ggnewscale::new_scale_color() +
  
  geom_sf(data = land_proj, fill = "white", color = "gray") +
  geom_sf(data = site_points_proj[1:9,], aes(color = Abbreviation), size = 1) +  
  scale_color_manual(values = c("GOM" = "turquoise4", 
                                "NFL" = "turquoise4", 
                                "HUD" = "turquoise4", 
                                "GRN" = "darkred", 
                                "ICE" = "darkred", 
                                "SVA" = "darkred",
                                "KAT" = "orange2",
                                "WAD" = "orange2",
                                "KAL" = "orange2"),
                      labels = c("HUD" = "Hudson Bay (HUD; N=18)", 
                                "NFL" = "Newfoundland (NFL; N=10)", 
                                "GOM" = "Gulf of Maine (GOM; N=20)",
                                "GRN" = "Greenland (GRN; N=20)",
                                "ICE" = "Iceland (ICE; N=14)",
                                "SVA" = "Svalbard (SVA; N=12)",
                                "WAD" = "Wadden Sea (WAD; N=28)",
                                "KAT" = "Kattegat (KAT; N=26)",
                                "KAL" = "Kalmar Strait (KAL; N=12)")
                                ) +
  scale_shape_manual(values = c(4, 21, 24)) +
  geom_text_repel(
    data = site_points_proj,
    aes(x = st_coordinates(site_points_proj)[,1],
        y = st_coordinates(site_points_proj)[,2],
        label = Abbreviation),
    size = 2,
    max.overlaps = 50
  ) +
  
  geom_sf(data = rel_points_proj[1033,], color = "black", pch = 8, size = 2) +

  geom_sf(data = edge_lines_proj,
          linewidth = 0.15,
          color = "black", 
          arrow = arrow(
  type = "open",
  length = unit(0.15, "cm"))
  ) +

  coord_sf(xlim = xlim, ylim = ylim, expand = FALSE, label_graticule = "none") +
  annotation_scale(location = "bl", 
                   width_hint = 0.15, height = grid::unit(0.02, "npc"),
                   pad_x = unit(0.1, "cm"), pad_y = unit(0.1, "cm"), 
                   text_cex = 0.5) +  # Scale bar
  theme_minimal() +
  theme(legend.position = "right", legend.title = element_blank(), axis.title = element_blank())

RangeExpansionMap_wOrigin
ggsave("Plots/RangeExpansionPaths_wOrigin_3100.pdf")
