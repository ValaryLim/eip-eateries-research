import os
import time
import pandas as pd
import requests
from bs4 import BeautifulSoup
from selenium.webdriver import Chrome
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.select import Select

def load_url(url, chromedriver_path):
    ''' 
    Loads html of any url in burpple and returns BeautifulSoup object
    ''' 
    chrome_options = Options()  
    chrome_options.add_argument("--headless") # Opens the browser up in background

    with Chrome(chromedriver_path, options=chrome_options) as browser:
        browser.get(url)
        html = browser.page_source
    
    soup = BeautifulSoup(html, "html.parser")
    return soup

def compile_csv(dir):
    # retrieve all files
    files = os.listdir(dir)
    
    # instantiate dataframe
    combined_df = pd.DataFrame()
    
    # append dataframes
    for file in files:
        combined_df = combined_df.append(pd.read_csv(dir + file))
    
    # drop duplicates
    combined_df = combined_df.drop_duplicates()
    
    return combined_df