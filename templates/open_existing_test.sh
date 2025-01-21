#!/bin/bash
# Selecte and open test project.

set -e

TESTS_ROOT="$(realpath ~/.tests)"

preview() {
  CODE_FILES="fd -tf --max-depth=2 '(main.cpp|main.c|main.s|main.qml|main.py|index.js|main.yml|main.go|Earthfile|Dockerfile|justfile|schema.cue|main.lua|script.nu)'"
  BAT_FUNCTION="bat --color=always \$($CODE_FILES $TESTS_ROOT/{})"
  LS_FUNCTION="ls --color=always -l $TESTS_ROOT/{}"
  echo "{ $LS_FUNCTION ; $BAT_FUNCTION }"
}

# List of test projects sorted by time.
TEST_PROJECTS=$(fd -td . $TESTS_ROOT --max-depth=1 | xargs ls -dt | tr " " "\n")
TEST_PROJECT_NAMES=$(echo "$TEST_PROJECTS" | xargs -i basename {})

# Select test project from list.
SELECTION=$(echo "$TEST_PROJECT_NAMES" | fzf --preview-window=right:65% --preview="$(preview)")

if [ -z "$SELECTION" ]; then
  echo "Selection is closed"
fi
echo "$SELECTION is selected"

# Get type and project name parts from path:
# TYPE_SOME_PROJECT_NAME
DIRECTORY_NAME=$(basename $(realpath $SELECTION))

TYPE=$(echo "$DIRECTORY_NAME" | grep --color=never -oe "^[^_]*")
TEST_NAME=$(echo "${DIRECTORY_NAME#${TYPE}_}")

# Open template.
export OPEN_EXISTING_PROJECT="1"
TEMPLATES_DIRECTORY="$(dirname $(readlink -f $0))"
"$TEMPLATES_DIRECTORY/open_test.sh" \
  "$TYPE" \
  "$TEST_NAME"
