/******************************************************************************
 * main.qml
 *
 * Stuart Miller
 * 2022
 *****************************************************************************/
import QtQuick 2.15

/* Qml imports */
import QtGraphicalEffects 1.12
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

    /******************************************************
     * Header text
     *****************************************************/
    Text {
      height: 50
      width: parent.width
      text: "WiFi Connection"
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      font.pixelSize: height * 0.50
      font.family: Theme.font
      color: Theme.colorText
    }

    /******************************************************
     * Network list popup
     *****************************************************/
    ComboBox {
      id: networkList
      width: parent.width
      height: 50
      model: ConnectionManager.networks
      currentIndex: -1
      onAccepted: connectButton.clicked()
      onCurrentIndexChanged: {
        passwordField.text = ConnectionManager.networks[currentIndex].password
      }
      /* Style components */
      delegate: ItemDelegate {
        id: networkDelegate
        required property int index
        required property var modelData
        width: column.width
        height: networkList.height
        background: Rectangle {
          color: networkDelegate.hovered ? Theme.colorEditBoxHovered : Theme.colorEditBox
        }
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
            color: Theme.colorText
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
            color: Theme.colorText
            text: modelData.message
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
          }
          Icon {
            anchors.right: parent.right
            height: parent.height
            width: height
            source: "qrc:/img/wifi_%1.png".arg(modelData.strength)
            color: Theme.colorText
          }
        }
        highlighted: networkList.highlightedIndex === index
      }
      contentItem: Text {
        leftPadding: height * 0.20
        text: networkList.currentIndex < 0
              ? "<Select a network>"
              : ConnectionManager.networks[networkList.currentIndex].name
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        font.family: Theme.font
        color: Theme.colorText
      }
      background: Rectangle {
        color: Theme.colorEditBox
        border.color: Theme.colorSelected
        border.width: networkList.focus ? 2 : 0
      }
      popup: Popup {
        id:comboPopup
        y: networkList.height - 1
        width: networkList.width
        height: contentItem.implicitHeight
        padding: 0
        contentItem: ListView {
          implicitHeight: contentHeight
          model: networkList.popup.visible ? networkList.delegateModel : null
          ScrollIndicator.vertical: ScrollIndicator { }
        }
        background: Rectangle {
          color: Theme.colorEditBox
        }
      }
    }

    /******************************************************
     * Password entry field
     *****************************************************/
    TextField {
      id: passwordField
      width: parent.width
      height: 50
      enabled: networkList.currentIndex >= 0
      echoMode: TextInput.Password
      validator: RegularExpressionValidator {
        /* 16 chars, first can't be a number */
        regularExpression: /^\D{1}\S{15,}$/
      }
      onAccepted: connectButton.clicked()
      color: Theme.colorText
      selectByMouse: true
      background: Rectangle {
        color: Theme.colorEditBox
        border.color: Theme.colorSelected
        border.width: passwordField.focus ? 2 : 0
      }
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
          opacity: (passwordField.echoMode === TextInput.Normal) ? 0.25 : 1.0
          color: Theme.colorText
          source: "qrc:/img/eye.png"
        }
      }
    }

    Item {
      height: 50
      width: parent.width

      /******************************************************
       * User/status icon
       *****************************************************/
      Icon {
        id: userIcon
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
      Glow {
        anchors.fill: userIcon
        radius: 3
        samples: 10
        color: Theme.colorText
        source: userIcon
      }

      /******************************************************
       * Connect button
       *****************************************************/
      Button {
        id: connectButton
        text: "Connect"
        height: parent.height
        width: 100
        anchors.right: parent.right
        /* Seems we have to validate here too since the RegExpValidator
         * can't really check the length while typing */
        enabled: (passwordField.text.length >= 16) && (networkList.currentIndex >= 0)
        onClicked: ConnectionManager.connect(networkList.contentItem.text, passwordField.text)
        contentItem: Text {
          text: connectButton.text
          font: Theme.font
          opacity: enabled ? 1.0 : 0.3
          color: Theme.colorText
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          elide: Text.ElideRight
        }
        background: Rectangle {
          opacity: enabled ? 1.0 : 0.3
          color: connectButton.down ? Theme.colorEditBoxHovered : Theme.colorEditBox
          border.color: Theme.colorSelected
          border.width: connectButton.focus ? 2 : 0
        }
      }
    }
  }
}
