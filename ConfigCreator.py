# Config Creator
# Made by Sheights
# Instructions:
# Just put this in the mod directory
# /Starbound/giraffe_storage/mod/Starbound Simple Vore
# Then run it

import os
import json

patch = open("player.config.patch", "w")
mainDir = "./objects/vore"


def recurse(dir):
    storage = os.listdir(dir)
    for i in storage:
        if os.path.isdir(dir + '/' + i):
            recurse(dir + '/' + i)
        if i.endswith('.object'):
            write_entry(dir + '/' + i)


def write_entry(dir):
    with open(dir) as data_file:
        data = json.load(data_file)
    patch.write(
        ",\r\t{\"op\":\"add\",\"path\":\"/defaultBlueprints/tier1/-\",\"value\":{\"item\":\"" +
        data["objectName"] + "\"}}")


patch.write("[\r\t{\"op\":\"add\",\"path\":\"/defaultBlueprints/tier1/-\",\"value\":{\"item\":\"bellyBoundStore\"}}")

recurse(mainDir)

patch.write("\r]")

patch.close()
