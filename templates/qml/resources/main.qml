import QtQuick 2.13
import QtQuick.Window 2.13

Window {
  id: main_window
  width: 620
  height: 380
  visible: true
  //flags: Qt.FramelessWindowHint | Qt.X11BypassWindowManagerHint
  flags: Qt.FramelessWindowHint | Qt.Dialog
  color: "transparent"


  Rectangle {
    id: background
    anchors.fill: parent
    visible: true
    color: "#A4A4A4FF"
    border.color: "#D9CED6"
    border.width: 2
  }
}
