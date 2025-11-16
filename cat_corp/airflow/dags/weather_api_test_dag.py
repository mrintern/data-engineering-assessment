from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=3),
}

with DAG(
    dag_id="weather_api_test",    
    start_date=datetime(2024, 1, 1),
    schedule_interval="59 23 * * *",   # daily at 11:59 PM     
    catchup=False,
    default_args=default_args,
    tags=["weather", "api"],
) as dag:

    run_weather_script = BashOperator(
        task_id="run_weather_api_test",
        bash_command="python /Users/nicogreen/Desktop/dbt-test/splyce-project-folder/data-engineering-assessment/cat_corp/airflow/dags/weather_api_test.py" # relative path would be better
    )

    run_weather_script
