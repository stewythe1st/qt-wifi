/******************************************************************************
 * Icon.qml
 *
 * Stuart Miller
 * 2022
 *****************************************************************************/
import QtQuick 2.12

/* Qt imports */
import QtGraphicalEffects 1.0

Item {
  id: root
  property alias color: iconColor.color
  property alias source: iconImage.source
  property alias blinking: timer.running
  property alias period: timer.interval
  property bool hidden: false
  onBlinkingChanged: opacity = (hidden ? 0.0 : 1.0)
  onHiddenChanged: opacity = (hidden ? 0.0 : 1.0)
  opacity: hidden ? 0.0 : 1.0
  Image {
    id: iconImage
    anchors.fill: parent
    fillMode: Image.PreserveAspectFit
    visible: false
  }
  ColorOverlay {
    id: iconColor
    source: iconImage
    anchors.fill: iconImage
    color: "#000000"
  }
  Timer {
    id: timer
    repeat: true
    running: false
    onTriggered: root.opacity = (root.opacity === 1.0 ? 0.0 : 1.0)
  }
}
