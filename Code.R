# Danish-Ministry-of-Food-Project

#The data contains 35064 crimes and 23 variables, and there are some wrangling need to do, such as remove the columns I don't need, omit 'NA's, convert the data to the right types.

# Install all required packages.
install.packages(c("ggplot2", "data.table", "dplyr", "stringr", 
"xlsx", "plyr", "WDI", "ggrepel", "gridExtra", "cowplot", "gridGraphics", "kableExtra",
"knitr", "plotly", "RColorBrewer", "readxl", "scales", "tidyr"))

# Load libraries
library(xlsx)
library(stringr)
library(dplyr)
library(plyr)
library(WDI)
library(data.table)
library(ggplot2)
library(ggrepel)
library(gridExtra)
library(cowplot)
library(gridGraphics)
library(kableExtra)
library(knitr)
library(pander)
library(plotly)
library(RColorBrewer)
library(readxl)
library(scales)
library(tidyr)
Sys.setenv(JAVA_HOME="C:\Path\\to\\Java")
# Data Wrangling
x = 34
dfa = data.table(
  iso2r = character(),
  yr = character(),
  exporter = factor(),
  vlow = numeric(),
  vhigh = numeric(),
  v = numeric(),
  sharelow = numeric(),
  sharehigh = numeric(),
  gdp = numeric()
)
filenames <- list.files(path = "C:/Datasets/",
                        pattern = "tuv_96_x_+.*csv")

filenames2 = list.files(path = "C:/Datasets/",
                        pattern = "baci96_+.*csv")
wdiyear = 2000

geo_cepii = read.xlsx2("geo_cepii.xls", 1, colClasses = c(rep("character", x)))

geo_cepii$cnum =  str_pad(geo_cepii$cnum, width = 3, side = "left",  pad = "0")

geo_cepii = select(geo_cepii, iso2, iso3, cnum, country, continent) #select specific columns from file geo_cepii

setnames(geo_cepii, "cnum", "p")#rename column "cnum" to "p"

for (i in 1:length(filenames)) {
  z = fread( filenames[i], colClasses = c( r = "character", p = "character", hs6_96 = "character",
                                           yr = "character", uv = "double" ) ) 
  k = fread(filenames2[i],colClasses = c( "character",
                                          "character", "character", "character", "double", "double" ) )
  
  data = merge(z, unique(geo_cepii), by = "p")
  rm(z)
  setnames(data, "iso2", "iso2p")#rename iso2 column from "data" dataset to "iso2p"
  setnames(data, "iso3", "iso3p")
  setnames(data, "continent", "continentp")
  setnames(data, "country", "countryp")
  setnames(geo_cepii, "p", "r")
  
  data = merge(data, unique(geo_cepii), by = "r")
  
  setnames(geo_cepii, "r", "p")
  setnames(data, "country", "reporter")
  setnames(data, "continent", "continentr")
  setnames(data, "countryp", "partner")
  setnames(data, "iso2", "iso2r")
  setnames(data, "iso3", "iso3r")
  setnames(k, "t", "yr")
  setnames(k, "hs6", "hs6_96")
  setnames(k, "i", "r")
  setnames(k, "j", "p")
  
  data = merge(data, (k), by = c("r", "p", "yr", "hs6_96"), all.x = TRUE)
  
  rm(k) #remove dataset k
  
  data <- na.omit(data) #remove missing values
  setDT(data) #optional
  data[, UVworld := weighted.mean(uv, v, na.rm = TRUE), by = hs6_96] #weighted mean calculation where v=weight in the formula, group=6 digit code (hs6_96)
  
  data[, ru := uv / UVworld] #estimation of UVs/UVworld, a.k.a. relative unit value ratio (r)
  
  data[, low := ifelse(ru < 1, 1 - ru ^ 4, 0)]  #a=4
  data[, medium := ifelse(ru < 1, ru ^ 4, 1 / ru ^ 4)]
  data[, high := ifelse(ru > 1, 1 - 1 / ru ^ 4, 0)]
  setnames(data, "reporter", "exporter")
  
  x = 34
dfa = data.table(
  iso2r = character(),
  yr = character(),
  exporter = factor(),
  vlow = numeric(),
  vhigh = numeric(),
  v = numeric(),
  sharelow = numeric(),
  sharehigh = numeric(),
  gdp = numeric()
)
filenames <- list.files(path = "C:/Datasets/",
                        pattern = "tuv_96_x_+.*csv")

filenames2 = list.files(path = "C:/Datasets/",
                        pattern = "baci96_+.*csv")

wdiyear = 2000
geo_cepii = read.xlsx2("geo_cepii.xls", 1, colClasses = c(rep("character", x)))
geo_cepii$cnum =  str_pad(geo_cepii$cnum, width = 3, side = "left",  pad = "0")
geo_cepii = select(geo_cepii, iso2, iso3, cnum, country, continent) #select specific columns from file geo_cepii
setnames(geo_cepii, "cnum", "p")#rename column "cnum" to "p"
for (i in 1:length(filenames)) {
  z = fread( filenames[i], colClasses = c( r = "character", p = "character", hs6_96 = "character",
      yr = "character", uv = "double" ) ) 
  k = fread(filenames2[i],colClasses = c( "character",
      "character", "character", "character", "double", "double" ) )
  
  data = merge(z, unique(geo_cepii), by = "p")
  rm(z)
  setnames(data, "iso2", "iso2p")#rename iso2 column from "data" dataset to "iso2p"
  setnames(data, "iso3", "iso3p")
  setnames(data, "continent", "continentp")
  setnames(data, "country", "countryp")
  setnames(geo_cepii, "p", "r")
  
  data = merge(data, unique(geo_cepii), by = "r")
  setnames(geo_cepii, "r", "p")
  setnames(data, "country", "reporter")
  setnames(data, "continent", "continentr")
  setnames(data, "countryp", "partner")
  setnames(data, "iso2", "iso2r")
  setnames(data, "iso3", "iso3r")
  setnames(k, "t", "yr")
  setnames(k, "hs6", "hs6_96")
  setnames(k, "i", "r")
  setnames(k, "j", "p")
  
  data = merge(data, (k), by = c("r", "p", "yr", "hs6_96"), all.x = TRUE)
  rm(k) #remove dataset k
  
  data <- na.omit(data) #remove missing values
  setDT(data) #optional
  data[, UVworld := weighted.mean(uv, v, na.rm = TRUE), by = hs6_96] #weighted mean calculation where v=weight in the formula, group=6 digit code (hs6_96)
  
  data[, ru := uv / UVworld] #estimation of UVs/UVworld, a.k.a. relative unit value ratio (r)
  
  data[, low := ifelse(ru < 1, 1 - ru ^ 4, 0)]  #a=4
  data[, medium := ifelse(ru < 1, ru ^ 4, 1 / ru ^ 4)]
  data[, high := ifelse(ru > 1, 1 - 1 / ru ^ 4, 0)]
  setnames(data, "reporter", "exporter")
  
  data[, agridummy := ifelse(substr(hs6_96, 1, 2) < 25, 1,
                             ifelse(hs6_96 == "290543", 1,
                                    ifelse(hs6_96 == "290544", 1,
                                      ifelse(substr(hs6_96, 1, 4) == "3301", 1,
                                        ifelse(substr(hs6_96, 1, 4) == "3501" |
                                            substr(hs6_96, 1, 4) == "3502" |
                                            substr(hs6_96, 1, 4) == "3503" |
                                            substr(hs6_96, 1, 4) == "3504" | 
                                            substr(hs6_96, 1, 4) == "3505", 1,
                                              ifelse(hs6_96 == "380910", 1,
                                                 ifelse(hs6_96 == "382360", 1,
                                                   ifelse(substr(hs6_96, 1, 4) == "4101" |
                                                       substr(hs6_96, 1, 4) == "4102" | 
                                                       substr(hs6_96, 1, 4) == "4103", 1,
                                                     ifelse(substr(hs6_96, 1, 4) == "4301", 1,
                                                       ifelse(substr(hs6_96, 1, 4) == "5001" |
                                                           substr(hs6_96, 1, 4) == "5002" | 
                                                           substr(hs6_96, 1, 4) == "5003", 1,
                                                         ifelse(substr(hs6_96, 1, 4) == "5101" |
                                                             substr(hs6_96, 1, 4) == "5102" | 
                                                             substr(hs6_96, 1, 4) == "5103", 1,
                                                           ifelse(substr(hs6_96, 1, 4) == "5201" |
                                                              substr(hs6_96, 1, 4) == "5202" | substr(hs6_96, 1, 4) == "5203", 1,
                                                             ifelse(substr(hs6_96, 1, 4) == "5301" |
                                                                 substr(hs6_96, 1, 4) == "5302", 1, 0)))))))))))))]
  
  data = data[agridummy == "1"]
  data[, vlow := low * v] # total value of low segment
  data[, vhigh := high * v] # total value of high segment
  
  data = data[, j = list(
    vlow = sum(vlow, na.rm = TRUE),
    vhigh = sum(vhigh, na.rm = TRUE),
    v = sum(v, na.rm = TRUE)
  ), by = list(exporter, iso2r, yr)] # aggregating vlow and vhigh by the exporter#
  
  data[, sharelow := vlow / v]  #share of low segment per exporter
  data[, sharehigh := vhigh / v] #share of high segment per exporter
  
  WDIdata = WDI(
    indicator = "NY.GDP.PCAP.PP.KD",
    country = c('all'),
    start = wdiyear,
    end = wdiyear
  ) #download WDI dataset for GDP per capita, current usd for year 2000, all countries
  setnames(WDIdata, "iso2c", "iso2r")
  
  
  WDIdata = subset(WDIdata, select = -c(country))
  setnames(WDIdata, "NY.GDP.PCAP.PP.KD", "gdp")
  setnames(WDIdata, "year", "yr")
  #WDIdata = subset(WDIdata,yr=="2000"|yr=="2003"|yr=="2006"|yr=="2009"|yr=="2012")
  WDIdata[, c(3)] = sapply(WDIdata[, c(3)], as.character) ##converting column 3 WDIdata from "double" to "character#
  data = merge(data, unique(WDIdata), by = c("iso2r", "yr"), all.x = TRUE)
  dfa = rbind.fill(dfa, data)
  wdiyear = wdiyear + 1
}
dfa = na.omit(dfa)
  
  data = data[agridummy == "1"]
  data[, vlow := low * v] # total value of low segment
  data[, vhigh := high * v] # total value of high segment
  
  data = data[, j = list(
    vlow = sum(vlow, na.rm = TRUE),
    vhigh = sum(vhigh, na.rm = TRUE),
    v = sum(v, na.rm = TRUE)
  ), by = list(exporter, iso2r, yr)] # aggregating vlow and vhigh by the exporter#
  
  data[, sharelow := vlow / v]  #share of low segment per exporter
  data[, sharehigh := vhigh / v] #share of high segment per exporter
  
  WDIdata = WDI(
    indicator = c("NY.GDP.PCAP.PP.KD", "NY.GNP.PCAP.CD"),
    country = c('all'),
    start = wdiyear,
    end = wdiyear
  ) #download WDI dataset for GDP per capita, current usd for year 2000, all countries
  setnames(WDIdata, "iso2c", "iso2r")
  
  
  WDIdata = subset(WDIdata, select = -c(country))
  setnames(WDIdata, "NY.GDP.PCAP.PP.KD", "gdp")
  setnames(WDIdata, "year", "yr")
  #WDIdata = subset(WDIdata,yr=="2000"|yr=="2003"|yr=="2006"|yr=="2009"|yr=="2012")
  WDIdata[, c(3)] = sapply(WDIdata[, c(3)], as.character) ##converting column 3 WDIdata from "double" to "character#
  data = merge(data, unique(WDIdata), by = c("iso2r", "yr"), all.x = TRUE)
  dfa = rbind.fill(dfa, data)
  wdiyear = wdiyear + 1
}
dfa = na.omit(dfa)


# Further Data Wrangling

condf=subset(dfa, yr=="2014") #picking the largest exporters in 2014
quant80=quantile(condf$v, c(.83), na.rm=TRUE)
quant80=unname(quant80)
condf = subset(condf,v>=quant80)
condf1=select(condf, exporter)

condf=subset(dfa, yr=="2004"|yr=="2005"|yr=="2006"|yr=="2007"|yr=="2008"|yr=="2009"|yr=="2010"|yr=="2011"|yr=="2012"|yr=="2013"|yr=="2014")
condf=select(condf, iso2r,yr,exporter,v,vhigh,sharehigh,gdp)
selectedRows <- (condf$exporter %in% condf1$exporter) ##then pick the largest exporters in 2014 for every year
condf=condf[selectedRows,]

# Regression
dat = dfa
selectedRows =  (dat$exporter %in% condf1$exporter) # where condf1 is taken from Specialization Index Calculation script
dat = dat[selectedRows, ]
dat[, lgdp := log(gdp)] # Creating a column with log gdp values

fit = lm(sharehigh ~ log(gdp) + yr, data = dat)
fit
dat$predicted <- predict(fit)   # Save the predicted values
dat$residuals <- residuals(fit) # Save the residual values

# Residual Plot
ggplot(data=subset(dat, yr=="2014"), aes(x = log(gdp), y = residuals, label = exporter)) +
  geom_segment(aes(xend = log(gdp), yend = residuals), alpha = .2) +  # Lines to connect points
  geom_point((aes(color = abs(residuals), size = v, alpha=1))) +  # Points of actual values
  #+ # size also mapped
  scale_color_continuous(low = "black", high = "red") +
  guides(color = FALSE, size = FALSE) +  # Size legend also removed
  theme_bw()+
  geom_hline(yintercept = 0)+
  geom_text_repel(size=2.5)+
  theme(legend.position="none")+
  ggtitle("Figure xx: Standardized residuals of estimation (1) in 2014.")+
  theme(plot.title = element_text(size=12))
  
# TABLE 6 REPLICATION or Contribution Table for 2003, 2008 and 2014.
condf=subset(dfa, yr=="2014") ##picking the largest exporters in 2014
quant80=quantile(condf$v, c(.83), na.rm=TRUE)
quant80=unname(quant80)
condf = subset(condf,v>=quant80)
condf1=select(condf, exporter)

condf=subset(dfa, yr=="2003"|yr=="2008"|yr=="2014")

condf=select(condf, iso2r,yr,exporter,v,vhigh,sharehigh,gdp)
selectedRows <- (condf$exporter %in% condf1$exporter) ##then pick the largest exporters in 2014 for every year
condf=condf[selectedRows,]

condf$High=ifelse(condf$yr=="2003", condf$vhigh/sum(dfa$vhigh[dfa$yr == 2003])*100,
                  ifelse(condf$yr=="2008", condf$vhigh/sum(dfa$vhigh[dfa$yr == 2008])*100,
                         ifelse(condf$yr=="2014", condf$vhigh/sum(dfa$vhigh[dfa$yr == 2014])*100,0)))


  
condf$Total=ifelse(condf$yr=="2003", condf$v/sum(dfa$v[dfa$yr == 2003])*100,
                   ifelse(condf$yr=="2008", condf$v/sum(dfa$v[dfa$yr == 2008])*100,
                          ifelse(condf$yr=="2014", condf$v/sum(dfa$v[dfa$yr == 2014])*100,0)))


condf$High=ifelse(condf$yr=="2003", condf$High/condf$Total,
                  ifelse(condf$yr=="2008", condf$High/condf$Total,
                         ifelse(condf$yr=="2014", condf$High/condf$Total,0)))


df_meltH=condf    # For High Share plot (FIGURE I)
df_meltH <- tidyr::gather(condf, variable, value, sharehigh)

# Figure I
ggplot(df_meltH, aes(x = log(gdp), y = value, size = v, colour = yr, group = yr, stroke = 1, label=iso2r)) + 
  geom_jitter(aes(size=v, colour= yr), alpha=0.45, show.legend = FALSE)+ #geom_point before instead of jitter without the aes part
  geom_text(size=1.7, show.legend = FALSE)+ # not included when geom_point is used
  xlab('gdp') +
  theme_bw()+
  geom_smooth(se=TRUE, alpha = 0, show.legend = TRUE)+
  scale_size(range=c(1,10), guide=FALSE)+
  scale_color_manual(name="", values=c("2003"="seagreen4","2008"= "steelblue3","2014"= "steelblue4"))+
  theme(legend.position="bottom",legend.direction="horizontal")+
  #theme(legend.position=c(0.6,0.84))+
  xlab("Per capita GDP (log)") + ylab("value")+ 
  theme(plot.title = element_text(color="black", size=12, face="plain"))+
  theme(axis.title.y = element_blank(), plot.caption=element_text(hjust = myhjust))+
  theme(axis.title.x = element_text(size=7))+
  theme(plot.subtitle = element_text(size=8))+
  theme(plot.caption = element_text(size=8))+
  theme(axis.text.x = element_text(size=8), axis.text.y = element_text(size=8))+
  labs(title = "Figure I: GDP per capita and share of upper-market varieties from each exporter.", 
       subtitle = "Only countries above the third quartile", 
       caption = "Source: Authors' own calculations")+
  theme( axis.line = element_line(colour = "black", 
                                  size = 0.8, linetype = "solid"))+
  theme(panel.border=element_blank(), axis.line=element_line()) +
  theme(panel.grid.major.x = element_blank(), panel.grid.minor = element_blank())+#removes gridlines
  theme(axis.ticks.length=unit(0.25,"cm"))+ # adjust length of ticks
  theme(axis.ticks = element_line(size = 0.9))+ #width of ticks marks in mm
  theme(legend.text=element_text(size=6))+
  #theme(legend.background = element_rect(size=0.1, linetype="solid", 
  # colour ="black"))+
  theme(legend.margin=margin(1,0,0,0),
        legend.box.margin=margin(-10,-10,-10,-10))
# Figure II
ggplot(df_meltH, aes(x = iso2r, y = value, label=iso2r)) + # Step 7.2
  geom_point(aes(color=yr, shape=yr), size=4, alpha=1,stroke=1.5, show.legend = TRUE)+
  geom_segment(aes(x=value, y=value, xend=value, yend=value))+
  scale_shape_manual(name="", values=c(4, 2, 22))+
  xlab('country') +
  theme_bw()+ # eliminate default background 
  scale_color_manual(name="", values=c("2003"="seagreen4","2008"= "steelblue2","2014"= "steelblue4"))+
  labs(title = "Figure II: Specialization indices of individual countries in the upper segment.", 
       subtitle = "Only countries above the third quartile", 
       caption = "Source: Authors' own calculations")+
  theme(legend.position=c(0.9,0.83))+
  theme(axis.title.y = element_blank(), plot.caption=element_text(hjust = myhjust))+ # adjust Y-axis title
  theme(plot.subtitle = element_text(size=8))+ # adjust Plot subtitle
  theme(plot.caption = element_text(size=8))+ # adjust Plot caption
  xlab("") + ylab("")+ # adjust x and y axis labels
  theme(plot.title = element_text(color="black", size=12, face="plain"))+ #adjust plot title
  theme(axis.line = element_line(colour = "black", 
                                 size = 0.8, linetype = "solid"))+
  theme(panel.border=element_blank(), axis.line=element_line())+
  theme(axis.ticks.length=unit(0.25,"cm"))+ # length of tick marks - negative sign places ticks inwards
  theme(axis.ticks = element_line(size = 0.9))+ #width of ticks marks in mm
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=7,color="black"))+ # adjust X-axis labels
  theme(axis.text.y = element_text(size=8))+ # adjust Y-axis labels
  theme(legend.position="bottom",legend.direction="horizontal")+
  theme(legend.margin=margin(1,0,0,0),
        legend.box.margin=margin(-10,-10,-10,-10))+ #adjust legend margins
  theme(axis.title.x = element_text(size=7))+ # adjust X-axis title
  theme(axis.text.x = element_text(size=8), axis.text.y = element_text(size=8))+ # adjust X-axis labels
  theme(legend.text=element_text(size=6))+ #adjust legend text size
  guides(shape = guide_legend(override.aes = list(size = 2)))



# Table 6 replication for 10 years (2004-2014)
condf$High=ifelse(condf$yr=="2004", condf$vhigh/sum(dfa$vhigh[dfa$yr == 2004])*100,
                                       ifelse(condf$yr=="2005", condf$vhigh/sum(dfa$vhigh[dfa$yr == 2005])*100,
                                              ifelse(condf$yr=="2006", condf$vhigh/sum(dfa$vhigh[dfa$yr == 2006])*100,
                                                     ifelse(condf$yr=="2007", condf$vhigh/sum(dfa$vhigh[dfa$yr == 2007])*100,
                                                            ifelse(condf$yr=="2008", condf$vhigh/sum(dfa$vhigh[dfa$yr == 2008])*100,
                                                                   ifelse(condf$yr=="2009", condf$vhigh/sum(dfa$vhigh[dfa$yr == 2009])*100,
                                                                          ifelse(condf$yr=="2010", condf$vhigh/sum(dfa$vhigh[dfa$yr == 2010])*100,
                                                                                 ifelse(condf$yr=="2011", condf$vhigh/sum(dfa$vhigh[dfa$yr == 2011])*100,
                                                                                        ifelse(condf$yr=="2012", condf$vhigh/sum(dfa$vhigh[dfa$yr == 2012])*100,
                                                                                               ifelse(condf$yr=="2013", condf$vhigh/sum(dfa$vhigh[dfa$yr == 2013])*100,
                                                                                                      ifelse(condf$yr=="2014", condf$vhigh/sum(dfa$vhigh[dfa$yr == 2014])*100,0)))))))))))
                                                                                                      
                                                                                                      
                                                                                                      

condf$Total=ifelse(condf$yr=="2004", condf$v/sum(dfa$v[dfa$yr == 2004])*100,
                                        ifelse(condf$yr=="2005", condf$v/sum(dfa$v[dfa$yr == 2005])*100,
                                               ifelse(condf$yr=="2006", condf$v/sum(dfa$v[dfa$yr == 2006])*100,
                                                      ifelse(condf$yr=="2007", condf$v/sum(dfa$v[dfa$yr == 2007])*100,
                                                             ifelse(condf$yr=="2008", condf$v/sum(dfa$v[dfa$yr == 2008])*100,
                                                                    ifelse(condf$yr=="2009", condf$v/sum(dfa$v[dfa$yr == 2009])*100,
                                                                           ifelse(condf$yr=="2010", condf$v/sum(dfa$v[dfa$yr == 2010])*100,
                                                                                  ifelse(condf$yr=="2011", condf$v/sum(dfa$v[dfa$yr == 2011])*100,
                                                                                         ifelse(condf$yr=="2012", condf$v/sum(dfa$v[dfa$yr == 2012])*100,
                                                                                                ifelse(condf$yr=="2013", condf$v/sum(dfa$v[dfa$yr == 2013])*100,
                                                                                                       ifelse(condf$yr=="2014", condf$v/sum(dfa$v[dfa$yr == 2014])*100,0)))))))))))




# Replication of table 7 for 10 years (2004-2014)
condf$High=ifelse(condf$yr=="2004", condf$High/condf$Total,
                                       ifelse(condf$yr=="2005", condf$High/condf$Total,
                                              ifelse(condf$yr=="2006", condf$High/condf$Total,
                                                     ifelse(condf$yr=="2007", condf$High/condf$Total,
                                                            ifelse(condf$yr=="2008", condf$High/condf$Total,
                                                                   ifelse(condf$yr=="2009", condf$High/condf$Total,
                                                                          ifelse(condf$yr=="2010", condf$High/condf$Total,
                                                                                 ifelse(condf$yr=="2011", condf$High/condf$Total,
                                                                                        ifelse(condf$yr=="2012", condf$High/condf$Total,
                                                                                               ifelse(condf$yr=="2013", condf$High/condf$Total,
                                                                                                      ifelse(condf$yr=="2014", condf$High/condf$Total,0)))))))))))


# Plots for table 7

df_meltS = condf #for Specialization Index (FIGURE II)

df_meltS <- tidyr::gather(condf, variable, value, High)  #Step 7.1

# Figure for Developing countries ----------------------------------------
countrynames2=c("China","India","Argentina","Brazil","Malaysia","Indonesia","Mexico","Poland","Thailand")
ggx2 <- list()
for(i in 1:length(countrynames2)){
  plot=ggplot(data = df_meltS[df_meltS$exporter == countrynames2[i],], aes(x = yr, y = sharehigh, group = 1))+
    geom_line(aes(colour = "black"),alpha = 1, size = 0.3, show.legend = FALSE)+
    theme_bw()+
    scale_color_manual(values = c("grey1"))+
    geom_point(aes(colour = "black"),alpha = 1,size = 0.4, show.legend = FALSE)+
    xlab("") + ylab("")+
    theme(plot.title = element_text(color = "black", size=12, face="plain"))+
    theme(axis.title.y = element_text(size=7), plot.caption=element_text(hjust = myhjust))+
    theme(axis.title.x = element_text(size=7))+
    theme(plot.subtitle = element_text(size=7))+
    theme(plot.caption = element_text(size=8))+
    theme(axis.text.x = element_text(size=5), axis.text.y = element_text(size = 5))+
    labs(subtitle = countrynames2[i])+
    theme( axis.line = element_line(colour = "black", 
                                    size = 0.5, linetype = "solid"))+
    theme(panel.border=element_blank(), axis.line=element_line()) +
    theme(panel.grid.major.x = element_blank(), panel.grid.minor = element_blank())+#removes gridlines
    theme(axis.ticks.length=unit(0.13,"cm"))+ # adjust length of ticks
    theme(axis.ticks.x  = element_line(size = 0.4), axis.ticks.y=element_line(size = 0.4))+
    scale_y_continuous(limits=c(0, 0.2), breaks = seq(0, 0.2, by = 0.05))
  
  ggx2[[i]]=plot
}
cowplot::plot_grid(plotlist = ggx2, ncol = 3,nrow=3)

# Figure II for Developed countries -------------------
countrynames=c("Germany","Italy","Australia","Spain","France","United States of America","Belgium and Luxembourg","Canada","Netherlands")
ggx <- list()
for(i in 1:length(countrynames)){
  plot=ggplot(data = df_meltS[df_meltS$exporter == countrynames[i],], aes(x = yr, y = sharehigh, group = 1))+
    geom_line(aes(colour="black"),alpha=1, size=0.3, show.legend = FALSE)+
    theme_bw()+
    scale_color_manual(values=c("grey1"))+
    geom_point(aes(colour="black"),alpha=1,size=0.4, show.legend = FALSE)+
    xlab("") + ylab("")+
    theme(plot.title = element_text(color="black", size=12, face="plain"))+
    theme(axis.title.y = element_text(size=7), plot.caption=element_text(hjust = myhjust))+
    theme(axis.title.x = element_text(size=7))+
    theme(plot.subtitle = element_text(size=7))+
    theme(plot.caption = element_text(size=8))+
    theme(axis.text.x = element_text(size=5), axis.text.y = element_text(size = 5))+
    labs(subtitle = countrynames[i])+
    theme( axis.line = element_line(colour = "black", 
                                    size = 0.5, linetype = "solid"))+
    theme(panel.border=element_blank(), axis.line=element_line()) +
    theme(panel.grid.major.x = element_blank(), panel.grid.minor = element_blank())+#removes gridlines
    theme(axis.ticks.length=unit(0.13,"cm"))+ # adjust length of ticks
    theme(axis.ticks.x  = element_line(size = 0.4), axis.ticks.y=element_line(size = 0.4))+
    scale_y_continuous(limits=c(0, 0.36), breaks = seq(0, 0.36, by = 0.10))
  
  ggx[[i]]=plot
}
cowplot::plot_grid(plotlist = ggx,nrow = 3)

