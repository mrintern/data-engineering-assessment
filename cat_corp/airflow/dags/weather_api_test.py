import openmeteo_requests

import pandas as pd
import requests_cache
from retry_requests import retry
from datetime import datetime


seeds_dir_path = "/Users/nicogreen/Desktop/dbt-test/splyce-project-folder/data-engineering-assessment/cat_corp/seeds/"


def get_outlet_list():
	df = pd.read_csv(f"{seeds_dir_path}/outlet.csv")
	df_small = df[["id", "latitude", "longitude"]]
	df_small = df_small.dropna(subset=["latitude", "longitude"])
	# Convert to list of lists
	return df_small.values.tolist()

def get_outlet_weather_df(outlet_id, outlet_lat, outlet_long):
	# Setup the Open-Meteo API client with cache and retry on error
	cache_session = requests_cache.CachedSession('.cache', expire_after = 3600)
	retry_session = retry(cache_session, retries = 5, backoff_factor = 0.2)
	openmeteo = openmeteo_requests.Client(session = retry_session)

	# Make sure all required weather variables are listed here
	# The order of variables in hourly or daily is important to assign them correctly below
	url = "https://api.open-meteo.com/v1/forecast"
	params = {
		"latitude": 40.833082,
		"longitude": -73.929168,
		"hourly": ["temperature_2m", "wind_speed_10m", "relative_humidity_2m"],
	}
	responses = openmeteo.weather_api(url, params=params)

	# Process first location. Add a for-loop for multiple locations or weather models
	response = responses[0]
	print(f"Coordinates: {response.Latitude()}°N {response.Longitude()}°E")
	print(f"Elevation: {response.Elevation()} m asl")
	print(f"Timezone difference to GMT+0: {response.UtcOffsetSeconds()}s")

	# Process hourly data. The order of variables needs to be the same as requested.
	hourly = response.Hourly()
	hourly_temperature_2m = hourly.Variables(0).ValuesAsNumpy()
	hourly_wind_speed_10m = hourly.Variables(1).ValuesAsNumpy()
	hourly_relative_humidity_2m = hourly.Variables(2).ValuesAsNumpy()

	hourly_data = {"date": pd.date_range(
		start = pd.to_datetime(hourly.Time(), unit = "s", utc = True),
		end =  pd.to_datetime(hourly.TimeEnd(), unit = "s", utc = True),
		freq = pd.Timedelta(seconds = hourly.Interval()),
		inclusive = "left"
	)}

	hourly_data["temperature_2m"] = hourly_temperature_2m
	hourly_data["wind_speed_10m"] = hourly_wind_speed_10m
	hourly_data["relative_humidity_2m"] = hourly_relative_humidity_2m

	hourly_dataframe = pd.DataFrame(data = hourly_data)

	# add in lat and long
	hourly_dataframe["latitude"] = outlet_lat
	hourly_dataframe["longitude"] = outlet_long
	hourly_dataframe["outlet_id"] = outlet_id
	
	return hourly_dataframe


def main():
	outlet_list = get_outlet_list()
	# grab first outlet to initialize combined_df
	combined_df = get_outlet_weather_df(outlet_id=outlet_list[0][0], outlet_lat=outlet_list[0][1], outlet_long=outlet_list[0][2])
	# loop through remaining outlets and append to combined_df
	for outlet in outlet_list[1:]:	
		print(f"Processing outlet ID {outlet[0]} at lat {outlet[1]}, long {outlet[2]}")
		outlet_df = get_outlet_weather_df(outlet_id=outlet[0], outlet_lat=outlet[1], outlet_long=outlet[2])
		combined_df = pd.concat([outlet_df, combined_df], ignore_index=True)
	
	timestamp = datetime.now().strftime("%Y%m%d")
	output_path = f"{seeds_dir_path}/outlet_weather_data_{timestamp}.csv"
	print(f"Saving CSV to: {output_path}")
	combined_df.to_csv(output_path, index=False)

main()