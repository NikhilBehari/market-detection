# market-detection
This repository contains code examples from the paper: *Satellite-Based Food Market Detection for Micronutrient Deficiency Prediction.*

<img align="center" src="methodology.png" width="100%" >

## Abstract
Micronutrient deficiency (MND) is a nutritional disorder caused by a lack of essential vitamins and minerals, often leading to severe physical and mental developmental impairment. MND is highly prevalent worldwide, particularly in South Asia, South America, and sub-Saharan Africa, and affects an estimated 2 billion people. Public health research in MND indicates that food markets are often correlated with improved dietary diversity, a proxy for MND prediction. However, data on market locations is limited, particularly in rural areas where MND is most common. We propose an approach to automatically detect regional food markets from publicly available geographic infrastructure data and satellite imagery, which may be used towards developing a cost-effective, noninvasive MND prediction model.

## Usage
This repository contains various code examples to help run the methods described in the paper. R is used to simplify raster transformation examples; Python may be used for these same functions if desired. *map-download* contains an example of downloading images from the Google Maps Static API. An API key is needed to run this code, which can be obtained from the Maps Static API [website](https://developers.google.com/maps/documentation/maps-static/overview).

**region_identification** using a target point as a central location, determines an extent that may provide a reasonable amount of close-proximity OSM building data for training data generation. 

**training_search** contains various functions that help to download training data given the input OSM files.

**map_download** provides code that may be used to download tiles of Google Maps Static API satellite imagery. Imagery must be downloaded in tiles becuase of Static API constraints, but strides may be used to ensure buildings are not cut off. 

**model_training** contains sample code that may be used to train the segmentation model. To use this code, direct filepath constants to local repository of images and masks in .png format, which will be used to train a segmentation algorithm. Note that augmentation is done within the code example, and does not have to be done ahead of time. 

## Resource Examples 
The folder *building-shapefiles* contains an example of the building blueprints available from OSM. Likewise, OSM data on places and roads can be found in *places-shapefiles* and *roads-shapefiles* respectivley. This data in particular was downloaded from [Geofabrik Downloads](http://download.geofabrik.de/north-america.html), which was also used to download the Madagascar data. A sample region in Delaware is chosen in this case. Additionally, *training-exs* contains examples of satellite image outputs and masks that may be used for segmentation model training.
