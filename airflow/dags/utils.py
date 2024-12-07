import requests
import zipfile
import io
import pandas as pd

def download_zip(url):
    """Download a csv file from a URL."""
    try:
        response = requests.get(url)
        response.raise_for_status()  # Raise an HTTPError for bad responses
        return io.BytesIO(response.content)
    except requests.exceptions.RequestException as e:
        raise Exception(f"Failed to download the file from {url}. Error: {e}")

def extract_csv_from_zip(zip_content, delimiter=None):
    """Extract CSV data from a zip file and load it into a list of DataFrames."""
    dataframes = []
    with zipfile.ZipFile(zip_content) as zip_file:
        csv_files = [file_name for file_name in zip_file.namelist() if file_name.endswith(".csv")]
        
        if not csv_files:
            raise Exception("No CSV file found in the zip archive.")
        
        for file_name in csv_files:
            with zip_file.open(file_name) as csv_file:
                try:
                    df = pd.read_csv(csv_file, delimiter=delimiter or '|')
                    dataframes.append(df)
                except pd.errors.ParserError as e:
                    raise Exception(f"Failed to parse {file_name}. Error: {e}")

    return dataframes

