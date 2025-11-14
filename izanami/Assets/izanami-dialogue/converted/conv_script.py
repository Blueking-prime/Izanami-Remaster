import os
from ultra_script import convert

DIR = input("Paste file name fn: ")
NAMES: list = DIR.split("/")
NEW_DIR = NAMES[0] + "-conv"

try:
    os.mkdir("converted/" + NEW_DIR)
    print(f"Directory created successfully.")
except FileExistsError:
    print(f"Directory already exists.")
except PermissionError:
    print(f"Permission denied: Unable to create directory.")
except Exception as e:
    print(f"An error occurred: {e}")

for name in os.listdir(DIR):
    convert(os.path.join(DIR,name), NEW_DIR)

