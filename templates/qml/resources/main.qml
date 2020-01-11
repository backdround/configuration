import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13

Window {
  width: 620
  height: 380
  visible: true
  flags: Qt.FramelessWindowHint | Qt.Dialog

  Material.background: Material.color(Material.Grey, Material.Shade300)

  Pane {
    anchors.fill: parent
    Page {
      anchors.fill: parent
      Material.background: Material.color(Material.Grey, Material.Shade200)

      header: Custom_header {}
    }
  }
}
