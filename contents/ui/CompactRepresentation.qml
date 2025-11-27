/*
    SPDX-FileCopyrightText: 2025 izll
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

Item {
    id: compactRoot

    readonly property bool inPanel: [PlasmaCore.Types.TopEdge, PlasmaCore.Types.RightEdge,
                                      PlasmaCore.Types.BottomEdge, PlasmaCore.Types.LeftEdge]
                                      .includes(Plasmoid.location)

    Layout.minimumWidth: Kirigami.Units.iconSizes.small
    Layout.minimumHeight: Kirigami.Units.iconSizes.small
    Layout.preferredWidth: inPanel ? Kirigami.Units.iconSizes.medium : Kirigami.Units.iconSizes.large
    Layout.preferredHeight: Layout.preferredWidth

    // Only use MouseArea when NOT in system tray (panel needs it, system tray handles clicks itself)
    MouseArea {
        anchors.fill: parent
        visible: !root.inSystemTray
        enabled: !root.inSystemTray

        onClicked: mouse => {
            root.expanded = !root.expanded;
        }
    }

    Kirigami.Icon {
        id: monitorIcon
        anchors.fill: parent
        source: Qt.resolvedUrl("../icons/monitors.svg")

        // Badge showing number of enabled monitors
        Rectangle {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: Kirigami.Units.iconSizes.small * 0.7
            height: width
            radius: width / 2
            color: Kirigami.Theme.highlightColor
            visible: root.configShowBadge && root.monitors.length > 1

            Text {
                anchors.centerIn: parent
                text: root.monitors.filter(m => m.enabled).length
                color: Kirigami.Theme.highlightedTextColor
                font.pixelSize: parent.height * 0.7
                font.bold: true
            }
        }
    }

    // Busy indicator when refreshing
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        visible: root.isRefreshing

        Kirigami.Icon {
            anchors.centerIn: parent
            width: parent.width * 0.5
            height: width
            source: "view-refresh"

            RotationAnimator on rotation {
                from: 0
                to: 360
                duration: 1000
                loops: Animation.Infinite
                running: root.isRefreshing
            }
        }
    }
}
