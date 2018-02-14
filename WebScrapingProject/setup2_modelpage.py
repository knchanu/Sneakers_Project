#####Created a folder on my Desktop called, "WebScrapingProject"
#####Opened SublimeText, create a new file and it as 'setup2_modelpage.py'
#####Typed the following intructions: 


from selenium import webdriver
# 1st import: Allows you to launch/initiate a browser

from selenium.webdriver.common.by import By
#2nd import: Allows you to search for things using specific parameters.

from selenium.webdriver.support.ui import WebDriverWait
#3rd import: Allows you to wait for a page to load.

from selenium.webdriver.support import expected_conditions as EC
#4th import: Specify what you are looking for on a specific page in order to determine that the webpage has loaded.

from selenium.common.exceptions import TimeoutException
#5th import: Handling a timeout situation.

import time
import csv
import re

option = webdriver.ChromeOptions()
option.add_argument('-incognito')
#Creates a new instance of Chrome in Incognito mode: First we start by adding the incognito argument to our webdriver.

driver = webdriver.Chrome(chrome_options=option)
#Initializes a Chrome Browser or creates a new instance of Chrome.

driver.get("https://stockx.com/air-jordan-1-retro-black-blue-2017")
#Make The Request: Pass in the desired website url of the website to be scraped


#####Open command line. Type the following
#Go the folder "WebScrapingProject" where you have 'setup.py' saved then type:
#       python setup2_modelpage.py

#####Typed the following: 

csv_file = open('AirJordan_Ones_Model.csv', 'w')
writer = csv.writer(csv_file)
#Creates a .csv file in the folder where this file is saved in "write" mode.

#####{ BASIC INFO ABOUT SNEAKER }#####

try: 

	Model_name = driver.find_element_by_xpath('//h1[@class="name"]').text
	#Retrieves the name of the Model
	print(Model_name)
	print('='*50)

	Color_Sneaker = driver.find_element_by_xpath('//div[@class="detail"][2]/span').text
	#Retrieves the color of the sneaker
	print(Color_Sneaker)
	print('='*50)

	Retail_Price = driver.find_element_by_xpath('//div[@class="detail"][3]/span').text
	#Retrieves the release date of the model
	print(Retail_Price)
	print('='*50)

	Release_date = driver.find_element_by_xpath('//div[@class="detail"][4]/span').text
	#Retrieves the release date of the model
	print(Release_date)
	print('='*50)


#####{ OTHER PRICE INFO ABOUT SNEAKER }#####

	OtherPriceInfo = driver.find_elements_by_xpath('//div[@class="gauges"]')

	for Each_Price_Info in OtherPriceInfo:

		OtherPriceInfo_dict = {}

		Price_Premium = Each_Price_Info.find_element_by_xpath('.//div[@class="gauge-container"][2]//div[@class="gauge-value"]').text
		print(Price_Premium)
		print('='*50)

		Avg_Sale_Price = Each_Price_Info.find_element_by_xpath('.//div[@class="gauge-container"][3]//div[@class="gauge-value"]').text


#####{ SALES HISTORY OF SNEAKER }#####

	driver.find_element_by_xpath('//div[@class="last-sale-block"]//a').click()
	#Clicks the button, "View All Sales" 

	time.sleep(3)
	#Wait time of 3 seconds before the following lines of code are executed

	try:
		button = driver.find_element_by_xpath('//div[@class="modal-content"]//button[@class="btn"]')
		if button.text == "OKAY, I UNDERSTAND":
			button.click()
	except:
		pass
	#Clicks the button, "OKAY, I UNDERSTAND"


	Sales_History = driver.find_elements_by_xpath('//table[@class="activity-table table table-condensed table-striped "]/tbody//tr')
	
	for Each_Sales_History in Sales_History: 

		SalesHistory_dict = {}

		Date_of_Sale = Each_Sales_History.find_element_by_xpath('./td[1]').text
		#Retrieves the date of each sale
		print(Date_of_Sale)
		print('='*50)

		Time_of_Sale = Each_Sales_History.find_element_by_xpath('./td[2]').text
		#Retrieves the time of each sale 
		print(Time_of_Sale)
		print('='*50)

		Size_Sneaker = Each_Sales_History.find_element_by_xpath('./td[3]').text
		#Retrieves the size of each sneaker sold
		print(Size_Sneaker)
		print('='*50)

		Sale_Price = Each_Sales_History.find_element_by_xpath('./td[4]').text
		#retrieves the price of each sneaker sold
		print(Sale_Price)
		print('='*50)



except Exception as e: 
	print(e)
	# driver.close()
