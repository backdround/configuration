#!/bin/bash
# Create and open test project.

# ./script TEST_TYPE TEST_NAME

set -e

error() {
	echo -e "\e[1m\e[31m$@\e[0m" >&2
  exit 1
}

# Get arguments.
TEST_TYPE="$1"
TEST_NAME="$2"

if [ -z "$TEST_TYPE" ]; then
  error "Test type is required!"
fi

if [ -z "$TEST_NAME" ]; then
  error "Project name is required!"
fi

# Get template path.
TEMPLATES_DIRECTORY="$(dirname $(readlink -f $0))"
TEMPLATE_PATH=$(realpath "$TEMPLATES_DIRECTORY/$TEST_TYPE")

if [ ! -d "$TEMPLATE_PATH" ]; then
  error "Required template with specefied type doesn't exsist:\n$TEMPLATE_PATH"
fi

# Get test path.
TEST_PATH="$(realpath ~/other/test_projects/${TEST_TYPE}_${TEST_NAME})"

if [ -n "$OPEN_EXISTING_PROJECT" ]; then
  test ! -d "$TEST_PATH" && \
    error "Required project doesn't exist:\n$TEST_PATH"
else
  test -d "$TEST_PATH" && \
    error "Required project already exist:\n$TEST_PATH"
  cp -r "$TEMPLATE_PATH" "$TEST_PATH"
fi

# Choose test type-specific working file and directories.
CODE_PANE_DIRECTORY="$TEST_PATH"
SHELL_PANE_DIRECTORY="$TEST_PATH"
case $TEST_TYPE in
  "qt")
    SHELL_PANE_DIRECTORY="$TEST_PATH/build"
    CODE_FILE="src/main.cpp"
    ;;
  "cpp")
    SHELL_PANE_DIRECTORY="$TEST_PATH/build"
    CODE_FILE="src/main.cpp"
    ;;
  "html")
    CODE_FILE="index.html"
    ;;
  "qml")
    CODE_FILE="resources/main.qml"
    ;;
  "node")
    CODE_FILE="index.js"
    ;;
  "lerna")
    CODE_FILE="index.js"
    ;;
  "bash")
    CODE_FILE="script.sh"
    ;;
  *)
    error "Template settings not setted!"
esac

# Open template project.
TMUX_SESSION_NAME="${TEST_TYPE}_${PROJECT_NAME}"

"$TEMPLATES_DIRECTORY/open_tmux_environment.sh" \
  "$TMUX_SESSION_NAME" \
  "$CODE_PANE_DIRECTORY" \
  "$SHELL_PANE_DIRECTORY" \
  "$CODE_FILE"
