from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

# Import the main function from your script
from weather_api_test import main

default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=1),
}

with DAG(
    dag_id="weather_api_test",       
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,          # Only run when triggered manually
    catchup=False,
    default_args=default_args,
    tags=["weather", "api"],
) as dag:

    run_weather_script = PythonOperator(
        task_id="run_weather_api_test",
        python_callable=main
    )

    run_weather_script
