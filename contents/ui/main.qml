/*
    SPDX-FileCopyrightText: 2025 izll
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents

PlasmoidItem {
    id: root

    property var monitors: []
    property bool isRefreshing: false

    // Translation helper
    Translations {
        id: trans
        currentLanguage: Plasmoid.configuration.language || "system"
    }

    // Expose version for binding dependencies
    property int translationVersion: trans.version

    // Language configuration access
    property string configLanguage: Plasmoid.configuration.language || "system"
    function setLanguage(lang) {
        Plasmoid.configuration.language = lang;
        configLanguage = lang;  // Explicitly update the property
        trans.currentLanguage = lang;
    }

    // Badge configuration access
    property bool configShowBadge: Plasmoid.configuration.showBadge
    function setShowBadge(show) {
        Plasmoid.configuration.showBadge = show;
        configShowBadge = show;  // Explicitly update the property
    }

    function tr(text) { return trans.tr(text); }
    function trn(singular, plural, count) { return trans.trn(singular, plural, count); }

    // System tray detection
    property bool inSystemTray: Plasmoid.containment.containmentType === PlasmaCore.Containment.CustomEmbedded

    switchWidth: Kirigami.Units.gridUnit * 5
    switchHeight: Kirigami.Units.gridUnit * 5

    compactRepresentation: CompactRepresentation {}
    fullRepresentation: FullRepresentation {}

    Plasmoid.icon: "monitors"
    Plasmoid.title: tr("Quick Display Change")
    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground
    Plasmoid.status: monitors.length > 0 ? PlasmaCore.Types.ActiveStatus : PlasmaCore.Types.PassiveStatus

    toolTipMainText: tr("Quick Display Change")
    toolTipSubText: {
        let enabled = monitors.filter(m => m.enabled).length;
        return trn("%1 monitor enabled", "%1 monitors enabled", enabled);
    }

    Component.onCompleted: {
        refreshMonitors();
    }

    // Refresh monitors when popup opens
    onExpandedChanged: function() {
        if (root.expanded) {
            refreshMonitors();
        }
    }

    function refreshMonitors() {
        isRefreshing = true;
        monitorProcess.run("kscreen-doctor -o");
    }

    function applyMonitorSettings(commands) {
        if (commands.length > 0) {
            let cmdStr = "kscreen-doctor " + commands.join(" ");
            applyProcess.run(cmdStr);
        }
    }

    // Process for getting monitor info
    CommandRunner {
        id: monitorProcess
        onFinished: function(exitCode, stdout, stderr) {
            parseMonitorOutput(stdout);
            isRefreshing = false;
        }
    }

    // Process for applying settings
    CommandRunner {
        id: applyProcess
        onFinished: function(exitCode, stdout, stderr) {
            // Refresh after applying
            Qt.callLater(refreshMonitors);
        }
    }

    function parseMonitorOutput(output) {
        // Remove ANSI color codes
        output = output.replace(/\x1b\[[0-9;]*m/g, '');

        let lines = output.split("\n");
        let newMonitors = [];
        let currentMonitor = null;

        for (let line of lines) {
            // Output line: Output: 445 HDMI-0
            let outputMatch = line.match(/Output:\s+(\d+)\s+(\S+)/);
            if (outputMatch) {
                if (currentMonitor) {
                    newMonitors.push(currentMonitor);
                }
                currentMonitor = {
                    id: outputMatch[1],
                    name: outputMatch[2],
                    enabled: false,
                    connected: false,
                    primary: false,
                    geometry: { x: 0, y: 0, width: 0, height: 0 },
                    modes: [],
                    currentMode: ""
                };
            }

            if (currentMonitor) {
                // Check for enabled/disabled - must exclude "disabled" when checking "enabled"
                if (line.includes("enabled") && !line.includes("disabled")) {
                    currentMonitor.enabled = true;
                }
                if (line.includes("connected") && !line.includes("disconnected")) {
                    currentMonitor.connected = true;
                }
                if (line.includes("priority 1")) {
                    currentMonitor.primary = true;
                }

                // Geometry: 0,0 2560x1440
                let geoMatch = line.match(/Geometry:\s+(\d+),(\d+)\s+(\d+)x(\d+)/);
                if (geoMatch) {
                    currentMonitor.geometry = {
                        x: parseInt(geoMatch[1]),
                        y: parseInt(geoMatch[2]),
                        width: parseInt(geoMatch[3]),
                        height: parseInt(geoMatch[4])
                    };
                }

                // Current mode marked with *
                let modeMatch = line.match(/(\d+:\d+x\d+@[\d.]+)\*/);
                if (modeMatch) {
                    currentMonitor.currentMode = modeMatch[1];
                }

                // Parse available modes
                let modesMatch = line.match(/Modes:\s+(.+)/);
                if (modesMatch) {
                    let modesStr = modesMatch[1];
                    let modes = modesStr.match(/\d+:\d+x\d+@[\d.]+/g);
                    if (modes) {
                        currentMonitor.modes = modes;
                    }
                }
            }
        }

        if (currentMonitor) {
            newMonitors.push(currentMonitor);
        }

        // Filter only connected monitors
        monitors = newMonitors.filter(m => m.connected);
    }
}
