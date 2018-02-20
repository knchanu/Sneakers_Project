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
library(plotrix)
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

########### Dates ##############

Sneakers$Release_Date = mdy(Sneakers$Release_Date)

Sneakers$Date_of_Sale =  as.Date(Sneakers$Date_of_Sale, format = "%A, %B %d, %Y")

Sneakers$Weekdays_of_Sale = weekdays(Sneakers$Date_of_Sale)

########### Overall Sales ########### 

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
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 2))


OverallSalesPerSneaker_plot = ggplotly(OverallSalesPerSneaker_plot)

OverallSalesPerSneaker_plot

########### Price Analysis ########### 

#2a. Graph for different brands. Model_name vs average price
#Price vs total sales for each (graph with different lines for each model with legend)

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


Mean_SalePrice_PricePremium = Sneakers %>% group_by(Brand) %>%
  summarise(AverageSalePrice=mean(Sale_Price), AveragePremiumPercent=mean(Price_Premium))
Mean_SalePrice_PricePremium

#Box Plot of Brand vs. Sale Price for both brands

ggplot(Sneakers, aes(x=Brand, y=Sale_Price, fill=Brand)) +
  geom_boxplot() + 
  labs(x='Brand', y = 'Sale Price', title = 'Box Plot of Sale Price by Brand') +
  theme(plot.title = element_text(hjust = 0.5))

#Bar chart of Brand vs. Average Sale 

PriceComparisonPremium = ggplot(H, aes(Brand, AveragePremiumPercent)) +   
  geom_bar(aes(fill = Brand), position = "dodge", stat="identity") + 
  labs(x = 'Brand (Adidas Yeezy vs. Nike Air Jordan)', y = 'Average Premium Price') + 
  theme(plot.title = element_text(hjust = 0.5))

PriceComparisonPremium 



PriceComparisonSale = ggplot(H, aes(Brand, AverageSalePrice)) +   
  geom_bar(aes(fill = Brand), position = "dodge", stat="identity") +
  labs(x = 'Brand (Adidas Yeezy vs. Nike Air Jordan)', y = 'Average Sale Price') + 
  theme(plot.title = element_text(hjust = 0.5))

PriceComparisonSale

########### Range of Sizes ########### 

Sizes_Nike = Sneakers %>% filter(Brand == 'Nike')
Unique_Sizes_Nike = unique(Sizes_Nike$Sneaker_Size)
Length_Sizes_Nike = length(Unique_Sizes_Nike)

Unique_Sizes_Nike
Length_Sizes_Nike

Sizes_Adidas = Sneakers %>% filter(Brand == 'Adidas')
Unique_Sizes_Adidas = unique(Sizes_Adidas$Sneaker_Size)
Length_Sizes_Adidas = length(Unique_Sizes_Adidas)     #offers 6 sizes for infants

Unique_Sizes_Adidas
Length_Sizes_Adidas

#but are the sales generated from these 6 sizes a significant contributor to the total sales? (piechart)

slices <- c(1918, 11783)  #1918 Infant Sneakers i.e roughly 16% of Total Sales    #11783 Adult Sneakers
lbls <- c("Infant","Adults")
PieChart = pie3D(slices,labels=lbls,main="Pie Chart of Total Sales: \n Infant vs. Adult Sneakers")

#Creates a new column called Month_Year

setDT(Sneakers)[, Month_Yr := format(as.Date(Date_of_Sale), "%Y-%m") ] 

Sneakers$DateTimeSale = as.POSIXct(paste(Sneakers$Date_of_Sale, Sneakers$Time_of_Sale), format="%Y-%m-%d %H:%M")

#Adidas - Comparison of price premium for each of the 35 top selling with the time they got introduced on the website

FilterSneakersAdidas = Sneakers %>% filter(Brand == "Adidas") %>% group_by(Model)

PP_Time_Adidas = ggplot(FilterSneakersAdidas, aes(x=DateTimeSale , y=Price_Premium, group = Model, color = Model)) +
  geom_line() + geom_point() + ggtitle("Price Premium Over Time By Model") +
  labs(x ="Year of Sales on StockX", y = "Price Premium %") +
  theme(axis.text.x =element_text(angle=45, hjust=1), plot.title = element_text(hjust = 0.5))

PP_Time_Adidas = ggplotly(PP_Time_Adidas)
PP_Time_Adidas

#Nike - Comparison of price premium for each of the 35 top selling with the time they got introduced on the website

FilterSneakersNike = Sneakers %>% filter(Brand == "Nike") %>% group_by(Model)

PP_Time_Nike = ggplot(FilterSneakersNike, aes(x=DateTimeSale , y=Price_Premium, group = Model, color = Model)) +
  geom_line() + geom_point() +
  ggtitle("Price Premium Over Time By Model") +
  xlab("Year of Sales on StockX")+
  ylab("Price Premium %")+
  theme(axis.text.x =element_text(angle=45, hjust=1), plot.title = element_text(hjust = 0.5))
PP_Time_Nike = ggplotly(PP_Time_Nike)

PP_Time_Nike


#-----------


### Additional EDA not included in presentation and blog post 

#Merge the two data frames, "Total Sales" and "Sneakers" by "Model"

Merged_df = merge(TotalSales, Sneakers, by = "Model")
Merged_df = subset(Merged_df, select = -Brand.x )
names(Merged_df)[names(Merged_df) == 'Brand.y'] = 'Brand'

#Group by brand, group by month, year, number of observation, mean of the those observations for that brand 

Avg_Sales_PerMonth = Merged_df %>% group_by(Brand, Month_Yr) %>% summarise(xcount = n()) 

Test_201702 = Avg_Sales_PerMonth %>% group_by(Brand) %>% filter(Month_Yr >= '2017-12') %>% summarise(X = sum(xcount))

Test = Avg_Sales_PerMonth %>% group_by(Brand) %>% summarise(M = mean(xcount)) 

testavg = ggplot(Avg_Sales_PerMonth, aes(x = Month_Yr, y = xcount, color = Brand)) + geom_point() + geom_path() + theme(axis.text.x = element_text(angle = 45, hjust = 1))

testavg = ggplotly(testavg)

testavg


