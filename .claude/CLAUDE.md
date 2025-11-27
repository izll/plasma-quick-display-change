# Quick Display Change Widget - Project Documentation

## Project Overview

**Name**: Quick Display Change Widget
**Type**: KDE Plasma 6 Plasmoid
**Version**: 1.0.0
**Author**: izll
**License**: GPL-3.0-or-later

A panel widget for KDE Plasma 6 that provides quick access to monitor configuration using kscreen-doctor.

---

## Architecture

### Component Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                      main.qml                                │
│  - Root PlasmoidItem                                        │
│  - Monitor data model                                       │
│  - Configuration properties                                 │
│  - kscreen-doctor command execution                         │
├─────────────────────────────────────────────────────────────┤
│     │                    │                    │              │
│     ▼                    ▼                    ▼              │
│ ┌─────────────┐  ┌─────────────────┐  ┌──────────────┐     │
│ │ Compact     │  │ Full            │  │ configGeneral│     │
│ │Representation│  │Representation   │  │   .qml       │     │
│ │   .qml      │  │   .qml          │  │              │     │
│ │             │  │                 │  │ Settings     │     │
│ │ Panel icon  │  │ Popup content   │  │ page         │     │
│ │ + badge     │  │ + monitor list  │  │              │     │
│ └─────────────┘  │ + layout buttons│  └──────────────┘     │
│                  │ + settings      │                        │
│                  └────────┬────────┘                        │
│                           │                                 │
│              ┌────────────┼────────────┐                    │
│              ▼            ▼            ▼                    │
│     ┌──────────────┐ ┌──────────┐ ┌──────────────┐         │
│     │MonitorDelegate│ │ Layout   │ │IdentifyWindow│         │
│     │    .qml      │ │ Editor   │ │    .qml      │         │
│     │              │ │  .qml    │ │              │         │
│     │ List item    │ │          │ │ Overlay for  │         │
│     │ per monitor  │ │ Drag&drop│ │ identification│         │
│     └──────────────┘ │ editor   │ └──────────────┘         │
│                      └──────────┘                           │
└─────────────────────────────────────────────────────────────┘

Supporting Components:
┌─────────────────┐  ┌─────────────────┐
│ CommandRunner   │  │ Translations    │
│    .qml         │  │    .qml         │
│                 │  │                 │
│ Executes        │  │ Multi-language  │
│ kscreen-doctor  │  │ support (16)    │
└─────────────────┘  └─────────────────┘
```

---

## File Structure

```
quick-display-change-widget/
├── metadata.json                 # Widget metadata & KDE Store info
├── contents/
│   ├── ui/
│   │   ├── main.qml              # Root component, data model, logic
│   │   ├── CompactRepresentation.qml  # Panel icon with badge
│   │   ├── FullRepresentation.qml     # Popup UI
│   │   ├── LayoutEditor.qml      # Drag & drop monitor positioning
│   │   ├── MonitorDelegate.qml   # Individual monitor list item
│   │   ├── IdentifyWindow.qml    # Monitor ID overlay window
│   │   ├── CommandRunner.qml     # kscreen-doctor executor
│   │   ├── Translations.qml      # i18n strings (16 languages)
│   │   └── configGeneral.qml     # Widget settings page
│   ├── config/
│   │   ├── main.xml              # Configuration schema
│   │   └── config.qml            # Config entry point
│   └── icons/
│       ├── monitors.svg          # Main widget icon
│       └── monitor-single.svg    # Single monitor icon
├── docs/
│   └── README.md                 # User documentation
└── .claude/
    └── CLAUDE.md                 # This file
```

---

## Key Components

### main.qml
- **Role**: Root PlasmoidItem, central data model
- **Key Properties**:
  - `monitors`: ListModel of detected monitors
  - `configLanguage`: Language setting proxy
  - `configShowBadge`: Badge visibility proxy
- **Key Functions**:
  - `refreshMonitors()`: Parse kscreen-doctor output
  - `parseKscreenOutput()`: Convert text to monitor objects
  - `applyLayout()`: Execute layout changes
  - `setLanguage()`, `setShowBadge()`: Config setters

### FullRepresentation.qml
- **Role**: Main popup interface
- **Sections**:
  - Header with title and refresh button
  - Monitor list (using MonitorDelegate)
  - Quick Layout buttons (Side by Side, Mirror, etc.)
  - Layout Preview button (opens LayoutEditor)
  - Widget Settings section (language, badge toggle)

### LayoutEditor.qml
- **Role**: Visual drag & drop monitor positioning
- **Features**:
  - Scaled preview of monitor arrangement
  - Drag monitors to reposition
  - Snap-to-edge alignment
  - Apply button to execute changes

### CommandRunner.qml
- **Role**: Execute shell commands via DataSource
- **Implementation**: Uses `org.kde.plasma.plasma5support` DataSource with "executable" engine
- **Fallback**: Tries legacy `org.kde.plasma.core 2.0` import

### Translations.qml
- **Role**: Multi-language support
- **Languages**: 16 (en, hu, de, fr, es, it, pt-BR, ru, pl, nl, tr, ja, ko, zh-CN, zh-TW)
- **Functions**:
  - `tr(text)`: Get translated string
  - `trn(singular, plural, count)`: Pluralization

---

## Configuration

### Stored in Plasmoid.configuration:
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `language` | string | "system" | Language code or "system" |
| `showBadge` | bool | true | Show monitor count on icon |

### Schema (contents/config/main.xml):
```xml
<entry name="language" type="String">
    <default>system</default>
</entry>
<entry name="showBadge" type="Bool">
    <default>true</default>
</entry>
```

---

## kscreen-doctor Commands

### Query Monitors
```bash
kscreen-doctor --outputs
```

### Enable/Disable
```bash
kscreen-doctor output.HDMI-0.enable
kscreen-doctor output.HDMI-0.disable
```

### Set Position
```bash
kscreen-doctor output.HDMI-0.position.0,0 output.HDMI-1.position.2560,0
```

### Set Primary
```bash
kscreen-doctor output.HDMI-0.primary
```

### Set Scale
```bash
kscreen-doctor output.HDMI-0.scale.1.25
```

---

## Development

### Install from source
```bash
kpackagetool6 -t Plasma/Applet -i /path/to/quick-display-change-widget
```

### Update after changes
```bash
kpackagetool6 -t Plasma/Applet -u /path/to/quick-display-change-widget
plasmashell --replace &
```

### Remove
```bash
kpackagetool6 -t Plasma/Applet -r org.kde.plasma.quickdisplaychange
```

### Package for distribution
```bash
cd /path/to/quick-display-change-widget
zip -r ../quick-display-change.plasmoid . -x ".claude/*" -x "*.git*"
```

---

## Known Issues & Patterns

### Loader Scope Issues
Components inside QML `Loader` cannot directly access `Plasmoid.configuration`.
**Solution**: Create proxy properties and setter functions in main.qml:
```qml
property bool configShowBadge: Plasmoid.configuration.showBadge
function setShowBadge(show) {
    Plasmoid.configuration.showBadge = show;
    configShowBadge = show;
}
```

### Multiple Widget Instances
When widget is added to both panel and system tray, each instance has separate configuration. This is standard Plasma behavior.

### DataSource Import
Plasma 6 uses `org.kde.plasma.plasma5support`, but some systems may need fallback to legacy imports.

---

## Testing Checklist

- [ ] Monitor detection on single/multi-monitor setups
- [ ] Enable/disable monitors
- [ ] Layout presets (Side by Side, Mirror, etc.)
- [ ] Drag & drop positioning
- [ ] Primary display selection
- [ ] Language switching (all 16 languages)
- [ ] Badge toggle functionality
- [ ] Monitor identification overlay
- [ ] Widget in panel vs system tray

---

## Version History

### 1.0.1 (2025-11-27)
- Added version number display in settings dialog (bottom-left corner)
- Added "Expand for better view" hint when Layout Preview area is too small
- Removed minimum size constraints on monitor rectangles in Layout Editor
- Adjusted popup Layout parameters for better responsiveness
- Added KDE Store link to metadata.json Website field
- Updated translations for new UI text (all 16 languages)

### 1.0.0 (2025-11-26)
- Initial release
- Multi-monitor detection and control
- 6 layout presets
- Visual drag & drop editor
- 16 language translations
- Configurable badge display
