import os
import fileinput


def _create_symlink(file, symlink_file, force = False):
    # check values
    if not os.path.isabs(file):
        raise ValueError(file," isn't absolute path")
    if not os.path.isabs(symlink_file):
        raise ValueError(symlink_file," isn't absolute path")
    if not (os.path.isfile(file) or os.path.isdir(file)):
        raise ValueError(file, " is not a file")

    # make nested dirs
    destination_dir = os.path.dirname(symlink_file)
    os.makedirs(destination_dir, mode = 0o755, exist_ok = True)

    # remove symlink or file/dir(force) if exist
    if os.path.isfile(symlink_file) or os.path.isdir(symlink_file):
        if os.path.islink(symlink_file):
            os.remove(symlink_file)
        elif force:
            if os.path.isfile(symlink_file):
                os.remove(symlink_file)
            elif os.path.isdir(symlink_file):
                os.rmdir(symlink_file)
        else:
            print("file {} is exist".format(symlink_file))
            return 0

    # create symlink
    os.symlink(file, symlink_file)
    return 1

def create_list_of_symlink(symlink_pairs, config_prefix, symlink_prefix, force = False):
    make_absolute_path(symlink_pairs, config_prefix, symlink_prefix)
    ret_val = True
    for config, symlink in symlink_pairs:
        if _create_symlink(config, symlink, force):
            print("{}: symlink was succesfully created".format(config))
        else:
            print("{}: symlink wasn't created".format(config))
            ret_val = False

    return ret_val

def create_symlink(file, symlink, force = False):
    if _create_symlink(file, symlink, force):
        print("{}: symlink was succesfully created".format(symlink))
        return True
    else:
        print("{}: symlink wasn't created".format(symlink))
        return False

def make_absolute_path(pairs, config_prefix, symlink_prefix):
    config_prefix = os.path.abspath(config_prefix)
    symlink_prefix = os.path.abspath(symlink_prefix)

    for pair in pairs:
        pair[0] = os.path.join(config_prefix, pair[0])
        pair[1] = os.path.join(symlink_prefix, pair[1])

def replace_in_file(file, replace_pairs):
    for line in fileinput.FileInput(file, inplace=1):
        for old, new in replace_pairs:
            line = line.replace(old, new)
        print(line, end='')

def create_pairs_from_dir(path_to_files):
    # get list of files in directory
    files = [file for file in os.listdir(path_to_files)
             if os.path.isfile(os.path.join(path_to_files, file))]

    pairs = [[file, file] for file in files]

    return pairs
