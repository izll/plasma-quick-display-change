/*
    SPDX-FileCopyrightText: 2025 izll
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick

QtObject {
    id: translations

    property string currentLanguage: "system"
    property int version: 0  // Increment to force rebinding

    onCurrentLanguageChanged: {
        version++;  // Force all tr() calls to re-evaluate
    }

    readonly property var strings: ({
        "en_US": {
            "Quick Display Change": "Quick Display Change",
            "Display Configuration": "Display Configuration",
            "Refresh monitors": "Refresh monitors",
            "Open Display Settings": "Open Display Settings",
            "Quick Layouts": "Quick Layouts",
            "Side by Side": "Side by Side",
            "Extend Right": "Extend Right",
            "Extend Left": "Extend Left",
            "Stacked": "Stacked",
            "Mirror": "Mirror",
            "Primary Only": "Primary Only",
            "Identify": "Identify",
            "Monitors": "Monitors",
            "Layout Preview": "Layout Preview",
            "Apply": "Apply",
            "Primary": "Primary",
            "Enabled": "Enabled",
            "Set as Primary": "Set as Primary",
            "Language:": "Language:",
            "System default": "System default",
            "Language changes apply immediately.": "Language changes apply immediately.",
            "Close": "Close",
            "Widget Settings": "Widget Settings",
            "%1 monitor enabled": "%1 monitor enabled",
            "%1 monitors enabled": "%1 monitors enabled",
            "Show monitor count badge": "Show monitor count badge"
        },
        "hu_HU": {
            "Quick Display Change": "Gyors kijelzőváltó",
            "Display Configuration": "Kijelző beállítások",
            "Refresh monitors": "Monitorok frissítése",
            "Open Display Settings": "Kijelző beállítások megnyitása",
            "Quick Layouts": "Gyors elrendezések",
            "Side by Side": "Egymás mellett",
            "Extend Right": "Kiterjesztés jobbra",
            "Extend Left": "Kiterjesztés balra",
            "Stacked": "Egymás felett",
            "Mirror": "Tükrözés",
            "Primary Only": "Csak elsődleges",
            "Identify": "Azonosítás",
            "Monitors": "Monitorok",
            "Layout Preview": "Elrendezés előnézet",
            "Apply": "Alkalmaz",
            "Primary": "Elsődleges",
            "Enabled": "Bekapcsolva",
            "Set as Primary": "Beállítás elsődlegesként",
            "Language:": "Nyelv:",
            "System default": "Rendszer alapértelmezett",
            "Language changes apply immediately.": "A nyelvváltás azonnal érvényesül.",
            "Close": "Bezárás",
            "Widget Settings": "Widget beállítások",
            "%1 monitor enabled": "%1 monitor bekapcsolva",
            "%1 monitors enabled": "%1 monitor bekapcsolva",
            "Show monitor count badge": "Monitor számláló jelvény megjelenítése"
        },
        "de_DE": {
            "Quick Display Change": "Schneller Anzeigewechsel",
            "Display Configuration": "Anzeigeeinstellungen",
            "Refresh monitors": "Monitore aktualisieren",
            "Open Display Settings": "Anzeigeeinstellungen öffnen",
            "Quick Layouts": "Schnelllayouts",
            "Side by Side": "Nebeneinander",
            "Extend Right": "Nach rechts erweitern",
            "Extend Left": "Nach links erweitern",
            "Stacked": "Gestapelt",
            "Mirror": "Spiegeln",
            "Primary Only": "Nur Hauptbildschirm",
            "Identify": "Identifizieren",
            "Monitors": "Monitore",
            "Layout Preview": "Layout-Vorschau",
            "Apply": "Anwenden",
            "Primary": "Primär",
            "Enabled": "Aktiviert",
            "Set as Primary": "Als Primär festlegen",
            "Language:": "Sprache:",
            "System default": "Systemstandard",
            "Language changes apply immediately.": "Sprachänderungen werden sofort wirksam.",
            "Close": "Schließen",
            "Widget Settings": "Widget-Einstellungen",
            "%1 monitor enabled": "%1 Monitor aktiviert",
            "%1 monitors enabled": "%1 Monitore aktiviert",
            "Show monitor count badge": "Monitorzähler-Badge anzeigen"
        },
        "fr_FR": {
            "Quick Display Change": "Changement d'affichage rapide",
            "Display Configuration": "Configuration de l'affichage",
            "Refresh monitors": "Actualiser les moniteurs",
            "Open Display Settings": "Ouvrir les paramètres d'affichage",
            "Quick Layouts": "Dispositions rapides",
            "Side by Side": "Côte à côte",
            "Extend Right": "Étendre à droite",
            "Extend Left": "Étendre à gauche",
            "Stacked": "Empilé",
            "Mirror": "Miroir",
            "Primary Only": "Principal uniquement",
            "Identify": "Identifier",
            "Monitors": "Moniteurs",
            "Layout Preview": "Aperçu de la disposition",
            "Apply": "Appliquer",
            "Primary": "Principal",
            "Enabled": "Activé",
            "Set as Primary": "Définir comme principal",
            "Language:": "Langue :",
            "System default": "Par défaut du système",
            "Language changes apply immediately.": "Les changements de langue s'appliquent immédiatement.",
            "Close": "Fermer",
            "Widget Settings": "Paramètres du widget",
            "%1 monitor enabled": "%1 moniteur activé",
            "%1 monitors enabled": "%1 moniteurs activés",
            "Show monitor count badge": "Afficher le badge du nombre de moniteurs"
        },
        "es_ES": {
            "Quick Display Change": "Cambio rápido de pantalla",
            "Display Configuration": "Configuración de pantalla",
            "Refresh monitors": "Actualizar monitores",
            "Open Display Settings": "Abrir configuración de pantalla",
            "Quick Layouts": "Diseños rápidos",
            "Side by Side": "Lado a lado",
            "Extend Right": "Extender a la derecha",
            "Extend Left": "Extender a la izquierda",
            "Stacked": "Apilado",
            "Mirror": "Espejo",
            "Primary Only": "Solo principal",
            "Identify": "Identificar",
            "Monitors": "Monitores",
            "Layout Preview": "Vista previa del diseño",
            "Apply": "Aplicar",
            "Primary": "Principal",
            "Enabled": "Habilitado",
            "Set as Primary": "Establecer como principal",
            "Language:": "Idioma:",
            "System default": "Predeterminado del sistema",
            "Language changes apply immediately.": "Los cambios de idioma se aplican inmediatamente.",
            "Close": "Cerrar",
            "Widget Settings": "Configuración del widget",
            "%1 monitor enabled": "%1 monitor habilitado",
            "%1 monitors enabled": "%1 monitores habilitados",
            "Show monitor count badge": "Mostrar insignia de cantidad de monitores"
        },
        "it_IT": {
            "Quick Display Change": "Cambio rapido display",
            "Display Configuration": "Configurazione display",
            "Refresh monitors": "Aggiorna monitor",
            "Open Display Settings": "Apri impostazioni display",
            "Quick Layouts": "Layout rapidi",
            "Side by Side": "Affiancati",
            "Extend Right": "Estendi a destra",
            "Extend Left": "Estendi a sinistra",
            "Stacked": "Impilati",
            "Mirror": "Specchio",
            "Primary Only": "Solo principale",
            "Identify": "Identifica",
            "Monitors": "Monitor",
            "Layout Preview": "Anteprima layout",
            "Apply": "Applica",
            "Primary": "Principale",
            "Enabled": "Abilitato",
            "Set as Primary": "Imposta come principale",
            "Language:": "Lingua:",
            "System default": "Predefinito di sistema",
            "Language changes apply immediately.": "Le modifiche alla lingua vengono applicate immediatamente.",
            "Close": "Chiudi",
            "Widget Settings": "Impostazioni widget",
            "%1 monitor enabled": "%1 monitor abilitato",
            "%1 monitors enabled": "%1 monitor abilitati",
            "Show monitor count badge": "Mostra badge conteggio monitor"
        },
        "pt_BR": {
            "Quick Display Change": "Troca rápida de tela",
            "Display Configuration": "Configuração de tela",
            "Refresh monitors": "Atualizar monitores",
            "Open Display Settings": "Abrir configurações de tela",
            "Quick Layouts": "Layouts rápidos",
            "Side by Side": "Lado a lado",
            "Extend Right": "Estender à direita",
            "Extend Left": "Estender à esquerda",
            "Stacked": "Empilhado",
            "Mirror": "Espelho",
            "Primary Only": "Apenas principal",
            "Identify": "Identificar",
            "Monitors": "Monitores",
            "Layout Preview": "Pré-visualização do layout",
            "Apply": "Aplicar",
            "Primary": "Principal",
            "Enabled": "Ativado",
            "Set as Primary": "Definir como principal",
            "Language:": "Idioma:",
            "System default": "Padrão do sistema",
            "Language changes apply immediately.": "As alterações de idioma são aplicadas imediatamente.",
            "Close": "Fechar",
            "Widget Settings": "Configurações do widget",
            "%1 monitor enabled": "%1 monitor ativado",
            "%1 monitors enabled": "%1 monitores ativados",
            "Show monitor count badge": "Mostrar emblema de contagem de monitores"
        },
        "ru_RU": {
            "Quick Display Change": "Быстрое переключение дисплея",
            "Display Configuration": "Настройки дисплея",
            "Refresh monitors": "Обновить мониторы",
            "Open Display Settings": "Открыть настройки дисплея",
            "Quick Layouts": "Быстрые раскладки",
            "Side by Side": "Рядом",
            "Extend Right": "Расширить вправо",
            "Extend Left": "Расширить влево",
            "Stacked": "Друг над другом",
            "Mirror": "Зеркало",
            "Primary Only": "Только основной",
            "Identify": "Определить",
            "Monitors": "Мониторы",
            "Layout Preview": "Предпросмотр раскладки",
            "Apply": "Применить",
            "Primary": "Основной",
            "Enabled": "Включён",
            "Set as Primary": "Сделать основным",
            "Language:": "Язык:",
            "System default": "По умолчанию системы",
            "Language changes apply immediately.": "Изменения языка применяются немедленно.",
            "Close": "Закрыть",
            "Widget Settings": "Настройки виджета",
            "%1 monitor enabled": "%1 монитор включён",
            "%1 monitors enabled": "%1 мониторов включено",
            "Show monitor count badge": "Показать значок количества мониторов"
        },
        "pl_PL": {
            "Quick Display Change": "Szybka zmiana wyświetlacza",
            "Display Configuration": "Konfiguracja wyświetlacza",
            "Refresh monitors": "Odśwież monitory",
            "Open Display Settings": "Otwórz ustawienia wyświetlacza",
            "Quick Layouts": "Szybkie układy",
            "Side by Side": "Obok siebie",
            "Extend Right": "Rozszerz w prawo",
            "Extend Left": "Rozszerz w lewo",
            "Stacked": "Jeden nad drugim",
            "Mirror": "Lustro",
            "Primary Only": "Tylko główny",
            "Identify": "Zidentyfikuj",
            "Monitors": "Monitory",
            "Layout Preview": "Podgląd układu",
            "Apply": "Zastosuj",
            "Primary": "Główny",
            "Enabled": "Włączony",
            "Set as Primary": "Ustaw jako główny",
            "Language:": "Język:",
            "System default": "Domyślny systemowy",
            "Language changes apply immediately.": "Zmiany języka są stosowane natychmiast.",
            "Close": "Zamknij",
            "Widget Settings": "Ustawienia widżetu",
            "%1 monitor enabled": "%1 monitor włączony",
            "%1 monitors enabled": "%1 monitorów włączonych",
            "Show monitor count badge": "Pokaż plakietkę liczby monitorów"
        },
        "nl_NL": {
            "Quick Display Change": "Snelle beeldschermwisseling",
            "Display Configuration": "Beeldschermconfiguratie",
            "Refresh monitors": "Monitoren vernieuwen",
            "Open Display Settings": "Beeldscherminstellingen openen",
            "Quick Layouts": "Snelle lay-outs",
            "Side by Side": "Naast elkaar",
            "Extend Right": "Uitbreiden naar rechts",
            "Extend Left": "Uitbreiden naar links",
            "Stacked": "Gestapeld",
            "Mirror": "Spiegelen",
            "Primary Only": "Alleen primair",
            "Identify": "Identificeren",
            "Monitors": "Monitoren",
            "Layout Preview": "Lay-outvoorbeeld",
            "Apply": "Toepassen",
            "Primary": "Primair",
            "Enabled": "Ingeschakeld",
            "Set as Primary": "Instellen als primair",
            "Language:": "Taal:",
            "System default": "Systeemstandaard",
            "Language changes apply immediately.": "Taalwijzigingen worden direct toegepast.",
            "Close": "Sluiten",
            "Widget Settings": "Widget-instellingen",
            "%1 monitor enabled": "%1 monitor ingeschakeld",
            "%1 monitors enabled": "%1 monitoren ingeschakeld",
            "Show monitor count badge": "Badge met aantal monitoren weergeven"
        },
        "tr_TR": {
            "Quick Display Change": "Hızlı Ekran Değiştirme",
            "Display Configuration": "Ekran Yapılandırması",
            "Refresh monitors": "Monitörleri yenile",
            "Open Display Settings": "Ekran Ayarlarını Aç",
            "Quick Layouts": "Hızlı Düzenler",
            "Side by Side": "Yan Yana",
            "Extend Right": "Sağa Genişlet",
            "Extend Left": "Sola Genişlet",
            "Stacked": "Üst Üste",
            "Mirror": "Yansıt",
            "Primary Only": "Yalnızca Birincil",
            "Identify": "Tanımla",
            "Monitors": "Monitörler",
            "Layout Preview": "Düzen Önizlemesi",
            "Apply": "Uygula",
            "Primary": "Birincil",
            "Enabled": "Etkin",
            "Set as Primary": "Birincil Olarak Ayarla",
            "Language:": "Dil:",
            "System default": "Sistem varsayılanı",
            "Language changes apply immediately.": "Dil değişiklikleri hemen uygulanır.",
            "Close": "Kapat",
            "Widget Settings": "Widget Ayarları",
            "%1 monitor enabled": "%1 monitör etkin",
            "%1 monitors enabled": "%1 monitör etkin",
            "Show monitor count badge": "Monitör sayısı rozetini göster"
        },
        "ja_JP": {
            "Quick Display Change": "クイックディスプレイ切替",
            "Display Configuration": "ディスプレイ設定",
            "Refresh monitors": "モニターを更新",
            "Open Display Settings": "ディスプレイ設定を開く",
            "Quick Layouts": "クイックレイアウト",
            "Side by Side": "横に並べる",
            "Extend Right": "右に拡張",
            "Extend Left": "左に拡張",
            "Stacked": "縦に並べる",
            "Mirror": "ミラー",
            "Primary Only": "プライマリのみ",
            "Identify": "識別",
            "Monitors": "モニター",
            "Layout Preview": "レイアウトプレビュー",
            "Apply": "適用",
            "Primary": "プライマリ",
            "Enabled": "有効",
            "Set as Primary": "プライマリに設定",
            "Language:": "言語:",
            "System default": "システムのデフォルト",
            "Language changes apply immediately.": "言語の変更は即座に適用されます。",
            "Close": "閉じる",
            "Widget Settings": "ウィジェット設定",
            "%1 monitor enabled": "%1台のモニターが有効",
            "%1 monitors enabled": "%1台のモニターが有効",
            "Show monitor count badge": "モニター数バッジを表示"
        },
        "ko_KR": {
            "Quick Display Change": "빠른 디스플레이 변경",
            "Display Configuration": "디스플레이 구성",
            "Refresh monitors": "모니터 새로고침",
            "Open Display Settings": "디스플레이 설정 열기",
            "Quick Layouts": "빠른 레이아웃",
            "Side by Side": "나란히",
            "Extend Right": "오른쪽으로 확장",
            "Extend Left": "왼쪽으로 확장",
            "Stacked": "위아래로",
            "Mirror": "미러",
            "Primary Only": "기본만",
            "Identify": "식별",
            "Monitors": "모니터",
            "Layout Preview": "레이아웃 미리보기",
            "Apply": "적용",
            "Primary": "기본",
            "Enabled": "활성화됨",
            "Set as Primary": "기본으로 설정",
            "Language:": "언어:",
            "System default": "시스템 기본값",
            "Language changes apply immediately.": "언어 변경이 즉시 적용됩니다.",
            "Close": "닫기",
            "Widget Settings": "위젯 설정",
            "%1 monitor enabled": "%1개 모니터 활성화",
            "%1 monitors enabled": "%1개 모니터 활성화",
            "Show monitor count badge": "모니터 개수 배지 표시"
        },
        "zh_CN": {
            "Quick Display Change": "快速显示切换",
            "Display Configuration": "显示配置",
            "Refresh monitors": "刷新显示器",
            "Open Display Settings": "打开显示设置",
            "Quick Layouts": "快速布局",
            "Side by Side": "并排",
            "Extend Right": "向右扩展",
            "Extend Left": "向左扩展",
            "Stacked": "堆叠",
            "Mirror": "镜像",
            "Primary Only": "仅主显示器",
            "Identify": "识别",
            "Monitors": "显示器",
            "Layout Preview": "布局预览",
            "Apply": "应用",
            "Primary": "主要",
            "Enabled": "已启用",
            "Set as Primary": "设为主显示器",
            "Language:": "语言:",
            "System default": "系统默认",
            "Language changes apply immediately.": "语言更改立即生效。",
            "Close": "关闭",
            "Widget Settings": "小部件设置",
            "%1 monitor enabled": "%1 个显示器已启用",
            "%1 monitors enabled": "%1 个显示器已启用",
            "Show monitor count badge": "显示显示器数量徽章"
        },
        "zh_TW": {
            "Quick Display Change": "快速顯示切換",
            "Display Configuration": "顯示配置",
            "Refresh monitors": "重新整理顯示器",
            "Open Display Settings": "開啟顯示設定",
            "Quick Layouts": "快速佈局",
            "Side by Side": "並排",
            "Extend Right": "向右延伸",
            "Extend Left": "向左延伸",
            "Stacked": "堆疊",
            "Mirror": "鏡像",
            "Primary Only": "僅主顯示器",
            "Identify": "識別",
            "Monitors": "顯示器",
            "Layout Preview": "佈局預覽",
            "Apply": "套用",
            "Primary": "主要",
            "Enabled": "已啟用",
            "Set as Primary": "設為主顯示器",
            "Language:": "語言:",
            "System default": "系統預設",
            "Language changes apply immediately.": "語言變更立即生效。",
            "Close": "關閉",
            "Widget Settings": "小工具設定",
            "%1 monitor enabled": "%1 個顯示器已啟用",
            "%1 monitors enabled": "%1 個顯示器已啟用",
            "Show monitor count badge": "顯示顯示器數量徽章"
        }
    })

    // Detect system language
    readonly property string systemLanguage: {
        let locale = Qt.locale().name; // e.g. "hu_HU", "en_US", "de_DE"
        return locale;
    }

    function getEffectiveLanguage() {
        if (currentLanguage === "system") {
            let sysLang = systemLanguage;
            // Try exact match first
            if (strings[sysLang]) {
                return sysLang;
            }
            // Try language code only (e.g. "hu" from "hu_HU")
            let langCode = sysLang.split("_")[0];
            for (let key in strings) {
                if (key.startsWith(langCode + "_")) {
                    return key;
                }
            }
            // Default to English
            return "en_US";
        }
        return currentLanguage;
    }

    function tr(text) {
        // Use version to force re-evaluation (dummy read)
        let v = version;
        let lang = getEffectiveLanguage();

        if (strings[lang] && strings[lang][text]) {
            return strings[lang][text];
        }
        // Fallback to English
        if (strings["en_US"] && strings["en_US"][text]) {
            return strings["en_US"][text];
        }
        // Return original text if not found
        return text;
    }

    function trn(singular, plural, count) {
        let text = count === 1 ? singular : plural;
        return tr(text).replace("%1", count);
    }
}
