import openmeteo_requests

import pandas as pd
import requests_cache
from retry_requests import retry
from datetime import datetime


seeds_dir_path = "/Users/nicogreen/Desktop/dbt-test/splyce-project-folder/data-engineering-assessment/cat_corp/seeds/"


# grab some useful data to attach to our weather-api data
def get_outlet_list():
	df = pd.read_csv(f"{seeds_dir_path}/outlet.csv")
	df_small = df[["id", "latitude", "longitude"]]
	df_small = df_small.dropna(subset=["latitude", "longitude"])
	return df_small.values.tolist()

def get_outlet_weather_df(outlet_id, outlet_lat, outlet_long):
	cache_session = requests_cache.CachedSession('.cache', expire_after = 3600)
	retry_session = retry(cache_session, retries = 5, backoff_factor = 0.2)
	openmeteo = openmeteo_requests.Client(session = retry_session)

	url = "https://api.open-meteo.com/v1/forecast"
	params = {
		"latitude": 40.833082,
		"longitude": -73.929168,
		"hourly": ["temperature_2m", "wind_speed_10m", "relative_humidity_2m"],
	}
	responses = openmeteo.weather_api(url, params=params)
	response = responses[0]

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
	
	output_path = f"{seeds_dir_path}/outlet_weather_data.csv"
	print(f"Saving CSV to: {output_path}")
	combined_df.to_csv(output_path, index=False)

main()