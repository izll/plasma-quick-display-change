/*
    SPDX-FileCopyrightText: 2025 izll
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.core as PlasmaCore

PlasmaCore.Dialog {
    id: identifyDialog

    property string monitorName: ""
    property string resolution: ""
    property var targetScreen: null

    type: PlasmaCore.Dialog.OnScreenDisplay
    flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint | Qt.Tool | Qt.WindowDoesNotAcceptFocus
    location: PlasmaCore.Types.Floating
    hideOnWindowDeactivate: false
    outputOnly: true

    visible: false

    mainItem: Rectangle {
        width: 300
        height: 150
        radius: 10
        color: Kirigami.Theme.backgroundColor
        opacity: 0.95
        border.color: Kirigami.Theme.highlightColor
        border.width: 3

        Column {
            width: parent.width
            anchors.centerIn: parent
            spacing: 8

            Text {
                width: parent.width
                text: identifyDialog.monitorName
                font.pixelSize: 32
                font.bold: true
                color: Kirigami.Theme.textColor
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                width: parent.width
                text: identifyDialog.resolution
                font.pixelSize: 18
                color: Kirigami.Theme.textColor
                opacity: 0.8
                horizontalAlignment: Text.AlignHCenter
            }
        }

        // Auto close timer - must be inside mainItem
        Timer {
            id: closeTimer
            interval: 3000
            running: identifyDialog.visible
            onTriggered: identifyDialog.visible = false
        }
    }

    function showOnScreen(screen) {
        if (screen) {
            targetScreen = screen;
            // Calculate center position on the target screen
            var centerX = screen.virtualX + Math.floor((screen.width - 300) / 2);
            var centerY = screen.virtualY + Math.floor((screen.height - 150) / 2);

            identifyDialog.x = centerX;
            identifyDialog.y = centerY;
            identifyDialog.visible = true;
        }
    }
}
