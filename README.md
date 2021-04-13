# Flow Cytometry Analysis Using R

## Introduction

Flow cytometry data is normally ananlysed using commercial softwares such as FlowJo. While it is user-friendly and generates beautiful graphs, it takes time to be trained to maximise the functionality of the software and it is not always accessible due to the costs. Recently, I came across with this task where it was easier for me to do the flow analysis in R rather than paying for a licence myself or to access FlowJo at the core facility. This is a draft script focusing on producing graphs rather than large scale flow data analysis, which can be adapt easily. I would also like to point out that I've learnt a from the vignettes produced by [Johannes C Hellmuth] (https://jchellmuth.com/posts/FACS-with-R/) and [Christopher Hall] (https://github.com/hally166/Cytometry-R-scripts/blob/master/flowWorkspace.R). Christopher Hall also created youtube courses providing detailed workflow as well as trouble shooting tips, which can be find [here] (https://www.youtube.com/watch?v=ijHOGHP82EY).  

## Main steps

1. Load the packages
There are a few specialised pacakges for flow cytometry data analysis, including flowCore, flowWorkspace, openCyto, ggcyto and flowAI. You can choose freely for your need. 

2. Load the .fcs files
Just like how you conduct a flow cytometry experiment, you need to have the files for all the controls you ran as well as the real sort/analysis samples. 

3. Compensation information retrieval
The compensation information can be retrieved from $SPILL. This is crucial when running experiments with complicated panels involving a lot of fluorophores.

4. Transformation
From my limited experience with this type of analysis, it is handy to transform all the stained the channels but leave FSC and SSC data as they are. You can easily change the axis in the graphs later according to your need.

5. Gating Steps
This is the workflow of my gating strategy:
Cells (removing debris) -> FSC singlets -> SSC singlets -> live cells (using DAPI to exclude dead cells) -> target stain (in my case, this is a GFP transgene)
Experiments involving large panels are not covered in this script. However, this is a good start and ready to scale up. Gating takes some time but just like setting up your panel for flow experiments. Once the parameters and strategies are set, you are ready to scale up very quickly by reusing the same settings.

## Future plans

This is a minimal script I developed just for me and I will look into adding more complicated user cases and statistics analyses when I have more time. If you happen to stumble on my vignette, I hope this can help you.  
