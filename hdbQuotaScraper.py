import pandas as pd
import utils
import config
from onemapsg import OneMapClient

# SET STANDARD VARIABLES
HDB_QUOTA_URL = "https://services2.hdb.gov.sg/webapp/BB29ETHN/BB29STREET"
CHROMEDRIVER_LOCATION = "./utils/chromedriver"
HDB_QUOTA_DATA_DIR = "./data/hdb_quotas/"

def retrieve_street_options(soup):
    street_dropdown = soup.find("select", id="street").findAll("option")
    street_options = []

    for address_option in street_dropdown:
        if len(address_option["value"]) > 0:
            street_options.append(address_option["value"])
    
    return street_options

def retrieve_hdb_quota_data(street_options, ethnicity_options):
    for street in street_options:
        successful_scrape = True
    
        all_block = []
        all_street = []
        all_ethnicity_quota = [[], [], []]
        
        for i in range(len(ethnicity_options)): 
            try:
                # create driver and go to link
                chrome_options = Options()  
                chrome_options.add_argument("--headless") 

                driver = Chrome(CHROMEDRIVER_LOCATION, options=chrome_options)
                driver.get(HDB_QUOTA_URL)

                # select buyer
                buyer_radio = driver.find_element_by_xpath("//input[@id='enqByBuyer']")
                driver.execute_script("arguments[0].click();", buyer_radio)

                # select street
                street_dropdown = Select(driver.find_element_by_id('street'))
                street_dropdown.select_by_value(street)

                # select blocks
                time.sleep(1)
                firstblk_dropdown = Select(driver.find_element_by_id('blockNoId'))
                firstblk_dropdown.select_by_index(1)
                lastblk_radio                               = driver.find_element_by_xpath("//input[@id='blockTo']")
                lastblk_radio.send_keys("99999")

                # select ethnicity
                ethnic_grp = ethnicity_options[i]
                ethnic_radio = driver.find_element_by_xpath("//input[@id=" + ethnic_grp + "]")
                driver.execute_script("arguments[0].click();", ethnic_radio)

                # select citizenship
                citizen_radio = driver.find_element_by_xpath("//input[@id='citizenSing']")
                citizen_radio.click()

                # pause and enter
                time.sleep(1)
                driver.find_element_by_xpath("//input[@id='btnProceed']").click()

                # scrape results
                time.sleep(3)
                html = driver.page_source
                soup = BeautifulSoup(html, "html.parser")
                quota_info = soup.findAll("tr")

                if len(quota_info) <= 1:
                    driver.quit()
                    break

                for row in quota_info[1:]:
                    row_info = row.findAll("td")
                    blk_num = row_info[0].text
                    io_text = row_info[1].text

                    if io_text == "You can buy from any flat seller, regardless of their ethnic group and citizenship.":
                        all_ethnicity_quota[i].append(0)
                    else:
                        all_ethnicity_quota[i].append(1)

                    if i == 0: # add block and address
                        all_block.append(blk_num)
                        all_street.append(street)

                driver.quit()
            except:
                successful_scrape = False
                break
        
        if successful_scrape:
            try:
                street_df = pd.DataFrame({
                    "block": all_block,
                    "street": all_street,
                    "chinese_quota": all_ethnicity_quota[0],
                    "malay_quota": all_ethnicity_quota[1],
                    "indian_other_quota": all_ethnicity_quota[2]
                })

                # save to csv
                street_df.to_csv(HDB_QUOTA_DATA_DIR + "-".join(street.lower().split(" ")) + ".csv")
            except:
                if len(all_ethnicity_quota[0]) == 0:
                    all_ethnicity_quota[0] = [0] * len(all_block)
                if len(all_ethnicity_quota[1]) == 0:
                    all_ethnicity_quota[1] = [0] * len(all_block)
                if len(all_ethnicity_quota[2]) == 0:
                    all_ethnicity_quota[2] = [0] * len(all_block)
                
                street_df = pd.DataFrame({
                    "block": all_block,
                    "street": all_street,
                    "chinese_quota": all_ethnicity_quota[0],
                    "malay_quota": all_ethnicity_quota[1],
                    "indian_other_quota": all_ethnicity_quota[2]
                })

                street_df.to_csv(HDB_QUOTA_DATA_DIR + "-".join(street.lower().split(" ")) + ".csv")
        else:
            print(street)

def retrieve_lat_long(hdb_quota_df):
    Client = OneMapClient(config.onemap["username"], config.onemap["password"])

    postal = []
    latitude = []
    longitude = []
    x = []
    y = []

    for ind, row in hdb_quota_df.iterrows():
        try:
            query = str(row["block"]) + " " + row["street"]
            
            # handle exceptions
            if "St. George's Rd" in query:
                query = str(row["block"]) + " St George Rd"
            if "St. George's Lane" in query:
                query = "St. George's Lane"
            
            results = Client.search(query)["results"][0]
            
            try:
                postal.append(int(results["POSTAL"]))
            except:
                postal.append(None)
            
            try:
                latitude.append(float(results["LATITUDE"]))
            except:
                latitude.append(None)
                
            try:
                longitude.append(float(results["LONGITUDE"]))
            except:
                longitude.append(None)
            
            try:
                x.append(float(results["X"]))
            except:
                x.append(None)
            
            try:
                y.append(float(results["Y"]))
            except:
                y.append(None)
        except:
            print(query)
            postal.append(None)
            latitude.append(None)
            longitude.append(None)
            x.append(None)
            y.append(None)
    
    # update dataframe
    hdb_quota_df["postal"] = postal
    hdb_quota_df["latitude"] = latitude
    hdb_quota_df["longitude"] = longitude
    hdb_quota_df["svy21_x"] = x
    hdb_quota_df["svy21_y"] = y

    return hdb_quota_df

if __name__ == "__main__":
    # generate options
    soup = utils.load_url(HDB_QUOTA_URL, CHROMEDRIVER_LOCATION)

    # retrieve options
    street_options = retrieve_street_options(soup=soup)
    ethnicity_options = ["'ethGroupChinese'", "'ethGroupMalay'", "'ethGroupInd'"]

    # scrape hdb quota data
    scrape_hdb_quota_data(street_options=street_options, ethnicity_options=ethnicity_options)

    # compile hdb quota data
    combined_hdb_quota_df = utils.compile_csv(HDB_QUOTA_DATA_DIR)
    combined_hdb_quota_df = combined_hdb_quota_df.drop(["Unnamed: 0"], axis=1)

    # retrieve postal, lat long of each address
    combined_hdb_quota_df = retrieve_lat_long(combined_hdb_quota_df)

    # compile to csv
    combined_hdb_quota_df.to_csv("./data/hdb_quotas_all.csv", index=False)