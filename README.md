# Data Engineering Assessment

## info
This project uses dbt + postgres to create some insightful tables from raw data (csv's).
There is also an airflow component, which makes a call to the open-meteo api to integrate
weather data into the final reporting table. 

- open-meteo api: https://open-meteo.com/en/docs?hourly=temperature_2m,wind_speed_10m,relative_humidity_2m&time_mode=time_interval&start_date=2025-08-09&end_date=2025-11-23

## running the project
- python -m venv .venv
- source .venv/bin/activate
- pip install -r requirements.txt
- navigate to cat_corp dir
- dbt init
- dbt seed
- dbt run
- dbt test

## optional: integrate weather data using airflow 
Please note, airflow has a seperate venv because the dependencies conflict with the rest of the project.

- navigate to airflow dir 
- python -m venv .venv
- source .venv/bin/activate
- pip install -r requirements.txt
- export AIRFLOW_HOME=$(pwd)
- airflow db init
- airflow-standalone

api-data from the dag is stored in outlet_weather_data.csv, and an example from a previous dag run is currently stored in the seeds dir for convenience.
