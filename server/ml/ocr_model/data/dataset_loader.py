import os
from pathlib import Path
from typing import List
import zipfile


class Dataset_Loader:
    def __init__(self) -> None:
        self.required_dirs = ["Training_Data", "Testing_Data", "Validation_Data"]

    def verify_root(self, root: str | Path) -> str:
        try:
            if not os.path.isfile(root):
                return "File doesn't exists!"
            os.makedirs(root, exist_ok=True)
            return "File created in root!"
        except Exception as e:
            return str(RuntimeError(f"Failed to set up Google Drive: {e}"))

    def extract_file(
        self,
        file_path: str | Path,
        extract_path: str | Path,
    ) -> str:
        try:
            if not os.path.isfile(file_path):
                return f"Error: File_Path must be a not found"
            if not str(file_path).endswith(".zip"):
                return f".zip file not found!"

            with zipfile.ZipFile(file_path, "r") as file:
                file.extractall(extract_path)
            for dir_name in self.required_dirs:
                path = os.path.join(extract_path, dir_name)
                if not os.path.isdir(path):
                    return f"Required directory not found after extraction: {path}"

            return "Dataset verified and extracted successfully."
        except zipfile.BadZipFile:
            return "Error: The file is not a valid zip file."
        except Exception as e:
            return f"An unexpected error occurred during extraction: {e}"

    def verify_csv(
        self,
        file_dir: str | Path,
        extensions: set = {".csv"},
    ) -> List[Path]:
        raw = Path(file_dir)
        if not raw.exists():
            raise FileNotFoundError(f"Directory '{file_dir}' does not exist.")
        files = []

        for ext in extensions:
            files.extend(raw.rglob(f"*{ext}"))

        csv_files = [file for file in files]
        print(f"CSV Files > {len(csv_files)}")
        return csv_files

    def verify_img(
        self,
        file_dir: str | Path,
        extensions: set = {".png", ".jpg", ".jpeg"},
    ) -> List[Path]:
        raw = Path(file_dir)
        if not raw.exists():
            raise FileNotFoundError(f"Directory '{file_dir}' Does Not Exist.")

        image_files = [p for p in raw.rglob("*") if p.suffix.lower() in extensions]
        print(f"Image Files > {len(image_files)}")
        return image_files
