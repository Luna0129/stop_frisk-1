# Spatial Analysis Fall 2018 Project

**Team:** Alan Chen, Clare Clingain, Emily Coco, Wenshu Yang, Haowen Zheng


## Purpose: Spatial Analysis of NYPD SQF Clustering in 2011


## Research Questions

* 1a) Where are the “hotspots” (by census tract) of people being stopped for (i. clothing, ii. furtive movements) in New York City?  
* 1b) What is the demographic breakdown of the census tracts where these “hot spots” occur?


## Analytical Plan
### Question 1a

1. Subset the data to weeknights (Sun - Thurs, 10PM - 6AM) in 2011 (greatest annual # of stops)  
2. Calculate rate (census tract) of stops due to:  
    - clothing commonly used in a crime  
    - furtive movements  
3. Global tests of spatial autocorrelation  
4. Local Moran’s test to identify hotspots  
    - compare rook and queen weighting methods  

### Question 1b

1. Summarize demographic information from census tracts identified as hotspots


## Data:
* 2011 NYC Stop, Question, and Frisk data: [NYPD](https://www1.nyc.gov/site/nypd/stats/reports-analysis/stopfrisk.page)
* Demographic data: [2011 American Community Survey 1-Year Estimates for New York](https://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_pums_csv_2011&prodType=document)
* 2010 NYC Census Tract Shapefiles: [NYC Open Data](https://data.cityofnewyork.us/City-Government/2010-Census-Tracts/fxpq-c8ku)

**NOTE**: Run on R version 3.5.1
