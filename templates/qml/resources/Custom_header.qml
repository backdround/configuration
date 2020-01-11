import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13

Pane {
  height: 50
  property alias text : header_label.text
  property alias pixelSize : header_label.font.pixelSize

  Material.theme: Material.Dark
  Material.background: Material.primary

  Label {
    id: header_label
    anchors.fill: parent
    text: "Header"
    font.pixelSize: 16

    horizontalAlignment: Label.AlignHCenter
    verticalAlignment: Label.AlignVCenter
  }
}
