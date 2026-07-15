import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets 
import Quickshell.Services.SystemTray 

ShellRoot {
    id: root

    // Gruvbox Color Palette
    readonly property color bg0: "#282828"
    readonly property color bg1: "#3c3836"
    readonly property color fg0: "#fbf1c7"
    readonly property color fg4: "#a89984"
    readonly property color red: "#fb4934"
    readonly property color green: "#b8bb26"
    readonly property color yellow: "#fabd2f"
    readonly property color blue: "#83a598"
    readonly property color aqua: "#8ec07c"
    readonly property color orange: "#fe8019"

    // Standardized NixOS family name
    readonly property string fontName: "JetBrainsMono Nerd Font"

    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: bar
            property var modelData
            screen: modelData
            
            anchors {
                bottom: true
                left: true
                right: true
            }
            
            implicitHeight: 38
            color: "transparent"

            // Base container for the bar
            Rectangle {
                id: barContent
                anchors.fill: parent
                color: root.bg0
                border.color: root.bg1
                border.width: 1
                radius: 0 
                anchors.margins: 4

                // Slide-Up Animation on startup
                Component.onCompleted: {
                    slideIn.start();
                }

                PropertyAnimation {
                    id: slideIn
                    target: barContent
                    property: "y"
                    from: bar.implicitHeight
                    to: 0
                    duration: 300
                    easing.type: Easing.OutCubic
                }

                // Left Section: NixOS Launcher
                Row {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 12
                    spacing: 8

                    Rectangle {
                        width: 26
                        height: 26
                        color: "transparent"
                        radius: 0 

                        Text {
                            anchors.centerIn: parent
                            text: "" // NixOS Icon
                            font.family: root.fontName
                            font.pixelSize: 15
                            color: root.blue
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.color = root.bg1
                            onExited: parent.color = "transparent"
                            onClicked: {
                                Quickshell.execDetached(["wofi", "--show", "drun"]);
                            }
                        }
                    }
                }

                // Center Section: Workspaces
                Row {
                    anchors.centerIn: parent
                    spacing: 6

                    Repeater {
                        model: 9
                        delegate: Rectangle {
                            width: 22
                            height: 22
                            radius: 0
                            color: "transparent"

                            readonly property bool isCurrent: {
                                if (Hyprland.focusedWorkspace !== null) {
                                    return Hyprland.focusedWorkspace.id === (index + 1);
                                }
                                return false;
                            }

                            Text {
                                anchors.centerIn: parent
                                text: (index + 1).toString()
                                font.family: root.fontName
                                font.bold: true
                                font.pixelSize: 11
                                color: parent.isCurrent ? root.fg0 : root.fg4
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: parent.isCurrent ? 12 : 0
                                height: 2
                                color: root.aqua
                                radius: 0 

                                Behavior on width {
                                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    Hyprland.dispatch("workspace " + (index + 1));
                                }
                            }
                        }
                    }
                }

                // Right Section: System Tray, Clock & Power Menu
                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 12
                    spacing: 16

                    // SYSTEM TRAY IMPLEMENTATION
                    Row {
                        spacing: 8
                        anchors.verticalCenter: parent.verticalCenter

                        Repeater {
                            model: SystemTray.items

                            delegate: Rectangle {
                                width: 22
                                height: 22
                                color: "transparent"
                                radius: 0

                                // Renders app system icon natively
                                IconImage {
                                    id: trayIcon
                                    anchors.fill: parent
                                    source: modelData.icon
                                    anchors.margins: 2
                                }

                                // Interactive Tooltip displaying application title
                                ToolTip {
                                    id: trayTooltip
                                    text: modelData.title
                                    visible: false
                                    delay: 400
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                                    onEntered: {
                                        parent.color = root.bg1;
                                        trayTooltip.visible = true;
                                    }
                                    onExited: {
                                        parent.color = "transparent";
                                        trayTooltip.visible = false;
                                    }
                                    onClicked: (mouse) => {
                                        if (mouse.button === Qt.LeftButton) {
                                            modelData.activate();
                                        } else if (mouse.button === Qt.RightButton) {
                                            // Displays native client pop-up menus (e.g. Steam / Spotify right click options)
                                            modelData.display(bar, mouse.x, mouse.y);
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Divider separator between System Tray and Clock
                    Rectangle {
                        width: 1
                        height: 16
                        color: root.bg1
                        anchors.verticalCenter: parent.verticalCenter
                        visible: SystemTray.items.count > 0
                    }

                    // Date & Time Status
                    Text {
                        id: clock
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: root.fontName
                        font.pixelSize: 11
                        color: root.fg0

                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            onTriggered: {
                                var d = new Date();
                                clock.text = d.toLocaleDateString(Qt.locale(), "ddd MMM d") + "  " + d.toLocaleTimeString(Qt.locale(), "hh:mm:ss AP");
                            }
                        }
                    }

                    // Power Toggle Button
                    Rectangle {
                        id: powerBtn
                        width: 26
                        height: 26
                        color: "transparent"
                        radius: 0

                        Text {
                            anchors.centerIn: parent
                            text: "⏻"
                            font.family: root.fontName
                            font.pixelSize: 13
                            color: root.red
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.color = root.bg1
                            onExited: parent.color = "transparent"
                            onClicked: {
                                powerMenuPopup.visible = !powerMenuPopup.visible;
                            }
                        }
                    }
                }
            }

            // Power Action Popup Setup
            PopupWindow {
                id: powerMenuPopup
                visible: false
                implicitWidth: 130
                implicitHeight: 110
                color: "transparent"

                anchor {
                    window: bar
                    rect.x: bar.width - implicitWidth - 12
                    rect.y: -implicitHeight - 2
                }

                grabFocus: true

                Behavior on visible {
                    NumberAnimation {
                        target: powerMenuPopup
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 150
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: root.bg0
                    border.color: root.bg1
                    border.width: 1
                    radius: 0

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 4

                        // Power Off Command
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 28
                            color: "transparent"
                            radius: 0

                            Text {
                                anchors.centerIn: parent
                                text: "Shutdown"
                                font.family: root.fontName
                                font.pixelSize: 11
                                color: root.red
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: parent.color = root.bg1
                                onExited: parent.color = "transparent"
                                onClicked: {
                                    Quickshell.execDetached(["systemctl", "poweroff"]);
                                    powerMenuPopup.visible = false;
                                }
                            }
                        }

                        // Restart Command
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 28
                            color: "transparent"
                            radius: 0

                            Text {
                                anchors.centerIn: parent
                                text: "Reboot"
                                font.family: root.fontName
                                font.pixelSize: 11
                                color: root.orange
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: parent.color = root.bg1
                                onExited: parent.color = "transparent"
                                onClicked: {
                                    Quickshell.execDetached(["systemctl", "reboot"]);
                                    powerMenuPopup.visible = false;
                                }
                            }
                        }

                        // Suspend Command
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 28
                            color: "transparent"
                            radius: 0

                            Text {
                                anchors.centerIn: parent
                                text: "Sleep"
                                font.family: root.fontName
                                font.pixelSize: 11
                                color: root.yellow
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: parent.color = root.bg1
                                onExited: parent.color = "transparent"
                                onClicked: {
                                    Quickshell.execDetached(["systemctl", "suspend"]);
                                    powerMenuPopup.visible = false;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
