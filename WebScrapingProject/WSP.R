######        NYCDSA: WebScraping Project      #######
######        Author: Neha Chanu               #######

#################################################
################{ OVERALL QUESTION }#############
#################################################
#Why do some sneakers sell more than others? What could be the differentiating factor(s)? 
#Insights for businesses(StockX, Nike, Adidas, other sneaker businesses) and consumers using StockX.

library(ggplot2)
library(plotly)
packageVersion('plotly')
library(gapminder)
library(data.table)
library(dplyr)
library(lubridate)
library(chron)
library(scales)
library(ggrepel)
library(forcats)
library(ggthemes)

########### Import the datasets ##########

Adidas_Yeezy <- fread("/Users/nehachanu/Desktop/WebScrapingProject/Adidas_StockX.csv", stringsAsFactors = F)
Adidas_Yeezy <- as.data.frame(Adidas_Yeezy)

Nike_AirJordan <- fread("/Users/nehachanu/Desktop/WebScrapingProject/AirJordan_StockX.csv", stringsAsFactors = F)
Nike_AirJordan <- as.data.frame(Nike_AirJordan)
Nike_AirJordan$Brand <- gsub("Air Jordan", "Nike", Nike_AirJordan$Brand)    

TotalSales <- fread("/Users/nehachanu/Desktop/WebScrapingProject/TotalSales_StockX.csv", stringsAsFactors = F)
TotalSales <- as.data.frame(TotalSales)
TotalSales <- TotalSales %>% group_by(Brand) %>% filter(Brand == "Air Jordan"|Brand == "Adidas")  
TotalSales$Brand <- gsub("Air Jordan", "Nike", TotalSales$Brand)

########### Row bind data about Nike with Adidas ###########

Sneakers = rbind(Adidas_Yeezy, Nike_AirJordan)

########### Dates ###########

Sneakers$Release_Date = mdy(Sneakers$Release_Date)

Sneakers$Date_of_Sale =  as.Date(Sneakers$Date_of_Sale, format = "%A, %B %d, %Y")

Sneakers$Weekdays_of_Sale = weekdays(Sneakers$Date_of_Sale)

##Overall Sales: 
  
#1a. Which brand sold the most pair of sneakers? 

OverallSalesPerBrand = TotalSales %>% group_by(Brand) %>% summarise(SumTS= sum(Total_Sales))
OverallSalesPerBrand

OverallSalesPerBrand_plot = ggplot(OverallSalesPerBrand, aes(x =Brand, y = as.numeric(SumTS), fill = Brand)) + 
  geom_bar(stat = "identity") + 
  labs(x = 'Brand (Adidas Yeezy vs. Nike Air Jordan)', y = 'Total Sales', title = "Overall Sales on StockX of Top 35 Sneakers") + 
  theme(plot.title = element_text(hjust = 0.5))

OverallSalesPerBrand_plot

#1b.  Distribution of total sales by sneaker and brand? Do cetain sneakers sell more? 

OverallSalesPerSneaker = TotalSales %>% group_by(Brand, Model) %>% summarise(Sales= sum(Total_Sales))

OverallSalesPerSneaker_plot = ggplot(OverallSalesPerSneaker, aes(x = Model, y = Sales, fill = Brand)) + 
  geom_bar(stat = "identity") + 
  facet_grid(. ~Brand) +
  theme(strip.text.y = element_text(angle = 0)) +
  labs(x = 'Brand (Adidas Yeezy vs. Nike Air Jordan)', y = 'Total Sales', title = "Overall Sales of Each Sneaker") + 
  theme(plot.title = element_text(hjust = 0.5))

OverallSalesPerSneaker_plot = ggplotly(OverallSalesPerSneaker_plot)

OverallSalesPerSneaker_plot


#OverallSales_Arranged_Date_of_Sale = dplyr::arrange(Sneakers, Date_of_Sale)

#Price Analysis: 
  
  #EDA
#2a. Graph for different brands. Model_name vs average price
#Price vs total sales for each (graph with different lines for each model with legend)
  

##Differentiating Factor(s):

  #Price

Sneakers$Retail_Price = gsub("\\$", "", Sneakers$Retail_Price)
Sneakers$Retail_Price = gsub(",", "", Sneakers$Retail_Price)
Sneakers$Retail_Price = as.numeric(Sneakers$Retail_Price)

Sneakers$Avg_Sale_Price = gsub("\\$", "", Sneakers$Avg_Sale_Price)
Sneakers$Avg_Sale_Price = gsub(",", "", Sneakers$Avg_Sale_Price)
Sneakers$Avg_Sale_Price = as.numeric(Sneakers$Avg_Sale_Price)

Sneakers$Sale_Price = gsub("\\$", "", Sneakers$Sale_Price)
Sneakers$Sale_Price = gsub(",", "", Sneakers$Sale_Price)
Sneakers$Sale_Price = as.numeric(Sneakers$Sale_Price)

Sneakers$Price_Premium = gsub("\\%", "", Sneakers$Price_Premium)
Sneakers$Price_Premium = as.numeric(Sneakers$Price_Premium)


H = Sneakers %>% group_by(Brand) %>%
  summarise(AverageSalePrice=mean(Sale_Price), AveragePremiumPercent=mean(Price_Premium))
H

PriceComparisonPremium = ggplot(H, aes(Brand, AveragePremiumPercent)) +   
  geom_bar(aes(fill = Brand), position = "dodge", stat="identity") + 
  labs(x = 'Brand (Adidas Yeezy vs. Nike Air Jordan)', y = 'Average Sale Price') + 
  theme(plot.title = element_text(hjust = 0.5))


PriceComparisonPremium 

PriceComparisonSale = ggplot(H, aes(Brand, AverageSalePrice)) +   
  geom_bar(aes(fill = Brand), position = "dodge", stat="identity") +
  labs(x = 'Brand (Adidas Yeezy vs. Nike Air Jordan)', y = 'Average Premium Price') + 
  theme(plot.title = element_text(hjust = 0.5))

PriceComparisonSale

  #Sizes: Range of Sizes; 


  #Time: Are the prices so high for Yeezys because they are recent than Air Jordan's? Or is there a steady rate?

Sneakers$MonthYear_Sale= m(Sneakers$Date_of_Sale, "%b %Y")

Sneakers$MonthYear_Sale = as.factor()


#B =  Sneakers %>% group_by(Brand, Model) %>% summarise(ASale_Price= mean(Sale_Price)) %>% arrange(desc(ASale_Price))

All = Sneakers %>% group_by(Brand) %>% summarise(ASale_Price= mean(Sale_Price))

#top10resellPercent = top_n(top10resellPercent,10, avgResellPercentage)

# g17= ggplot(All, aes(x=Month_Sale, y=ASale_Price, group = Brand, color = Brand)) +
#   geom_line() + geom_point()+
#   ggtitle("Resell Price Over Time By Style") +
#   xlab("Date By Month")+
#   ylab("Average Resell Price($)")+
#   theme(axis.text.x =element_text(angle=45, hjust=1), plot.title = element_text(hjust = 0.5))
# g17
# 
# 
# #TimeSeries1 = Sneakers %>% group_by(Brand)
# 
# #TimeSeries1_graph = ggplot(Sneakers, aes(x = Date_of_Sale, y = mean(Sale_Price))) + geom_line() + labs(x = "TBD", y = "TBD")
# 
# #TimeSeries1_graph

