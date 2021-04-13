# load packages
library(flowCore)
library(flowWorkspace)
library(openCyto)
library(ggcyto)
library(flowAI)
library(gridExtra)
library(dplyr)

# load data
fs <- flowCore::read.flowSet(path = "/Users/cass/Documents/Work_2021/Publications/Books/MiMB_angiogenesis/wetransfer-a535d1/KRS 260221 ZF Heart", pattern = ".fcs", alter.names = TRUE)
pData(fs) %>% head(3)
colnames(fs)
#[1] "FSC.A"       "FSC.H"       "SSC.A"       "SSC.H"      
#[5] "V.450.50.A"   "B.525.50.A"   "Y.G.582.15.A" "Time" 

# compensation
matrix<-spillover(fs[[1]])$SPILL
fs_comp <-compensate(fs,matrix)

# cleaning
fs_comp_clean <- flow_auto_qc(fs_comp)
#fs_comp_clean
#keyword(fs_comp_clean) <- keyword(fs)
#fs_comp_clean

# transformation
trans <- estimateLogicle(fs_comp_clean[[5]], colnames(fs_comp_clean[, c(5:7)]))
fs_comp_clean_trans <- transform(fs_comp_clean, trans)

# create the empty gating set
gs <- GatingSet(fs_comp_clean_trans)

# check the flow
plot(gs)

# Set cells gate
## define gate
g.cell <- polygonGate(filterId = "Cells", "SSC.A" = c(5e4,2e5,2e4,7e2), "FSC.A" = c(15e3,Inf,Inf,15e3))
## add singlet1 to gating set
gs_pop_add(gs,g.cell , parent = "root", name = "Cells")
recompute(gs)
## check gate
ggcyto(fs_comp_clean_trans[[5]],aes(x = FSC.A, y = SSC.A), subset = "root") + geom_hex(bins = 256) + geom_gate(g.cell) + geom_stats() + ggcyto_par_set(limits = "instrument") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), strip.background = element_blank(), strip.text.x = element_blank()) + scale_y_logicle()

# Set FSC singlet gate
## define gate
g.singlet1 <- polygonGate(filterId = "Singlet1", "FSC.H" = c(4e3,15e4,12e4,3e3), "FSC.A" = c(50,16e4,15e4,1e4))
## add singlet1 to gating set
gs_pop_add(gs,g.singlet1, parent = "Cells", name = "Singlet1")
recompute(gs)
## check gate
ggcyto(fs_comp_clean_trans[[5]],aes(x = FSC.A, y = FSC.H), subset = "Singlet1") + geom_hex(bins = 256) + geom_gate(g.singlet1) + geom_stats() + ggcyto_par_set(limits = "instrument") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), strip.background = element_blank(), strip.text.x = element_blank()) 

# Set SSC singlet gate
## define gate
g.singlet2 <- polygonGate(filterId = "Singlet2", "SSC.H" = c(4e2,1e5,5e4,2e2), "SSC.A" = c(2e2,9e4,9e4,2e2))
## add singlet1 to gating set
gs_pop_add(gs,g.singlet2, parent = "Singlet1", name = "Singlet2")
recompute(gs)
## check gate
ggcyto(fs_comp_clean_trans[[5]],aes(x = SSC.A, y = SSC.H), subset = "Singlet2") + geom_hex(bins = 256) + geom_gate(g.singlet2) + geom_stats() + ggcyto_par_set(limits = "instrument") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), strip.background = element_blank(), strip.text.x = element_blank()) + scale_x_logicle() + scale_y_logicle()

# Set live gate
## define gate
g.live <- polygonGate(filterId = "live", "SSC.A" = c(2e5,2e5,3e2,3e2), "V.450.50.A" = c(-Inf, 2.8, 1, -Inf))
## add singlet1 to gating set
gs_pop_add(gs,g.live, parent = "Singlet2", name = "live")
recompute(gs)
## check gate
ggcyto(fs_comp_clean_trans[[5]],aes(x = V.450.50.A, y = SSC.A), subset = "live") + ggcyto_par_set(limits = "instrument") + geom_hex(bins = 256) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), strip.background = element_blank(), strip.text.x = element_blank()) + geom_gate(g.live) + geom_stats() + scale_y_logicle() + labs(x = "UV.450.50.A DAPI")

## plot GFP
g.gfp <- rectangleGate(filterId = "GFP positive", "B.525.50.A" = c(2.8, Inf)) # set gate
ggcyto(fs_comp_clean_trans[[5]],aes(x = B.525.50.A), subset = "GFP positive") + geom_density(fill= "forestgreen") + geom_gate(g.gfp) + geom_stats(adjust = 0.5, y = 0.4, digits = 1) + ggcyto_par_set(limits = "instrument") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), strip.background = element_blank(), strip.text.x = element_blank())
