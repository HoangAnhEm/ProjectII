import json

def read_file(file_path):
    with open(file_path, "r", encoding="utf-8") as f:
        return f.read()

def write_to_json(file_path, data):
    with open(file_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
