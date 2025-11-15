# airflow
### this folder has its own venv because airflows dependencies and dbt dont play nice together

- source .venv/bin/activate
- pip install -r requirements.txt
- export AIRFLOW_HOME=$(pwd)
- airflow db init

to run server
- airflow standalone
