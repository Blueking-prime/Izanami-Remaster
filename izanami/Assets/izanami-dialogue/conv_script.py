import os
from ultra_script import convert

DIR = input("Paste file name fn: ")

for name in os.listdir(DIR):
    convert(os.path.join(DIR,name))

