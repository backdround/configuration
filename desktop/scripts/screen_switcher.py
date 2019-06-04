#!/bin/python
import subprocess
import json
from itertools import cycle

workspaces_info = json.loads(subprocess.getoutput("i3-msg -t get_workspaces"))
workspaces = [(i["num"], i["focused"]) for i in workspaces_info if i["visible"]]

# get next index
for i in workspaces:
    if i[1]:
        if i == workspaces[-1]:
            index = 0
        else:
            index = workspaces.index(i) + 1
        break

switch_command = "i3-msg workspace {}".format(workspaces[index][0])
print(workspaces)
print(switch_command)
subprocess.getoutput(switch_command)
