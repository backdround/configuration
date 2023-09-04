#!/bin/sh

# Задание масштабирования.
if grep -q home ~/.instance; then
  export QT_AUTO_SCREEN_SCALE_FACTOR=1
  export QT_SCALE_FACTOR=1.5
fi

# Получение команды.
test -z "$1" && QUTE_COMMAND=":open --window" || QUTE_COMMAND=":open -t $1"

# Приведение к необходимому виду сообщения.
TEMPLATE_MESSAGE='{"args": ["%s"], "target_arg": null, "version": "1.0.4", "protocol_version": 1, "cwd": "%s"}'
MESSAGE=$(printf "$TEMPLATE_MESSAGE" "$QUTE_COMMAND" "`pwd`")

# FIXME:
# scroll is really sucks in PyQt6.
# the following workaround downgrades to PyQt5.
export QUTE_QT_WRAPPER=PyQt5

# Бинарник для запуска
QUTE_BIN="/usr/bin/qutebrowser"
# Сокет для взаимодействия с имеющимся инстансом.
IPC_SOCKET="${XDG_RUNTIME_DIR}/qutebrowser/ipc-$(echo -n "$USER" | md5sum | cut -d' ' -f1)"

# Передача сообщения в сокет
echo "$MESSAGE" | socat -lf /dev/null STDIN UNIX-CONNECT:"$IPC_SOCKET" || "$QUTE_BIN" "$@" &
