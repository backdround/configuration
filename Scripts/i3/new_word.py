#!/bin/python
import sys
import os

text = sys.stdin.readline().rstrip("\n")
translated_text = os.popen("trans :ru -b '{}'".format(text)).read().rstrip("\n")
if not translated_text:
    sys.exit(1)
formated_text = "{:<30}{}".format(text, translated_text)
os.system("echo \"{}\" >> ~/other/eng/words/unknown".format(formated_text))
print(translated_text)
