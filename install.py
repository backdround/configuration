#!/bin/python
import os
import sys
import install.terminal
import install.settings


def help(modules):
    print('generate and install configs:\n')
    print('(home | note | work) - settings instance)')
    print('[-h | --help]        - show this help')
    print('[-f | --force]       - overwrite file if exist')
    print('all                  - use all modules\n')
    print(modules, '\n -')
    print('this modules are possible to process')
    print('you can use several at the same time')

def error_exit(error_string, modules):
    print("error was occured!!")
    print(error_string, "\n")
    help(modules)
    sys.exit(1)

def parse_args(args):
    all_modules = {
        'desktop',
        'terminal',
        'nvim',
        'qutebrowser',
        'misc',
    }

    ret_settings = {
        "force" : False,
        "modules" : set(),
        "settings" : ""
    }

    # parce cycle
    for arg in args:

        if arg  == '--force' or arg == '-f':
            ret_settings["force"] = True
        elif arg in all_modules:
            ret_settings["modules"].add(arg)
        elif arg == 'all':
            ret_settings["modules"] = all_modules
        elif arg == 'home':
            ret_settings["settings"] = install.settings.HomeSettings()
        elif arg == 'note':
            ret_settings["settings"] = install.settings.NoteSettings()
        elif arg == 'work':
            ret_settings["settings"] = install.settings.WorkSettings()
        elif arg == '--help' or arg == '-h':
            help(all_modules)
            sys.exit(0)
        else:
            error_exit("unknown arg: {}".format(args), all_modules)

    # correct check
    if not ret_settings["modules"]:
        error_exit("modules are requires", all_modules)
    if not ret_settings["settings"]:
        error_exit("settings are requires", all_modules)

    return ret_settings


if __name__ == '__main__':

    settings_dict = parse_args(sys.argv[1:])
    print("yours args:")
    print(settings_dict, "\n")

    project_root = os.path.abspath(os.path.dirname(__file__))

    #do install
    ret_val = 0
    for module in settings_dict["modules"]:
        print("install {}".format(module))

        args_to_install = "{settings}, {root}, {force}".format(
            settings = 'settings_dict["settings"]',
            root = "project_root",
            force = settings_dict["force"])

        to_eval = "install.{module}.main({args})".format(
            module = module,
            args = args_to_install)

        print(to_eval)
        if not eval(to_eval):
            ret_val = 1

    sys.exit(ret_val)
