/******************************************************************************
 * Theme.qml
 *
 * Stuart Miller
 * 2022
 *****************************************************************************/
pragma Singleton
import QtQuick 2.15

Item {

  property color colorBackground:     "#141414"
  property color colorText:           "#dbdbdb"
  property color colorEditBox:        "#3b3b3b"
  property color colorEditBoxHovered: "#737373"
  property color colorSelected:       "#0066FF"


  property color colorSuccess:        "#32a851"
  property color colorFailed:         "#a11702"
  property color colorUnknown:        "#000000"
  property color colorInactive:       "#a1a1a1"

  property string font: "Arial"

}
