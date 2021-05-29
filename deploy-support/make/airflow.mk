airflow-restart:
	./deploy-support/airflow/kill_airflow.sh || echo "Airflow was not running"
	sleep 3s
	./deploy-support/airflow/start_airflow.sh
