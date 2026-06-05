import os
import shutil
from typing import Tuple
import zipfile
import rarfile
import dagshub as dg
from dagshub.data_engine import datasources
from pathlib import Path

# from google.colab import files
import pandas as pd
from pandas import DataFrame
from datasets import load_dataset
from websockets import Data
from data.base import BaseLoader
import requests
import kagglehub


class LocalLoader(BaseLoader):
    def __init__(self, path: str):
        self.path = Path(path)

    def loader(self) -> DataFrame:
        suffix = self.path.suffix.lower()
        if suffix == ".csv":
            return pd.read_csv(self.path)
        elif suffix in [".xlsx", ".xls"]:
            return pd.read_excel(self.path)
        elif suffix == ".json":
            return pd.read_json(self.path)
        elif suffix == ".parquet":
            return pd.read_parquet(self.path)
        raise ValueError(f"Unsupported format {suffix}")


class ZipLoader(BaseLoader):
    def __init__(self, zip_path, extract_dir="temp"):
        self.zip_path = zip_path
        self.extract_dir = extract_dir

    def loader(self) -> DataFrame:
        with zipfile.ZipFile(self.zip_path, "r") as zip_ref:
            zip_ref.extractall(self.extract_dir)
            loader = LocalLoader(self.extract_dir).loader()
        return loader


class RarLoader(BaseLoader):
    def __init__(self, rar_path, extract_dir="temp"):
        self.rar_path = rar_path
        self.extract_dir = extract_dir

    def loader(self) -> DataFrame:
        with rarfile.RarFile(self.rar_path) as rf:
            rf.extractall(self.extract_dir)
            loader = LocalLoader(self.extract_dir).loader()
        return loader


# class GoogleDriveLoader(BaseLoader):
#     def __init__(self, mount_path="/content/drive/"):
#         self.mount_path = mount_path

#     def loader(self):
#         file = drive.mount(self.mount_path)
#         loader = LocalLoader(file).loader()
#         return loader


class GitHubLoader(BaseLoader):
    def __init__(self, raw_url):
        self.raw_url = raw_url

    def loader(self) -> DataFrame:
        return pd.read_csv(self.raw_url)


class KaggleLoader(BaseLoader):
    def __init__(self, dataset_name):
        self.dataset_name = dataset_name

    def loader(self):
        path = kagglehub.dataset_download(self.dataset_name)
        return path


class HuggingFaceLoader(BaseLoader):
    def __init__(self, dataset_name):
        self.dataset_name = dataset_name

    def loader(self):
        return load_dataset(self.dataset_name)


class URLLoader(BaseLoader):
    def __init__(self, url, save_path="downloaded_file"):
        self.url = url
        self.save_path = save_path

    def loader(self):
        r = requests.get(self.url, stream=True)
        with open(self.save_path, "wb") as f:
            for chunk in r.iter_content(8192):
                f.write(chunk)
        return self.save_path


# class DagsLoader(BaseLoader):
#     def __init__(
#         self,
#         repo_owner="user",
#         repo_name="repo_name",
#         dataset_name="dataset_name",
#         mlflow: bool = False,
#     ) -> None:
#         self.repo_owner = repo_owner
#         self.repo_name = repo_name
#         self.dataset_name = dataset_name
#         self.repo_path = f"{repo_owner}/{repo_name}"
#         self.mlflow = mlflow

#         dg.init(repo_owner=repo_owner, repo_name=repo_name, mlflow=mlflow)
#         self.loader()

#     def loader(self):
#         try:
#             return datasources.get(self.repo_path, self.dataset_name)
#         except ConnectionError as e:
#             raise ConnectionError(e)


class DataLoaderFactory:

    @staticmethod
    def create(source_type, **kwargs):

        loaders = {
            "local": LocalLoader,
            "zip": ZipLoader,
            "rar": RarLoader,
            "github": GitHubLoader,
            # "gdrive": GoogleDriveLoader,
            "huggingface": HuggingFaceLoader,
            "kaggle": KaggleLoader,
            # "dagshub": DagsLoader,
            "url": URLLoader,
        }

        return loaders[source_type](**kwargs)
