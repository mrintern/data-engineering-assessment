# airflow
### this folder has its own venv because airflows dependencies and dbt dont play nice together

- source .venv/bin/activate
- pip install -r requirements.txt
- export AIRFLOW_HOME=$(pwd)
- airflow db init

to run server
- airflow standalone

- if the airflow ui isnt popping up, check that port 8080 is free
- lsof -i :8080
- kill -9 PID_GOES_HERE      
