import os
import fileinput

class Deployer:
    def __init__(self, project_root, force):
        self.project_root = os.path.abspath(project_root)
        self.force        = force

    def _create_symlink(self, file, symlink_file):
        # check values
        if not os.path.isabs(file):
            raise ValueError(file," isn't absolute path")
        if not os.path.isabs(symlink_file):
            raise ValueError(symlink_file," isn't absolute path")
        if not (os.path.isfile(file) or os.path.isdir(file)):
            raise ValueError(file, " is not a file")

        # make nested dirs
        destination_directory = os.path.dirname(symlink_file)
        os.makedirs(destination_directory, mode = 0o755, exist_ok = True)

        # remove symlink if exist
        if os.path.islink(symlink_file):
            os.remove(symlink_file)
        elif self.force:
            if os.path.isfile(symlink_file):
                os.remove(symlink_file)
            elif os.path.isdir(symlink_file):
                os.rmdir(symlink_file)
        elif not self.force and os.path.exists(symlink_file):
            print("file {} is exist".format(symlink_file))
            return 0

        # create symlink
        os.symlink(file, symlink_file)
        return 1

    def create_list_of_symlink(self, symlink_pairs):
        # make absolute paths
        for pair in symlink_pairs:
            pair[0] = os.path.abspath(os.path.join(self.project_root, pair[0]))
            pair[1] = os.path.abspath(os.path.expanduser(pair[1]))

        # create symlinks
        for config, symlink in symlink_pairs:
            if self._create_symlink(config, symlink):
                print("{}: symlink was succesfully created".format(config))
            else:
                print("{}: symlink wasn't created".format(config))

    def symlink_all_files_in_dir(self, source_directory, destination_directory):
        source_directory = os.path.join(self.project_root, source_directory)
        source_directory = os.path.abspath(source_directory)
        destination_directory = os.path.expanduser(destination_directory)
        destination_directory = os.path.abspath(destination_directory)

        files = os.listdir(source_directory)

        pairs = []
        for file in files:
            src = os.path.join(source_directory, file)
            dest = os.path.join(destination_directory, file)
            pairs.append([src, dest])

        self.create_list_of_symlink(pairs)



def replace_in_file(file, replace_pairs):
    for line in fileinput.FileInput(file, inplace=1):
        for old, new in replace_pairs:
            line = line.replace(old, new)
        print(line, end='')

