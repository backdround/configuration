import os


def create_symlink(file, symlink_file, force = False):
    file = os.path.abspath(file)
    symlink_file = os.path.abspath(os.path.expanduser(symlink_file))

    if not os.path.isfile(file):
        raise ValueError('{} is not a file'.format(file))

    destination_dir = os.path.dirname(symlink_file)
    os.makedirs(destination_dir, mode = 0o755, exist_ok = True)


    if os.path.isfile(symlink_file):
        if force or os.path.islink(symlink_file):
            os.remove(symlink_file)
        else:
            print("file {} is exist".format(symlink_file))
            return 0

    os.symlink(file, symlink_file)
    return 1

