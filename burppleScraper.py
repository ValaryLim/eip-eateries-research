import os
import utils
import requests
import numpy as np
import pandas as pd

RESTAURANT_OFFSET_INCREMENT = 12
CHROMEDRIVER_LOCATION = "./utils/chromedriver"

def scrape_neighbourhoods():
    # retrieve html
    neighbourhood_url = "https://www.burpple.com/neighbourhoods/sg"
    neighbourhood_soup = utils.load_url(neighbourhood_url, CHROMEDRIVER_LOCATION)

    # retrieve list of neighbourhoods
    neighbourhood_refs = []
    for neighbourhood in neighbourhood_soup.findAll("a", {"class": "a--grey"}):
        neighbourhood_refs.append(neighbourhood["href"].split("/")[-1])
    
    return neighbourhood_refs

def scrape_restaurants_by_neighbourhood(neighbourhood):
    '''
    takes in a neighbourhood term and returns dataframe of all restaurants in the neighbourhood
    '''
    # create query
    offset = 0
    
    ids, names, terms, location, latitude, longitude, price, categories = [], [], [], [], [], [], [], []

    while True:
        # construct restaurant url
        params = {"offset":offset, "open_now":"false", "price_from":0, "price_to":1000, "q":neighbourhood}
        url = requests.get("https://www.burpple.com/search/sg", params=params).url
        
        # retrieve html
        soup = utils.load_url(url, CHROMEDRIVER_LOCATION)
        
        # retrieve venues
        venues = soup.findAll("div", {"class": "searchVenue card feed-item"})
        
        if len(venues) == 0: # stop scraping once there are no more venues
            break
            
        for venue in venues:
            try: 
                # basic requirements to scrape
                rid = int(venue.find("button", {"class": "btn--wishBtn"})["data-venue-id"])
                name = venue.find("button", {"class": "btn--wishBtn"})["data-venue-name"]
                term = venue.find("a")["href"].split("/")[1].split("?")[0]
                
                # all scrappable, add to list
                ids.append(rid)
                names.append(name)
                terms.append(term)
            except: 
                # does not meet basic requirements, do not scrape restaurant
                continue
            
            # optional items
            try: 
                location.append(venue.find("span", {"class": "searchVenue-header-locationDistancePrice-location"}).text)
            except:
                location.append("") # filler
            
            try:
                lat = float(venue.find("span", {"class": "searchVenue-header-locationDistancePrice-distance"})["data-latitude"])
                long = float(venue.find("span", {"class": "searchVenue-header-locationDistancePrice-distance"})["data-longitude"])
                latitude.append(lat)
                longitude.append(long)
            except:
                latitute.append(None)
                longitude.append(None)
            
            try:
                price.append(int(venue.find("span", {"class": "searchVenue-header-locationDistancePrice-price"}).text.split("$")[1].split("/")[0]))
            except:
                price.append(None)
                
            try:
                categories.append(venue.find("span", {"class": "searchVenue-header-categories"}).text.split(", "))
            except:
                categories.append([])
        
        offset += RESTAURANT_OFFSET_INCREMENT
    
    # combine to dataframe
    restaurant_df = pd.DataFrame({
        'id': ids,
        'name': names,
        'term': terms,
        'location': location,
        'lat': latitude,
        'long': longitude,
        'price_per_pax': price,
        'categories': categories
    })
    
    return restaurant_df

def generate_restaurants(restaurant_list_dir):
    # retrieve neighbourhoods
    neighbourhoods = scrape_neighbourhoods()

    # format neighbourhoods 
    neighbourhoods_formatted = utils.format_search_terms(neighbourhoods)

    # retrieve and save restaurants to csv
    for n in neighbourhoods:
        # scrape restaurant
        restaurants_df = scrape_restaurants_by_neighbourhood(n) 

        # save restaurant
        n_path = restaurant_list_dir + n + ".csv"
        restaurants_df.to_csv(n_path, index=False)

if __name__ == "__main__":
    # instantiate directories
    RESTAURANT_LIST_DIR = "./data/restaurant_lists/"
    RESTAURANT_CSV = "./data/restaurant_all.csv"

    # generate restaurants
    generate_restaurants(restaurant_list_dir=RESTAURANT_LIST_DIR)
    # compile restaurants 
    combined_restaurants_df = utils.compile_csv(RESTAURANT_LIST_DIR)
    # save to csv
    combined_restaurants_df.to_csv(RESTAURANT_CSV, index=False)