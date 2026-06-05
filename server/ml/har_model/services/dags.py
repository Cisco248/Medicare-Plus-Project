import dagshub as dg
from dagshub.data_engine import datasources


# %pip install -q dagshub
# 'Cisco248'
# 'Medicare-Plus-Project'
class DagsController:
    def __init__(self, repo_owner: str, repo_name: str, mlflow: bool = False) -> None:
        self.repo_owner = repo_owner
        self.repo_name = repo_name
        self.repo_path = f"{repo_owner}/{repo_name}"
        self.mlflow = mlflow

        dg.init(repo_owner=repo_owner, repo_name=repo_name, mlflow=mlflow)

    def upload_dags_files(self, dir_name: str) -> None:
        dg.upload_files(self.repo_path, dir_name)

    def create_datasource(self, datasource_name: str, data_path: str = "data"):
        return datasources.create_datasource(self.repo_path, datasource_name, data_path)
