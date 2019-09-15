import QtQml 2.13
import QtQuick 2.13
import QtQuick.Controls  2.13
import QtQuick.Window 2.13

Window {
  id: window
  visible: true
  flags: Qt.Window | Qt.Dialog | Qt.FramelessWindowHint
  color: "transparent"

  width: 0.8 * screen.width
  height: 0.7 * screen.height
  x: screen.virtualX + 0.5 * screen.width - 0.5 * width
  y: screen.virtualY + 0.1 * screen.height

  Rectangle {
    id: background
    color: "#AA444444"
    border.color: "#99CED6"
    border.width: 2
    width: parent.width
    height: 0

    states: [
      State {
        name: "init"
        PropertyChanges { target: background; height: window.height }
      }
    ]
    transitions: [
      Transition {
        to: "init"
        NumberAnimation {
          property: "height"
          easing.type: Easing.InOutQuad
        }
      }
    ]
  }

  Component.onCompleted: {
    onTriggered: background.state = "init"
  }
}
