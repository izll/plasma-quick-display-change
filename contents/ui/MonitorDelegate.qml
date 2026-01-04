/*
    SPDX-FileCopyrightText: 2025 izll
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents

Rectangle {
    id: monitorDelegate

    property var monitor
    property var tr: function(text) { return text; }  // Translation function, should be set by parent
    signal toggleEnabled(string monitorName, bool enabled)
    signal setPrimary(string monitorName)
    signal setMode(string monitorName, string modeId)
    signal requestSettingsChange(string monitorName, string modeId, string originalModeId, string rotation, string originalRotation)

    // Let implicitHeight determine size
    implicitHeight: contentRow.implicitHeight + Kirigami.Units.smallSpacing * 2
    radius: Kirigami.Units.smallSpacing
    color: monitor.enabled ? Kirigami.Theme.activeBackgroundColor : Kirigami.Theme.backgroundColor
    border.color: monitor.primary ? Kirigami.Theme.highlightColor : Kirigami.Theme.disabledTextColor
    border.width: monitor.primary ? 2 : 1
    opacity: monitor.enabled ? 1.0 : 0.7

    RowLayout {
        id: contentRow
        anchors.fill: parent
        anchors.margins: Kirigami.Units.smallSpacing
        spacing: Kirigami.Units.smallSpacing

        Kirigami.Icon {
            source: Qt.resolvedUrl("../icons/monitor-single.svg")
            Layout.preferredWidth: Kirigami.Units.iconSizes.medium
            Layout.preferredHeight: Kirigami.Units.iconSizes.medium
            opacity: monitor.enabled ? 1.0 : 0.5
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 2

            PlasmaComponents.Label {
                text: monitor.name
                font.bold: true
                Layout.fillWidth: true
            }

            PlasmaComponents.Label {
                text: {
                    let res = monitor.geometry.width > 0
                        ? monitor.geometry.width + "x" + monitor.geometry.height
                        : i18n("Disabled");
                    return res;
                }
                font.pixelSize: Kirigami.Theme.smallFont.pixelSize
                opacity: 0.7
                Layout.fillWidth: true
            }

            PlasmaComponents.Label {
                text: {
                    if (monitor.enabled && monitor.currentMode) {
                        let match = monitor.currentMode.match(/\d+:(\d+x\d+@[\d.]+)/);
                        if (match) {
                            return match[1];
                        }
                    }
                    if (monitor.enabled) {
                        return i18n("Position: %1, %2", monitor.geometry.x, monitor.geometry.y);
                    }
                    return i18n("Not active");
                }
                font.pixelSize: Kirigami.Theme.smallFont.pixelSize
                opacity: 0.7
                Layout.fillWidth: true
            }
        }

        // Primary indicator
        PlasmaComponents.ToolButton {
            icon.name: monitor.primary ? "starred" : "non-starred"
            onClicked: {
                if (!monitor.primary) {
                    setPrimary(monitor.name);
                }
            }
            enabled: monitor.enabled && !monitor.primary
            opacity: monitor.enabled ? 1.0 : 0.3
            PlasmaComponents.ToolTip.text: monitor.primary ? i18n("Primary display") : i18n("Set as primary")
            PlasmaComponents.ToolTip.visible: hovered
        }

        // Settings button
        PlasmaComponents.ToolButton {
            icon.name: "configure"
            onClicked: settingsDialog.open()
            enabled: monitor.enabled
            opacity: monitor.enabled ? 1.0 : 0.3
            visible: monitor.enabled
            PlasmaComponents.ToolTip.text: i18n("Display settings")
            PlasmaComponents.ToolTip.visible: hovered
        }

        // Enable/Disable switch
        PlasmaComponents.Switch {
            checked: monitor.enabled
            onToggled: {
                toggleEnabled(monitor.name, checked);
            }
            PlasmaComponents.ToolTip.text: monitor.enabled ? i18n("Disable display") : i18n("Enable display")
            PlasmaComponents.ToolTip.visible: hovered
        }
    }

    // Settings dialog for resolution and refresh rate
    QQC2.Popup {
        id: settingsDialog
        parent: monitorDelegate
        anchors.centerIn: parent
        width: Kirigami.Units.gridUnit * 18
        height: Kirigami.Units.gridUnit * 14
        modal: true
        focus: true

        property bool confirmMode: false
        property string pendingModeId: ""

        // Parse modes into resolution groups
        property var resolutionGroups: {
            let groups = {};
            if (!monitor.modes) return groups;

            for (let mode of monitor.modes) {
                // mode format: "446:2560x1440@144.00"
                let match = mode.match(/(\d+):(\d+x\d+)@([\d.]+)/);
                if (match) {
                    let res = match[2];
                    let refresh = parseFloat(match[3]);
                    let modeId = match[1];

                    if (!groups[res]) {
                        groups[res] = [];
                    }
                    groups[res].push({ id: modeId, refresh: refresh, full: mode });
                }
            }

            // Sort refresh rates descending for each resolution
            for (let res in groups) {
                groups[res].sort((a, b) => b.refresh - a.refresh);
            }

            return groups;
        }

        property var resolutions: Object.keys(resolutionGroups).sort((a, b) => {
            let aW = parseInt(a.split('x')[0]);
            let bW = parseInt(b.split('x')[0]);
            return bW - aW; // Descending by width
        })

        property string selectedResolution: {
            if (monitor.currentMode) {
                let match = monitor.currentMode.match(/\d+:(\d+x\d+)@/);
                if (match) return match[1];
            }
            return resolutions.length > 0 ? resolutions[0] : "";
        }

        property var currentRefreshRates: resolutionGroups[selectedResolution] || []

        property string selectedModeId: {
            if (monitor.currentMode) {
                let match = monitor.currentMode.match(/(\d+):/);
                if (match) return match[1];
            }
            return "";
        }

        property string originalModeId: selectedModeId
        property string originalRotation: monitor.rotation || "none"

        onOpened: {
            confirmMode = false;
            originalModeId = selectedModeId;
            originalRotation = monitor.rotation || "none";
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Kirigami.Units.largeSpacing
            spacing: Kirigami.Units.smallSpacing

            PlasmaComponents.Label {
                text: monitor.name + " " + tr("Settings")
                font.bold: true
                Layout.fillWidth: true
            }

            // Resolution selector
            RowLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                PlasmaComponents.Label {
                    text: tr("Resolution:")
                }

                PlasmaComponents.ComboBox {
                    id: resolutionCombo
                    Layout.fillWidth: true
                    model: settingsDialog.resolutions
                    currentIndex: settingsDialog.resolutions.indexOf(settingsDialog.selectedResolution)
                    onActivated: function(index) {
                        settingsDialog.selectedResolution = settingsDialog.resolutions[index];
                    }
                }
            }

            // Refresh rate selector
            RowLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                PlasmaComponents.Label {
                    text: tr("Refresh rate:")
                }

                PlasmaComponents.ComboBox {
                    id: refreshCombo
                    Layout.fillWidth: true
                    model: settingsDialog.currentRefreshRates.map(r => r.refresh.toFixed(2) + " Hz")
                    currentIndex: {
                        let rates = settingsDialog.currentRefreshRates;
                        for (let i = 0; i < rates.length; i++) {
                            if (rates[i].id === settingsDialog.selectedModeId) return i;
                        }
                        return 0;
                    }
                }
            }

            // Rotation selector
            RowLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                PlasmaComponents.Label {
                    text: tr("Orientation:")
                }

                PlasmaComponents.ComboBox {
                    id: rotationCombo
                    Layout.fillWidth: true
                    model: [tr("Normal"), tr("Left"), tr("Right"), tr("Inverted")]
                    property var rotationValues: ["none", "left", "right", "inverted"]
                    currentIndex: {
                        let rot = monitor.rotation || "none";
                        return rotationValues.indexOf(rot);
                    }
                }
            }

            Item { Layout.fillHeight: true }

            // Buttons
            RowLayout {
                Layout.fillWidth: true

                PlasmaComponents.Label {
                    text: "v1.0.4"
                    opacity: 0.5
                }

                Item { Layout.fillWidth: true }

                PlasmaComponents.Button {
                    text: tr("Cancel")
                    onClicked: settingsDialog.close()
                }

                PlasmaComponents.Button {
                    text: tr("Apply")
                    highlighted: true
                    onClicked: {
                        let rates = settingsDialog.currentRefreshRates;
                        if (rates.length > 0 && refreshCombo.currentIndex >= 0) {
                            let selectedMode = rates[refreshCombo.currentIndex];
                            let selectedRotation = rotationCombo.rotationValues[rotationCombo.currentIndex];
                            settingsDialog.pendingModeId = selectedMode.id;
                            // Signal to parent to show confirmation dialog
                            requestSettingsChange(
                                monitor.name,
                                selectedMode.id,
                                settingsDialog.originalModeId,
                                selectedRotation,
                                settingsDialog.originalRotation
                            );
                            settingsDialog.close();
                        }
                    }
                }
            }
        }
    }
}
