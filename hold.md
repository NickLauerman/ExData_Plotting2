
```r
SCC <- readRDS("./data/Source_Classification_Code.rds")
str(SCC)
```

```
## 'data.frame':	11717 obs. of  15 variables:
##  $ SCC                : Factor w/ 11717 levels "10100101","10100102",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ Data.Category      : Factor w/ 6 levels "Biogenic","Event",..: 6 6 6 6 6 6 6 6 6 6 ...
##  $ Short.Name         : Factor w/ 11238 levels "","2,4-D Salts and Esters Prod /Process Vents, 2,4-D Recovery: Filtration",..: 3283 3284 3293 3291 3290 3294 3295 3296 3292 3289 ...
##  $ EI.Sector          : Factor w/ 59 levels "Agriculture - Crops & Livestock Dust",..: 18 18 18 18 18 18 18 18 18 18 ...
##  $ Option.Group       : Factor w/ 25 levels "","C/I Kerosene",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ Option.Set         : Factor w/ 18 levels "","A","B","B1A",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ SCC.Level.One      : Factor w/ 17 levels "Brick Kilns",..: 3 3 3 3 3 3 3 3 3 3 ...
##  $ SCC.Level.Two      : Factor w/ 146 levels "","Agricultural Chemicals Production",..: 32 32 32 32 32 32 32 32 32 32 ...
##  $ SCC.Level.Three    : Factor w/ 1061 levels "","100% Biosolids (e.g., sewage sludge, manure, mixtures of these matls)",..: 88 88 156 156 156 156 156 156 156 156 ...
##  $ SCC.Level.Four     : Factor w/ 6084 levels "","(NH4)2 SO4 Acid Bath System and Evaporator",..: 4455 5583 4466 4458 1341 5246 5584 5983 4461 776 ...
##  $ Map.To             : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ Last.Inventory.Year: int  NA NA NA NA NA NA NA NA NA NA ...
##  $ Created_Date       : Factor w/ 57 levels "","1/27/2000 0:00:00",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ Revised_Date       : Factor w/ 44 levels "","1/27/2000 0:00:00",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ Usage.Notes        : Factor w/ 21 levels ""," ","includes bleaching towers, washer hoods, filtrate tanks, vacuum pump exhausts",..: 1 1 1 1 1 1 1 1 1 1 ...
```

```r
head(SCC$SCC)
```

```
## [1] 10100101 10100102 10100201 10100202 10100203 10100204
## 11717 Levels: 10100101 10100102 10100201 10100202 10100203 ... 79900101
```

```r
head(SCC$Data.Category)
```

```
## [1] Point Point Point Point Point Point
## Levels: Biogenic Event Nonpoint Nonroad Onroad Point
```

```r
summary(SCC$Data.Category)
```

```
## Biogenic    Event Nonpoint  Nonroad   Onroad    Point 
##       82       71     2305      572     1137     7550
```

```r
head(SCC$Short.Name)
```

```
## [1] Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal                  
## [2] Ext Comb /Electric Gen /Anthracite Coal /Traveling Grate (Overfeed) Stoker
## [3] Ext Comb /Electric Gen /Bituminous Coal /Pulverized Coal: Wet Bottom      
## [4] Ext Comb /Electric Gen /Bituminous Coal /Pulverized Coal: Dry Bottom      
## [5] Ext Comb /Electric Gen /Bituminous Coal /Cyclone Furnace                  
## [6] Ext Comb /Electric Gen /Bituminous Coal /Spreader Stoker                  
## 11238 Levels:  ...
```

```r
head(SCC$EI.Sector)
```

```
## [1] Fuel Comb - Electric Generation - Coal
## [2] Fuel Comb - Electric Generation - Coal
## [3] Fuel Comb - Electric Generation - Coal
## [4] Fuel Comb - Electric Generation - Coal
## [5] Fuel Comb - Electric Generation - Coal
## [6] Fuel Comb - Electric Generation - Coal
## 59 Levels: Agriculture - Crops & Livestock Dust ...
```

```r
head(SCC$Option.Group)
```

```
## [1]      
## 25 Levels:  C/I Kerosene Cattle Commercial ... WW Treatment
```

```r
levels(SCC$Option.Group)
```

```
##  [1] ""                     "C/I Kerosene"         "Cattle"              
##  [4] "Commercial"           "Construction"         "Consumer/Commercial" 
##  [7] "Dry Cleaning"         "Goat"                 "Machinery"           
## [10] "Open Burning Leaf"    "P and P Product Tran" "Paved Roads"         
## [13] "Poultry"              "RWC_Fireplace"        "RWC_Furnace_cordwood"
## [16] "RWC_Furnace_pellet"   "RWC_Hydronic"         "RWC_StoveFreeStand"  
## [19] "RWC_StoveInserts"     "RWC_StovePellet"      "Stage 1 Gas"         
## [22] "Stage 2 Gas"          "Underground Tank Gas" "Unpaved Roads"       
## [25] "WW Treatment"
```

```r
summary(SCC$Option.Group)
```

```
##                              C/I Kerosene               Cattle 
##                11450                    3                   24 
##           Commercial         Construction  Consumer/Commercial 
##                   30                   15                   40 
##         Dry Cleaning                 Goat            Machinery 
##                    8                    3                    2 
##    Open Burning Leaf P and P Product Tran          Paved Roads 
##                   18                   44                   12 
##              Poultry        RWC_Fireplace RWC_Furnace_cordwood 
##                   20                    4                    3 
##   RWC_Furnace_pellet         RWC_Hydronic   RWC_StoveFreeStand 
##                    3                    5                    4 
##     RWC_StoveInserts      RWC_StovePellet          Stage 1 Gas 
##                    4                    3                    4 
##          Stage 2 Gas Underground Tank Gas        Unpaved Roads 
##                    4                    2                    3 
##         WW Treatment 
##                    9
```

```r
head(SCC$Option.Set)
```

```
## [1]      
## 18 Levels:  A B B1A B1B B2A B2B B3A B3B B4A B4B B5A B5B B6A B6B ... B8A
```

```r
levels(SCC$Option.Set)
```

```
##  [1] ""    "A"   "B"   "B1A" "B1B" "B2A" "B2B" "B3A" "B3B" "B4A" "B4B"
## [12] "B5A" "B5B" "B6A" "B6B" "B7A" "B7B" "B8A"
```

```r
summary(SCC$Option.Set)
```

```
##           A     B   B1A   B1B   B2A   B2B   B3A   B3B   B4A   B4B   B5A 
## 11436    24    84     9    44     9    37     8    14     6     8     3 
##   B5B   B6A   B6B   B7A   B7B   B8A 
##     2     3     7     3    19     1
```

```r
head(SCC$SCC.Level.One)
```

```
## [1] External Combustion Boilers External Combustion Boilers
## [3] External Combustion Boilers External Combustion Boilers
## [5] External Combustion Boilers External Combustion Boilers
## 17 Levels: Brick Kilns Domestic Ammonia ... Waste Disposal, Treatment, and Recovery
```

```r
levels(SCC$SCC.Level.One)
```

```
##  [1] "Brick Kilns"                            
##  [2] "Domestic Ammonia"                       
##  [3] "External Combustion Boilers"            
##  [4] "Industrial Processes"                   
##  [5] "Internal Combustion Engines"            
##  [6] "LPG Distribution"                       
##  [7] "MACT Source Categories"                 
##  [8] "Miscellaneous Area Sources"             
##  [9] "Mobile Sources"                         
## [10] "Natural Sources"                        
## [11] "Petroleum and Solvent Evaporation"      
## [12] "Solvent Utilization"                    
## [13] "Stationary Source Fuel Combustion"      
## [14] "Storage and Transport"                  
## [15] "very misc"                              
## [16] "Waste Disposal"                         
## [17] "Waste Disposal, Treatment, and Recovery"
```

```r
summary(SCC$SCC.Level.One)
```

```
##                             Brick Kilns 
##                                       1 
##                        Domestic Ammonia 
##                                       1 
##             External Combustion Boilers 
##                                     227 
##                    Industrial Processes 
##                                    4787 
##             Internal Combustion Engines 
##                                     233 
##                        LPG Distribution 
##                                       1 
##                  MACT Source Categories 
##                                     686 
##              Miscellaneous Area Sources 
##                                     306 
##                          Mobile Sources 
##                                    1787 
##                         Natural Sources 
##                                      82 
##       Petroleum and Solvent Evaporation 
##                                    1563 
##                     Solvent Utilization 
##                                    1061 
##       Stationary Source Fuel Combustion 
##                                     109 
##                   Storage and Transport 
##                                     489 
##                               very misc 
##                                       2 
##                          Waste Disposal 
##                                     307 
## Waste Disposal, Treatment, and Recovery 
##                                      75
```

```r
head(SCC$SCC.Level.Two, n=7)
```

```
## [1] Electric Generation Electric Generation Electric Generation
## [4] Electric Generation Electric Generation Electric Generation
## [7] Electric Generation
## 146 Levels:  ... Wood Products: SIC 24
```

```r
head(SCC$SCC.Level.Three, n=7)
```

```
## [1] Anthracite Coal               Anthracite Coal              
## [3] Bituminous/Subbituminous Coal Bituminous/Subbituminous Coal
## [5] Bituminous/Subbituminous Coal Bituminous/Subbituminous Coal
## [7] Bituminous/Subbituminous Coal
## 1061 Levels:  ...
```

```r
head(SCC$SCC>Level.Four, n=7)
```

```
## Error: object 'Level.Four' not found
```

```r
summary(SCC$Map.To)
```

```
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
## 2.02e+07 3.04e+07 3.08e+07 3.02e+08 4.03e+07 2.81e+09    11358
```

```r
summary(SCC$Last.Inventory.Year)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    2000    2000    2000    2000    2000    2010    8972
```
