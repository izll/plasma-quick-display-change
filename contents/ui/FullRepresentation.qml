/*
    SPDX-FileCopyrightText: 2025 izll
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

PlasmaExtras.Representation {
    id: fullRoot

    // Reference to layout editor (loaded via Loader)
    property var layoutEditor: layoutEditorLoader.item

    // Fixed size - large enough for everything including vertical monitor arrangements
    Layout.minimumWidth: Kirigami.Units.gridUnit * 26
    Layout.minimumHeight: Kirigami.Units.gridUnit * 36
    Layout.preferredWidth: Kirigami.Units.gridUnit * 30
    Layout.preferredHeight: Kirigami.Units.gridUnit * 42
    Layout.maximumWidth: Kirigami.Units.gridUnit * 35
    Layout.maximumHeight: Kirigami.Units.gridUnit * 50

    // Reset layout editor when panel becomes visible
    Connections {
        target: root
        function onExpandedChanged() {
            if (root.expanded && layoutEditor) {
                layoutEditor.resetChanges();
            }
        }
    }

    header: PlasmaExtras.PlasmoidHeading {
        RowLayout {
            anchors.fill: parent
            spacing: Kirigami.Units.smallSpacing

            Kirigami.Heading {
                level: 3
                text: root.tr("Display Configuration")
                Layout.fillWidth: true
            }

            PlasmaComponents.ToolButton {
                icon.name: "view-refresh"
                onClicked: root.refreshMonitors()
                PlasmaComponents.ToolTip.text: root.tr("Refresh monitors")
                PlasmaComponents.ToolTip.visible: hovered
            }

            PlasmaComponents.ToolButton {
                icon.name: "globe"
                onClicked: openSettings()
                PlasmaComponents.ToolTip.text: root.tr("Widget Settings")
                PlasmaComponents.ToolTip.visible: hovered
            }

            PlasmaComponents.ToolButton {
                icon.name: "configure"
                onClicked: settingsProcess.run("systemsettings kcm_kscreen")
                PlasmaComponents.ToolTip.text: root.tr("Open Display Settings")
                PlasmaComponents.ToolTip.visible: hovered
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.smallSpacing
        spacing: Kirigami.Units.smallSpacing

        // Quick Layout Presets
        PlasmaExtras.Heading {
            level: 5
            text: root.tr("Quick Layouts")
        }

        Flow {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            PlasmaComponents.Button {
                icon.name: "view-split-left-right"
                text: root.tr("Side by Side")
                onClicked: applyPresetLayout("sidebyside")
                enabled: root.monitors.filter(m => m.connected).length >= 2
            }

            PlasmaComponents.Button {
                icon.name: "view-right-new"
                text: root.tr("Extend Right")
                onClicked: applyPresetLayout("extendright")
                enabled: root.monitors.filter(m => m.connected).length >= 2
            }

            PlasmaComponents.Button {
                icon.name: "view-left-new"
                text: root.tr("Extend Left")
                onClicked: applyPresetLayout("extendleft")
                enabled: root.monitors.filter(m => m.connected).length >= 2
            }

            PlasmaComponents.Button {
                icon.name: "view-split-top-bottom"
                text: root.tr("Stacked")
                onClicked: applyPresetLayout("stacked")
                enabled: root.monitors.filter(m => m.connected).length >= 2
            }

            PlasmaComponents.Button {
                icon.name: "video-display-symbolic"
                text: root.tr("Mirror")
                onClicked: applyPresetLayout("mirror")
                enabled: root.monitors.filter(m => m.connected).length >= 2
            }

            PlasmaComponents.Button {
                icon.name: "computer-laptop"
                text: root.tr("Primary Only")
                onClicked: applyPresetLayout("primaryonly")
            }

            PlasmaComponents.Button {
                icon.name: "documentinfo"
                text: root.tr("Identify")
                onClicked: identifyMonitors()
            }
        }

        Kirigami.Separator {
            Layout.fillWidth: true
        }

        // Monitor List
        PlasmaExtras.Heading {
            level: 5
            text: root.tr("Monitors") + " (" + root.monitors.length + ")"
        }

        // Monitor cards
        Repeater {
            model: root.monitors

            delegate: MonitorDelegate {
                Layout.fillWidth: true
                monitor: modelData
                onToggleEnabled: function(monitorName, enabled) {
                    let cmd = enabled ? "enable" : "disable";
                    root.applyMonitorSettings(["output." + monitorName + "." + cmd]);
                }
                onSetPrimary: function(monitorName) {
                    root.applyMonitorSettings(["output." + monitorName + ".priority.1"]);
                }
            }
        }

        Kirigami.Separator {
            Layout.fillWidth: true
        }

        // Layout Preview/Editor
        RowLayout {
            Layout.fillWidth: true

            PlasmaExtras.Heading {
                level: 5
                text: root.tr("Layout Preview")
                Layout.fillWidth: true
            }

            PlasmaComponents.Button {
                icon.name: "dialog-ok-apply"
                text: root.tr("Apply")
                enabled: layoutEditor && layoutEditor.hasChanges
                onClicked: {
                    if (layoutEditor) {
                        applyLayoutPositions(layoutEditor.getPendingPositions());
                        layoutEditor.hasChanges = false;
                        layoutEditor.pendingPositions = {};
                    }
                }
            }
        }

        // Use Loader to force full recreation when monitors change
        Loader {
            id: layoutEditorLoader
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: Kirigami.Units.gridUnit * 10

            sourceComponent: LayoutEditor {
                anchors.fill: parent
                monitors: root.monitors
            }

            // Force reload when monitors array changes
            property var monitorsRef: root.monitors
            onMonitorsRefChanged: {
                active = false;
                active = true;
            }
        }
    }

    function applyPresetLayout(preset) {
        let connectedMonitors = root.monitors.filter(m => m.connected);
        if (connectedMonitors.length < 1) return;

        let commands = [];

        switch (preset) {
            case "sidebyside":
            case "extendright": {
                let xPos = 0;
                for (let i = 0; i < connectedMonitors.length; i++) {
                    let m = connectedMonitors[i];
                    commands.push("output." + m.name + ".enable");
                    commands.push("output." + m.name + ".position." + xPos + ",0");
                    xPos += m.geometry.width > 0 ? m.geometry.width : 1920;
                }
                break;
            }
            case "extendleft": {
                let monitors = connectedMonitors.slice().reverse();
                let xPos = 0;
                for (let i = 0; i < monitors.length; i++) {
                    let m = monitors[i];
                    commands.push("output." + m.name + ".enable");
                    commands.push("output." + m.name + ".position." + xPos + ",0");
                    xPos += m.geometry.width > 0 ? m.geometry.width : 1920;
                }
                break;
            }
            case "stacked": {
                let yPos = 0;
                for (let i = 0; i < connectedMonitors.length; i++) {
                    let m = connectedMonitors[i];
                    commands.push("output." + m.name + ".enable");
                    commands.push("output." + m.name + ".position.0," + yPos);
                    yPos += m.geometry.height > 0 ? m.geometry.height : 1080;
                }
                break;
            }
            case "mirror": {
                // Enable all and set same position
                for (let m of connectedMonitors) {
                    commands.push("output." + m.name + ".enable");
                    commands.push("output." + m.name + ".position.0,0");
                }
                break;
            }
            case "primaryonly": {
                // Find primary or first monitor
                let primary = connectedMonitors.find(m => m.primary) || connectedMonitors[0];
                for (let m of connectedMonitors) {
                    if (m.name === primary.name) {
                        commands.push("output." + m.name + ".enable");
                        commands.push("output." + m.name + ".position.0,0");
                    } else {
                        commands.push("output." + m.name + ".disable");
                    }
                }
                break;
            }
        }

        if (commands.length > 0) {
            root.applyMonitorSettings(commands);
        }
    }

    function applyLayoutPositions(positions) {
        let commands = [];
        for (let pos of positions) {
            let cmd = "output." + pos.name + ".position." + Math.round(pos.x) + "," + Math.round(pos.y);
            commands.push(cmd);
        }
        if (commands.length > 0) {
            root.applyMonitorSettings(commands);
        }
    }

    property var identifyWindows: []

    function identifyMonitors() {
        // Close any existing windows
        for (let w of identifyWindows) {
            if (w) w.destroy();
        }
        identifyWindows = [];

        // Create a window on each enabled monitor
        let enabledMonitors = root.monitors.filter(m => m.enabled);

        for (let m of enabledMonitors) {
            let component = Qt.createComponent("IdentifyWindow.qml");
            if (component.status === Component.Ready) {
                let window = component.createObject(fullRoot, {
                    monitorName: m.name,
                    resolution: m.geometry.width + "x" + m.geometry.height,
                    monitorX: m.geometry.x,
                    monitorY: m.geometry.y,
                    monitorWidth: m.geometry.width || 1920,
                    monitorHeight: m.geometry.height || 1080
                });
                identifyWindows.push(window);
            } else {
                console.log("Error creating IdentifyWindow:", component.errorString());
            }
        }
    }

    CommandRunner {
        id: settingsProcess
    }

    // Settings dialog loader - recreates dialog each time for fresh translations
    Loader {
        id: configDialogLoader
        active: false

        sourceComponent: QQC2.Popup {
            id: configDialog
            parent: fullRoot
            anchors.centerIn: parent
            width: Kirigami.Units.gridUnit * 20
            height: Kirigami.Units.gridUnit * 12
            modal: true
            focus: true
            visible: true  // Open immediately when created

            onClosed: configDialogLoader.active = false  // Destroy when closed

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Kirigami.Units.largeSpacing
                spacing: Kirigami.Units.largeSpacing

                Kirigami.Heading {
                    level: 3
                    text: root.tr("Widget Settings")
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    PlasmaComponents.Label {
                        text: root.tr("Language:")
                    }

                    PlasmaComponents.ComboBox {
                        id: languageCombo
                        Layout.fillWidth: true
                        model: [
                            root.tr("System default"), "English", "Magyar", "Deutsch",
                            "Français", "Español", "Italiano", "Português (Brasil)",
                            "Русский", "Polski", "Nederlands", "Türkçe",
                            "日本語", "한국어", "简体中文", "繁體中文"
                        ]
                        property var languageValues: [
                            "system", "en_US", "hu_HU", "de_DE", "fr_FR", "es_ES",
                            "it_IT", "pt_BR", "ru_RU", "pl_PL", "nl_NL", "tr_TR",
                            "ja_JP", "ko_KR", "zh_CN", "zh_TW"
                        ]
                        currentIndex: languageValues.indexOf(root.configLanguage)
                        // Use onActivated instead of onCurrentIndexChanged - only fires on user interaction
                        onActivated: function(index) {
                            console.log("Language activated to index: " + index + " = " + languageValues[index]);
                            let newLang = languageValues[index];
                            if (root.configLanguage !== newLang) {
                                root.setLanguage(newLang);
                                // Close dialog - it will be recreated with new translations when reopened
                                configDialog.close();
                            }
                        }
                    }
                }

                PlasmaComponents.Label {
                    text: root.tr("Language changes apply immediately.")
                    wrapMode: Text.WordWrap
                    opacity: 0.7
                    Layout.fillWidth: true
                }

                PlasmaComponents.CheckBox {
                    id: showBadgeCheckbox
                    text: root.tr("Show monitor count badge")
                    checked: root.configShowBadge
                    onToggled: {
                        root.setShowBadge(checked);
                    }
                }

                Item { Layout.fillHeight: true }

                PlasmaComponents.Button {
                    text: root.tr("Close")
                    Layout.alignment: Qt.AlignRight
                    onClicked: configDialog.close()
                }
            }
        }
    }

    // Function to open settings dialog (creates fresh instance)
    function openSettings() {
        configDialogLoader.active = true;
    }
}
