import os
import re
import itertools
import install.utils
"""representation of i3blocks config"""

class i3blocks_config_generator:

    def __init__(self, settings, template_file):
        self.blocks = dict()
        self.order_of_blocks = settings["list_of_blocks"]
        self.colors = settings["colors"]

        # parse file to blocks
        with open(template_file, 'r') as file:
            body = ""
            header = ""
            for line in file:
                head_of_section = re.match('\[.*\]', line)
                if head_of_section:
                    if header:
                        self.blocks[header] = body
                        body = ""
                    header = head_of_section.group()[1:-1]
                    continue
                body += line
            self.blocks[header] = body
        #

    def create_config_file(self, file):

        # create cycle colors
        color1 = self.colors["background1"]
        color2 = self.colors["background2"]
        cycle_of_colors = itertools.cycle((
            ( "color=" + color1 + '\n', "background=" + color2 + '\n'),
            ( "color=" + color2 + '\n', "background=" + color1 + '\n'),
        ))

        # repeating blocks
        separator = ("[separator]\n", self.blocks["separator"])
        placeholder = ("[placeholder]\n", self.blocks["placeholder"])

        # create colors
        color, background = next(cycle_of_colors)
        label_color = "color=" + self.colors["label"] + '\n'

        # generate config
        text = self.blocks['settings']
        for block_name in self.order_of_blocks:

            # add separator
            text += separator[0] # header
            text += background
            text += color
            text += separator[1] # body

            color, background = next(cycle_of_colors)

            # add placeholer
            text += placeholder[0] # header
            text += background
            text += placeholder[1] #  body

            # add block label if exist
            label_name = block_name + " label" 
            if label_name in self.blocks:
                text += '['+label_name+']\n'
                text += label_color
                text += background
                text += "interval=-1\n"
                text += "align=center\n"
                text += "min_width=20\n"
                text += self.blocks[label_name]

            # add block body
            text += '['+block_name+']\n'
            text += background
            text += "align=center\n"
            text += self.blocks[block_name]

        # add placeholer after all
        text += placeholder[0] # header
        text += background
        text += placeholder[1] #  body

        # create config instance
        if os.path.isfile(file):
            os.remove(file)
        with open(file, 'w') as file:
            file.write(text)

        return

