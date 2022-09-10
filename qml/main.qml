/******************************************************************************
 * main.qml
 *
 * Stuart Miller
 * 2022
 *****************************************************************************/
import QtQuick 2.15

/* Qml imports */
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

/* Application imports */
import Networking 1.0
import "."

Window {
  minimumWidth: 300
  width: minimumWidth
  minimumHeight: 400
  height: minimumHeight
  visible: true
  title: qsTr("WiFi Connection")
  color: Theme.colorBackground
  Column {
    id: column
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: parent.width * 0.10
    spacing: 20
    Text {
      height: 50
      width: parent.width
      text: "WiFi Connection"
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      font.pixelSize: height * 0.50
      font.family: Theme.font
    }

    ComboBox {
      id: networkList
      width: parent.width
      height: 50
      model: ConnectionManager.networks
      delegate: networkDelegate
      currentIndex: -1
      onAccepted: connectButton.clicked()
      onCurrentIndexChanged: {
        passwordField.text = ConnectionManager.networks[currentIndex].password
      }
      contentItem: Text {
        leftPadding: height * 0.20
        text: networkList.currentIndex < 0
              ? "<Select a network>"
              : ConnectionManager.networks[networkList.currentIndex].name
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        font.family: Theme.font
      }
      background: Rectangle {
        border.color: networkList.pressed ? "#BDBDBD" : "#0066FF"
        border.width: networkList.visualFocus ? 2 : 1
      }
    }
    TextField {
      id: passwordField
      width: parent.width
      height: 50
      echoMode: TextInput.Password
      validator: RegularExpressionValidator { regularExpression: /^\D{1}\S{15,}$/ }
      onAccepted: connectButton.clicked()
      MouseArea {
        height: parent.height
        width: height
        anchors.right: parent.right
        onReleased: parent.echoMode =
                    ((parent.echoMode === TextInput.Password)
                     ? TextInput.Normal
                     : TextInput.Password)
        Icon {
          z: -1
          anchors.fill: parent
          anchors.margins: parent.height * 0.25
          color: parent.containsMouse || (passwordField.echoMode === TextInput.Normal)
                 ? Theme.colorText : Theme.colorInactive
          source: "qrc:/img/eye.png"
        }
      }
    }
    Item {
      height: 50
      width: parent.width
      Icon {
        height: parent.height
        width: height
        anchors.left: parent.left
        Layout.fillWidth: true
        source: "qrc:/img/user.png"
        color: {
          switch(ConnectionManager.state) {
          case ConnectionState.Success: return Theme.colorSuccess
          case ConnectionState.Failed: return Theme.colorFailed
          default: return Theme.colorUnknown
          }
        }
      }
      Button {
        id: connectButton
        text: "Connect"
        height: parent.height
        anchors.right: parent.right
        /* Seems we have to validate here too since the RegExpValidator
         * can't really check the length while typing */
        enabled: (passwordField.text.length >= 16) && (networkList.currentIndex >= 0)
        onClicked: ConnectionManager.connect(networkList.contentItem.text, passwordField.text)
      }
    }
  }
  Component {
    id: networkDelegate
    ItemDelegate {
      required property int index
      required property var modelData
      width: column.width
      height: networkList.height
      contentItem: Item {
        Text {
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.rightMargin: parent.height * 1.25
          height: parent.height * 0.66
          font.pixelSize: parent.height * 0.60
          fontSizeMode: Text.HorizontalFit
          font.family: Theme.font
          text: modelData.name
          elide: Text.ElideRight
          verticalAlignment: Text.AlignVCenter
        }
        Text {
          anchors.bottom: parent.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.rightMargin: parent.height
          height: parent.height * 0.33
          font.pixelSize: parent.height * 0.33
          fontSizeMode: Text.HorizontalFit
          font.family: Theme.font
          text: modelData.message
          elide: Text.ElideRight
          verticalAlignment: Text.AlignVCenter
        }
        Icon {
          anchors.right: parent.right
          height: parent.height
          width: height
          source: "qrc:/img/wifi_%1.png".arg(modelData.strength)
        }
      }
      highlighted: networkList.highlightedIndex === index
    }
  }
}
