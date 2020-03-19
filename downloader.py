import mlflow.tracking
import os

client = mlflow.tracking.MlflowClient(tracking_uri=os.getenv('MLFLOW_TRACKING_URI'))
experiment = client.get_experiment_by_name(os.getenv('MODEL_NAME'))
run_ids = [run.run_id for run in client.list_run_infos(experiment_id=experiment.experiment_id)]
run_accuracy_pairs = [(run_id, client.get_metric_history(run_id, "accuracy")[0].value) for run_id in run_ids]
run_accuracy_pairs.sort(key=lambda x: x[1], reverse=True)
best_run_id = run_accuracy_pairs[0][0]
best_run = client.get_run(best_run_id)
artifact_path = client.download_artifacts(best_run_id, "")
print(artifact_path)