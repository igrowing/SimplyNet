#!/usr/bin/env python3
"""Generate SimplyNet ARB localization files from a single translation table.

The ARB files under lib/l10n are the committed source of truth consumed by
`flutter gen-l10n`; this script keeps all 16 locales in sync as keys are added.
Run:  python3 tools/gen_l10n_arb.py   then:  flutter gen-l10n
"""
import json
import os

# Locale order for output files. 'en' is the template. 'zh' is the required
# base fallback for the zh_Hans / zh_Hant script variants (mirrors zh_Hans).
LOCALES = [
    "en", "it", "es", "de", "pt", "fr", "zh_Hans", "zh_Hant",
    "ja", "th", "ru", "uk", "pl", "cs", "ko", "hi",
]

# key -> {locale: translation}. Technical tokens (MQTT, IP, DNS, WHOIS, mDNS,
# TCP/UDP, MAC, CIDR, Wi-Fi, LAN, ISP, Matter, Tasmota, Shelly, Ping,
# Traceroute, Android, Google) are intentionally kept untranslated.
T = {
    "settingsTitle": {
        "en": "Settings", "it": "Impostazioni", "es": "Ajustes",
        "de": "Einstellungen", "pt": "Definições", "fr": "Paramètres",
        "zh_Hans": "设置", "zh_Hant": "設定", "ja": "設定", "th": "การตั้งค่า",
        "ru": "Настройки", "uk": "Налаштування", "pl": "Ustawienia",
        "cs": "Nastavení", "ko": "설정", "hi": "सेटिंग्स",
    },
    "appearance": {
        "en": "Appearance", "it": "Aspetto", "es": "Apariencia",
        "de": "Darstellung", "pt": "Aparência", "fr": "Apparence",
        "zh_Hans": "外观", "zh_Hant": "外觀", "ja": "外観", "th": "ลักษณะ",
        "ru": "Оформление", "uk": "Оформлення", "pl": "Wygląd",
        "cs": "Vzhled", "ko": "화면", "hi": "दिखावट",
    },
    "language": {
        "en": "Language", "it": "Lingua", "es": "Idioma", "de": "Sprache",
        "pt": "Idioma", "fr": "Langue", "zh_Hans": "语言", "zh_Hant": "語言",
        "ja": "言語", "th": "ภาษา", "ru": "Язык", "uk": "Мова",
        "pl": "Język", "cs": "Jazyk", "ko": "언어", "hi": "भाषा",
    },
    "theme": {
        "en": "Theme", "it": "Tema", "es": "Tema", "de": "Design",
        "pt": "Tema", "fr": "Thème", "zh_Hans": "主题", "zh_Hant": "主題",
        "ja": "テーマ", "th": "ธีม", "ru": "Тема", "uk": "Тема",
        "pl": "Motyw", "cs": "Motiv", "ko": "테마", "hi": "थीम",
    },
    "themeLight": {
        "en": "Light", "it": "Chiaro", "es": "Claro", "de": "Hell",
        "pt": "Claro", "fr": "Clair", "zh_Hans": "浅色", "zh_Hant": "淺色",
        "ja": "ライト", "th": "สว่าง", "ru": "Светлая", "uk": "Світла",
        "pl": "Jasny", "cs": "Světlý", "ko": "밝게", "hi": "हल्का",
    },
    "themeDark": {
        "en": "Dark", "it": "Scuro", "es": "Oscuro", "de": "Dunkel",
        "pt": "Escuro", "fr": "Sombre", "zh_Hans": "深色", "zh_Hant": "深色",
        "ja": "ダーク", "th": "มืด", "ru": "Тёмная", "uk": "Темна",
        "pl": "Ciemny", "cs": "Tmavý", "ko": "어둡게", "hi": "गहरा",
    },
    "themeAuto": {
        "en": "Auto", "it": "Auto", "es": "Auto", "de": "Auto",
        "pt": "Auto", "fr": "Auto", "zh_Hans": "自动", "zh_Hant": "自動",
        "ja": "自動", "th": "อัตโนมัติ", "ru": "Авто", "uk": "Авто",
        "pl": "Auto", "cs": "Auto", "ko": "자동", "hi": "स्वतः",
    },
    "screenOnTimeout": {
        "en": "Screen On Timeout", "it": "Timeout schermo acceso",
        "es": "Tiempo de pantalla encendida", "de": "Bildschirm-Timeout",
        "pt": "Tempo de ecrã ligado", "fr": "Délai d'écran allumé",
        "zh_Hans": "屏幕常亮超时", "zh_Hant": "螢幕常亮逾時",
        "ja": "画面点灯タイムアウト", "th": "หมดเวลาเปิดหน้าจอ",
        "ru": "Тайм-аут экрана", "uk": "Тайм-аут екрана",
        "pl": "Limit czasu ekranu", "cs": "Časový limit obrazovky",
        "ko": "화면 켜짐 시간", "hi": "स्क्रीन चालू टाइमआउट",
    },
    "timeoutSystem": {
        "en": "System", "it": "Sistema", "es": "Sistema", "de": "System",
        "pt": "Sistema", "fr": "Système", "zh_Hans": "系统", "zh_Hant": "系統",
        "ja": "システム", "th": "ระบบ", "ru": "Системный", "uk": "Системний",
        "pl": "Systemowy", "cs": "Systém", "ko": "시스템", "hi": "सिस्टम",
    },
    "timeoutTriple": {
        "en": "3× System", "it": "3× Sistema", "es": "3× Sistema",
        "de": "3× System", "pt": "3× Sistema", "fr": "3× Système",
        "zh_Hans": "3× 系统", "zh_Hant": "3× 系統", "ja": "3× システム",
        "th": "3× ระบบ", "ru": "3× системный", "uk": "3× системний",
        "pl": "3× systemowy", "cs": "3× systém", "ko": "3× 시스템",
        "hi": "3× सिस्टम",
    },
    "timeoutStayOn": {
        "en": "Stay On", "it": "Sempre acceso", "es": "Siempre encendida",
        "de": "An lassen", "pt": "Manter ligado", "fr": "Rester allumé",
        "zh_Hans": "保持常亮", "zh_Hant": "保持常亮", "ja": "常時点灯",
        "th": "เปิดตลอด", "ru": "Не гаснет", "uk": "Не гасне",
        "pl": "Zawsze wł.", "cs": "Nechat zapnuté", "ko": "항상 켜짐",
        "hi": "चालू रखें",
    },
    "scanning": {
        "en": "Scanning", "it": "Scansione", "es": "Escaneo",
        "de": "Scannen", "pt": "Análise", "fr": "Analyse",
        "zh_Hans": "扫描", "zh_Hant": "掃描", "ja": "スキャン",
        "th": "การสแกน", "ru": "Сканирование", "uk": "Сканування",
        "pl": "Skanowanie", "cs": "Skenování", "ko": "스캔", "hi": "स्कैनिंग",
    },
    "showMacAddress": {
        "en": "Show MAC Address", "it": "Mostra indirizzo MAC",
        "es": "Mostrar dirección MAC", "de": "MAC-Adresse anzeigen",
        "pt": "Mostrar endereço MAC", "fr": "Afficher l'adresse MAC",
        "zh_Hans": "显示 MAC 地址", "zh_Hant": "顯示 MAC 位址",
        "ja": "MAC アドレスを表示", "th": "แสดงที่อยู่ MAC",
        "ru": "Показывать MAC-адрес", "uk": "Показувати MAC-адресу",
        "pl": "Pokaż adres MAC", "cs": "Zobrazit adresu MAC",
        "ko": "MAC 주소 표시", "hi": "MAC पता दिखाएं",
    },
    "showMacBlocked": {
        "en": "Disabled on Android v.11 and up due to Google privacy concerns",
        "it": "Disabilitato su Android v.11 e successivi per motivi di privacy di Google",
        "es": "Desactivado en Android v.11 y superior por motivos de privacidad de Google",
        "de": "Auf Android v.11 und höher aufgrund von Googles Datenschutz deaktiviert",
        "pt": "Desativado no Android v.11 e superior devido a preocupações de privacidade da Google",
        "fr": "Désactivé sur Android v.11 et plus pour des raisons de confidentialité de Google",
        "zh_Hans": "由于 Google 隐私限制，在 Android v.11 及以上版本停用",
        "zh_Hant": "由於 Google 隱私限制，在 Android v.11 及以上版本停用",
        "ja": "Google のプライバシー上の理由により Android v.11 以降では無効です",
        "th": "ปิดใช้งานบน Android v.11 ขึ้นไปเนื่องจากความเป็นส่วนตัวของ Google",
        "ru": "Отключено на Android v.11 и выше из-за политики конфиденциальности Google",
        "uk": "Вимкнено на Android v.11 і вище через політику конфіденційності Google",
        "pl": "Wyłączone w Androidzie v.11 i nowszym ze względu na prywatność Google",
        "cs": "Zakázáno na Androidu v.11 a novějším kvůli ochraně soukromí Google",
        "ko": "Google 개인정보 보호 정책으로 인해 Android v.11 이상에서 비활성화됨",
        "hi": "Google गोपनीयता कारणों से Android v.11 और उससे ऊपर पर अक्षम",
    },
    "showMacSubtitle": {
        "en": "Display MAC column in scan results",
        "it": "Mostra la colonna MAC nei risultati della scansione",
        "es": "Mostrar la columna MAC en los resultados del escaneo",
        "de": "MAC-Spalte in den Scanergebnissen anzeigen",
        "pt": "Mostrar a coluna MAC nos resultados da análise",
        "fr": "Afficher la colonne MAC dans les résultats d'analyse",
        "zh_Hans": "在扫描结果中显示 MAC 列",
        "zh_Hant": "在掃描結果中顯示 MAC 欄",
        "ja": "スキャン結果に MAC 列を表示", "th": "แสดงคอลัมน์ MAC ในผลการสแกน",
        "ru": "Показывать столбец MAC в результатах сканирования",
        "uk": "Показувати стовпець MAC у результатах сканування",
        "pl": "Pokaż kolumnę MAC w wynikach skanowania",
        "cs": "Zobrazit sloupec MAC ve výsledcích skenování",
        "ko": "스캔 결과에 MAC 열 표시", "hi": "स्कैन परिणामों में MAC कॉलम दिखाएं",
    },
    "resolveHostnames": {
        "en": "Resolve Hostnames", "it": "Risolvi nomi host",
        "es": "Resolver nombres de host", "de": "Hostnamen auflösen",
        "pt": "Resolver nomes de host", "fr": "Résoudre les noms d'hôte",
        "zh_Hans": "解析主机名", "zh_Hant": "解析主機名稱",
        "ja": "ホスト名を解決", "th": "แปลงชื่อโฮสต์",
        "ru": "Определять имена узлов", "uk": "Визначати імена вузлів",
        "pl": "Rozwiązuj nazwy hostów", "cs": "Překládat názvy hostitelů",
        "ko": "호스트 이름 확인", "hi": "होस्टनाम हल करें",
    },
    "resolveHostnamesSubtitle": {
        "en": "Perform reverse-DNS + mDNS during scan",
        "it": "Esegui DNS inverso + mDNS durante la scansione",
        "es": "Realizar DNS inverso + mDNS durante el escaneo",
        "de": "Reverse-DNS + mDNS während des Scans durchführen",
        "pt": "Efetuar DNS inverso + mDNS durante a análise",
        "fr": "Effectuer un DNS inversé + mDNS pendant l'analyse",
        "zh_Hans": "扫描时执行反向 DNS + mDNS",
        "zh_Hant": "掃描時執行反向 DNS + mDNS",
        "ja": "スキャン中に逆引き DNS + mDNS を実行",
        "th": "ทำ reverse-DNS + mDNS ระหว่างสแกน",
        "ru": "Выполнять обратный DNS + mDNS при сканировании",
        "uk": "Виконувати зворотний DNS + mDNS під час сканування",
        "pl": "Wykonaj odwrotny DNS + mDNS podczas skanowania",
        "cs": "Provádět reverzní DNS + mDNS během skenování",
        "ko": "스캔 중 역방향 DNS + mDNS 수행",
        "hi": "स्कैन के दौरान रिवर्स-DNS + mDNS करें",
    },
    "enableLogging": {
        "en": "Enable Logging", "it": "Abilita registro",
        "es": "Activar registro", "de": "Protokollierung aktivieren",
        "pt": "Ativar registo", "fr": "Activer la journalisation",
        "zh_Hans": "启用日志", "zh_Hant": "啟用日誌", "ja": "ログを有効化",
        "th": "เปิดใช้บันทึก", "ru": "Включить журнал",
        "uk": "Увімкнути журнал", "pl": "Włącz dziennik",
        "cs": "Povolit protokolování", "ko": "로깅 사용", "hi": "लॉगिंग सक्षम करें",
    },
    "enableLoggingSubtitle": {
        "en": "Save scan and tool output to log files",
        "it": "Salva l'output di scansioni e strumenti su file di log",
        "es": "Guardar la salida de escaneos y herramientas en archivos de registro",
        "de": "Scan- und Tool-Ausgabe in Protokolldateien speichern",
        "pt": "Guardar a saída de análises e ferramentas em ficheiros de registo",
        "fr": "Enregistrer la sortie des analyses et outils dans des fichiers journaux",
        "zh_Hans": "将扫描和工具输出保存到日志文件",
        "zh_Hant": "將掃描與工具輸出儲存到日誌檔",
        "ja": "スキャンとツールの出力をログファイルに保存",
        "th": "บันทึกผลการสแกนและเครื่องมือลงไฟล์บันทึก",
        "ru": "Сохранять вывод сканирования и инструментов в файлы журнала",
        "uk": "Зберігати вивід сканування та інструментів у файли журналу",
        "pl": "Zapisuj wynik skanowania i narzędzi do plików dziennika",
        "cs": "Ukládat výstup skenování a nástrojů do souborů protokolu",
        "ko": "스캔 및 도구 출력을 로그 파일에 저장",
        "hi": "स्कैन और टूल आउटपुट को लॉग फ़ाइलों में सहेजें",
    },
    "account": {
        "en": "Account", "it": "Account", "es": "Cuenta", "de": "Konto",
        "pt": "Conta", "fr": "Compte", "zh_Hans": "账户", "zh_Hant": "帳戶",
        "ja": "アカウント", "th": "บัญชี", "ru": "Аккаунт", "uk": "Обліковий запис",
        "pl": "Konto", "cs": "Účet", "ko": "계정", "hi": "खाता",
    },
    "logIn": {
        "en": "Log In", "it": "Accedi", "es": "Iniciar sesión",
        "de": "Anmelden", "pt": "Iniciar sessão", "fr": "Se connecter",
        "zh_Hans": "登录", "zh_Hant": "登入", "ja": "ログイン",
        "th": "เข้าสู่ระบบ", "ru": "Войти", "uk": "Увійти",
        "pl": "Zaloguj się", "cs": "Přihlásit se", "ko": "로그인", "hi": "लॉग इन",
    },
    "comingSoon": {
        "en": "Coming soon", "it": "Prossimamente", "es": "Próximamente",
        "de": "Demnächst", "pt": "Em breve", "fr": "Bientôt disponible",
        "zh_Hans": "即将推出", "zh_Hant": "即將推出", "ja": "近日公開",
        "th": "เร็ว ๆ นี้", "ru": "Скоро", "uk": "Незабаром",
        "pl": "Wkrótce", "cs": "Již brzy", "ko": "곧 제공 예정", "hi": "जल्द आ रहा है",
    },
    "settings": {
        "en": "Settings", "it": "Impostazioni", "es": "Ajustes",
        "de": "Einstellungen", "pt": "Definições", "fr": "Paramètres",
        "zh_Hans": "设置", "zh_Hant": "設定", "ja": "設定", "th": "การตั้งค่า",
        "ru": "Настройки", "uk": "Налаштування", "pl": "Ustawienia",
        "cs": "Nastavení", "ko": "설정", "hi": "सेटिंग्स",
    },
    "aboutSimplyNet": {
        "en": "About SimplyNet", "it": "Informazioni su SimplyNet",
        "es": "Acerca de SimplyNet", "de": "Über SimplyNet",
        "pt": "Sobre o SimplyNet", "fr": "À propos de SimplyNet",
        "zh_Hans": "关于 SimplyNet", "zh_Hant": "關於 SimplyNet",
        "ja": "SimplyNet について", "th": "เกี่ยวกับ SimplyNet",
        "ru": "О SimplyNet", "uk": "Про SimplyNet", "pl": "O SimplyNet",
        "cs": "O aplikaci SimplyNet", "ko": "SimplyNet 정보", "hi": "SimplyNet के बारे में",
    },
    "scan": {
        "en": "Scan", "it": "Scansione", "es": "Escanear", "de": "Scannen",
        "pt": "Analisar", "fr": "Analyser", "zh_Hans": "扫描", "zh_Hant": "掃描",
        "ja": "スキャン", "th": "สแกน", "ru": "Сканировать", "uk": "Сканувати",
        "pl": "Skanuj", "cs": "Skenovat", "ko": "스캔", "hi": "स्कैन",
    },
    "logs": {
        "en": "Logs", "it": "Registri", "es": "Registros", "de": "Protokolle",
        "pt": "Registos", "fr": "Journaux", "zh_Hans": "日志", "zh_Hant": "日誌",
        "ja": "ログ", "th": "บันทึก", "ru": "Журналы", "uk": "Журнали",
        "pl": "Dzienniki", "cs": "Protokoly", "ko": "로그", "hi": "लॉग",
    },
    "networkTools": {
        "en": "Network Tools", "it": "Strumenti di rete",
        "es": "Herramientas de red", "de": "Netzwerk-Tools",
        "pt": "Ferramentas de rede", "fr": "Outils réseau",
        "zh_Hans": "网络工具", "zh_Hant": "網路工具", "ja": "ネットワークツール",
        "th": "เครื่องมือเครือข่าย", "ru": "Сетевые инструменты",
        "uk": "Мережеві інструменти", "pl": "Narzędzia sieciowe",
        "cs": "Síťové nástroje", "ko": "네트워크 도구", "hi": "नेटवर्क टूल",
    },
    "networkTarget": {
        "en": "Network Target", "it": "Destinazione di rete",
        "es": "Objetivo de red", "de": "Netzwerkziel",
        "pt": "Alvo de rede", "fr": "Cible réseau",
        "zh_Hans": "网络目标", "zh_Hant": "網路目標", "ja": "ネットワーク対象",
        "th": "เป้าหมายเครือข่าย", "ru": "Цель сети", "uk": "Ціль мережі",
        "pl": "Cel sieci", "cs": "Cíl sítě", "ko": "네트워크 대상", "hi": "नेटवर्क लक्ष्य",
    },
    "networkTargetHint": {
        "en": "e.g. 192.168.1.0/24", "it": "es. 192.168.1.0/24",
        "es": "p. ej. 192.168.1.0/24", "de": "z. B. 192.168.1.0/24",
        "pt": "ex. 192.168.1.0/24", "fr": "ex. 192.168.1.0/24",
        "zh_Hans": "例如 192.168.1.0/24", "zh_Hant": "例如 192.168.1.0/24",
        "ja": "例: 192.168.1.0/24", "th": "เช่น 192.168.1.0/24",
        "ru": "напр. 192.168.1.0/24", "uk": "напр. 192.168.1.0/24",
        "pl": "np. 192.168.1.0/24", "cs": "např. 192.168.1.0/24",
        "ko": "예: 192.168.1.0/24", "hi": "उदा. 192.168.1.0/24",
    },
    "invalidCidr": {
        "en": "Invalid CIDR — use format like 192.168.1.0/24",
        "it": "CIDR non valido — usa un formato come 192.168.1.0/24",
        "es": "CIDR no válido — usa un formato como 192.168.1.0/24",
        "de": "Ungültiges CIDR — Format wie 192.168.1.0/24 verwenden",
        "pt": "CIDR inválido — use um formato como 192.168.1.0/24",
        "fr": "CIDR non valide — utilisez un format comme 192.168.1.0/24",
        "zh_Hans": "无效的 CIDR — 请使用如 192.168.1.0/24 的格式",
        "zh_Hant": "無效的 CIDR — 請使用如 192.168.1.0/24 的格式",
        "ja": "無効な CIDR — 192.168.1.0/24 の形式を使用してください",
        "th": "CIDR ไม่ถูกต้อง — ใช้รูปแบบเช่น 192.168.1.0/24",
        "ru": "Неверный CIDR — используйте формат вида 192.168.1.0/24",
        "uk": "Недійсний CIDR — використовуйте формат на кшталт 192.168.1.0/24",
        "pl": "Nieprawidłowy CIDR — użyj formatu takiego jak 192.168.1.0/24",
        "cs": "Neplatný CIDR — použijte formát jako 192.168.1.0/24",
        "ko": "잘못된 CIDR — 192.168.1.0/24 형식을 사용하세요",
        "hi": "अमान्य CIDR — 192.168.1.0/24 जैसे प्रारूप का उपयोग करें",
    },
    "detectMyNetwork": {
        "en": "Detect my network", "it": "Rileva la mia rete",
        "es": "Detectar mi red", "de": "Mein Netzwerk erkennen",
        "pt": "Detetar a minha rede", "fr": "Détecter mon réseau",
        "zh_Hans": "检测我的网络", "zh_Hant": "偵測我的網路",
        "ja": "自分のネットワークを検出", "th": "ตรวจหาเครือข่ายของฉัน",
        "ru": "Определить мою сеть", "uk": "Визначити мою мережу",
        "pl": "Wykryj moją sieć", "cs": "Zjistit moji síť",
        "ko": "내 네트워크 감지", "hi": "मेरा नेटवर्क पहचानें",
    },
    "toolSpeedTest": {
        "en": "Speed Test", "it": "Test velocità", "es": "Prueba de velocidad",
        "de": "Geschwindigkeitstest", "pt": "Teste de velocidade",
        "fr": "Test de débit", "zh_Hans": "速度测试", "zh_Hant": "速度測試",
        "ja": "速度テスト", "th": "ทดสอบความเร็ว", "ru": "Тест скорости",
        "uk": "Тест швидкості", "pl": "Test prędkości", "cs": "Test rychlosti",
        "ko": "속도 테스트", "hi": "स्पीड टेस्ट",
    },
    "toolSpeedTestSub": {
        "en": "Download & upload speed", "it": "Velocità di download e upload",
        "es": "Velocidad de bajada y subida",
        "de": "Download- & Upload-Geschwindigkeit",
        "pt": "Velocidade de download e upload",
        "fr": "Débit descendant et montant", "zh_Hans": "下载和上传速度",
        "zh_Hant": "下載與上傳速度", "ja": "ダウンロード・アップロード速度",
        "th": "ความเร็วดาวน์โหลดและอัปโหลด", "ru": "Скорость загрузки и отдачи",
        "uk": "Швидкість завантаження й віддачі",
        "pl": "Prędkość pobierania i wysyłania",
        "cs": "Rychlost stahování a odesílání", "ko": "다운로드 및 업로드 속도",
        "hi": "डाउनलोड और अपलोड गति",
    },
    "toolPublicIp": {
        "en": "Public IP", "it": "IP pubblico", "es": "IP pública",
        "de": "Öffentliche IP", "pt": "IP público", "fr": "IP publique",
        "zh_Hans": "公网 IP", "zh_Hant": "公用 IP", "ja": "パブリック IP",
        "th": "IP สาธารณะ", "ru": "Публичный IP", "uk": "Публічний IP",
        "pl": "Publiczny IP", "cs": "Veřejná IP", "ko": "공용 IP", "hi": "सार्वजनिक IP",
    },
    "toolPublicIpSub": {
        "en": "Your IP, ISP & location", "it": "Il tuo IP, ISP e posizione",
        "es": "Tu IP, ISP y ubicación", "de": "Deine IP, ISP & Standort",
        "pt": "O seu IP, ISP e localização", "fr": "Votre IP, FAI et localisation",
        "zh_Hans": "您的 IP、ISP 和位置", "zh_Hant": "您的 IP、ISP 與位置",
        "ja": "あなたの IP、ISP、位置", "th": "IP, ISP และตำแหน่งของคุณ",
        "ru": "Ваш IP, провайдер и местоположение",
        "uk": "Ваш IP, провайдер і місцезнаходження",
        "pl": "Twój IP, ISP i lokalizacja", "cs": "Vaše IP, ISP a poloha",
        "ko": "내 IP, ISP 및 위치", "hi": "आपका IP, ISP और स्थान",
    },
    "toolIpCameras": {
        "en": "IP Cameras", "it": "Telecamere IP", "es": "Cámaras IP",
        "de": "IP-Kameras", "pt": "Câmaras IP", "fr": "Caméras IP",
        "zh_Hans": "IP 摄像头", "zh_Hant": "IP 攝影機", "ja": "IP カメラ",
        "th": "กล้อง IP", "ru": "IP-камеры", "uk": "IP-камери",
        "pl": "Kamery IP", "cs": "IP kamery", "ko": "IP 카메라", "hi": "IP कैमरे",
    },
    "toolIpCamerasSub": {
        "en": "Find cameras on your LAN", "it": "Trova telecamere nella tua LAN",
        "es": "Encuentra cámaras en tu LAN", "de": "Kameras im LAN finden",
        "pt": "Encontrar câmaras na sua LAN", "fr": "Trouver des caméras sur votre LAN",
        "zh_Hans": "查找局域网中的摄像头", "zh_Hant": "尋找區域網路中的攝影機",
        "ja": "LAN 上のカメラを検索", "th": "ค้นหากล้องใน LAN ของคุณ",
        "ru": "Найти камеры в вашей сети", "uk": "Знайти камери у вашій мережі",
        "pl": "Znajdź kamery w sieci LAN", "cs": "Najít kamery v síti LAN",
        "ko": "LAN에서 카메라 찾기", "hi": "अपने LAN पर कैमरे खोजें",
    },
    "toolIotDevices": {
        "en": "IoT Devices", "it": "Dispositivi IoT", "es": "Dispositivos IoT",
        "de": "IoT-Geräte", "pt": "Dispositivos IoT", "fr": "Appareils IoT",
        "zh_Hans": "IoT 设备", "zh_Hant": "IoT 裝置", "ja": "IoT デバイス",
        "th": "อุปกรณ์ IoT", "ru": "Устройства IoT", "uk": "Пристрої IoT",
        "pl": "Urządzenia IoT", "cs": "Zařízení IoT", "ko": "IoT 기기", "hi": "IoT डिवाइस",
    },
    "toolIotDevicesSub": {
        "en": "Matter, Tasmota, Shelly & more",
        "it": "Matter, Tasmota, Shelly e altri",
        "es": "Matter, Tasmota, Shelly y más",
        "de": "Matter, Tasmota, Shelly & mehr",
        "pt": "Matter, Tasmota, Shelly e mais",
        "fr": "Matter, Tasmota, Shelly et plus",
        "zh_Hans": "Matter、Tasmota、Shelly 等",
        "zh_Hant": "Matter、Tasmota、Shelly 等", "ja": "Matter、Tasmota、Shelly など",
        "th": "Matter, Tasmota, Shelly และอื่น ๆ",
        "ru": "Matter, Tasmota, Shelly и другие",
        "uk": "Matter, Tasmota, Shelly та інші",
        "pl": "Matter, Tasmota, Shelly i inne",
        "cs": "Matter, Tasmota, Shelly a další", "ko": "Matter, Tasmota, Shelly 등",
        "hi": "Matter, Tasmota, Shelly और अन्य",
    },
    "toolMqttSub": {
        "en": "MQTT Sub", "it": "MQTT Sub", "es": "MQTT Sub", "de": "MQTT Sub",
        "pt": "MQTT Sub", "fr": "MQTT Sub", "zh_Hans": "MQTT 订阅",
        "zh_Hant": "MQTT 訂閱", "ja": "MQTT 購読", "th": "MQTT Sub",
        "ru": "MQTT-подписка", "uk": "MQTT-підписка", "pl": "MQTT Sub",
        "cs": "MQTT Sub", "ko": "MQTT 구독", "hi": "MQTT Sub",
    },
    "toolMqttSubSub": {
        "en": "Subscribe to an MQTT topic", "it": "Iscriviti a un topic MQTT",
        "es": "Suscribirse a un topic MQTT", "de": "Ein MQTT-Topic abonnieren",
        "pt": "Subscrever um tópico MQTT", "fr": "S'abonner à un topic MQTT",
        "zh_Hans": "订阅 MQTT 主题", "zh_Hant": "訂閱 MQTT 主題",
        "ja": "MQTT トピックを購読", "th": "สมัครรับ MQTT topic",
        "ru": "Подписаться на топик MQTT", "uk": "Підписатися на топік MQTT",
        "pl": "Subskrybuj temat MQTT", "cs": "Přihlásit odběr tématu MQTT",
        "ko": "MQTT 토픽 구독", "hi": "MQTT टॉपिक की सदस्यता लें",
    },
    "toolMqttPub": {
        "en": "MQTT Pub", "it": "MQTT Pub", "es": "MQTT Pub", "de": "MQTT Pub",
        "pt": "MQTT Pub", "fr": "MQTT Pub", "zh_Hans": "MQTT 发布",
        "zh_Hant": "MQTT 發佈", "ja": "MQTT 発行", "th": "MQTT Pub",
        "ru": "MQTT-публикация", "uk": "MQTT-публікація", "pl": "MQTT Pub",
        "cs": "MQTT Pub", "ko": "MQTT 발행", "hi": "MQTT Pub",
    },
    "toolMqttPubSub": {
        "en": "Publish to an MQTT topic", "it": "Pubblica su un topic MQTT",
        "es": "Publicar en un topic MQTT", "de": "In ein MQTT-Topic veröffentlichen",
        "pt": "Publicar num tópico MQTT", "fr": "Publier sur un topic MQTT",
        "zh_Hans": "发布到 MQTT 主题", "zh_Hant": "發佈到 MQTT 主題",
        "ja": "MQTT トピックに発行", "th": "เผยแพร่ไปยัง MQTT topic",
        "ru": "Опубликовать в топик MQTT", "uk": "Опублікувати в топік MQTT",
        "pl": "Publikuj w temacie MQTT", "cs": "Publikovat do tématu MQTT",
        "ko": "MQTT 토픽에 발행", "hi": "MQTT टॉपिक पर प्रकाशित करें",
    },
    "toolPortScan": {
        "en": "Port Scan", "it": "Scansione porte", "es": "Escaneo de puertos",
        "de": "Port-Scan", "pt": "Análise de portas", "fr": "Scan de ports",
        "zh_Hans": "端口扫描", "zh_Hant": "連接埠掃描", "ja": "ポートスキャン",
        "th": "สแกนพอร์ต", "ru": "Скан портов", "uk": "Сканування портів",
        "pl": "Skan portów", "cs": "Sken portů", "ko": "포트 스캔", "hi": "पोर्ट स्कैन",
    },
    "toolPortScanSub": {
        "en": "Open TCP/UDP ports on any host",
        "it": "Porte TCP/UDP aperte su qualsiasi host",
        "es": "Puertos TCP/UDP abiertos en cualquier host",
        "de": "Offene TCP/UDP-Ports auf jedem Host",
        "pt": "Portas TCP/UDP abertas em qualquer host",
        "fr": "Ports TCP/UDP ouverts sur n'importe quel hôte",
        "zh_Hans": "任意主机的开放 TCP/UDP 端口",
        "zh_Hant": "任意主機的開放 TCP/UDP 連接埠",
        "ja": "任意のホストの開いている TCP/UDP ポート",
        "th": "พอร์ต TCP/UDP ที่เปิดบนโฮสต์ใด ๆ",
        "ru": "Открытые порты TCP/UDP на любом узле",
        "uk": "Відкриті порти TCP/UDP на будь-якому вузлі",
        "pl": "Otwarte porty TCP/UDP na dowolnym hoście",
        "cs": "Otevřené porty TCP/UDP na libovolném hostiteli",
        "ko": "모든 호스트의 열린 TCP/UDP 포트",
        "hi": "किसी भी होस्ट पर खुले TCP/UDP पोर्ट",
    },
    "toolPing": {
        "en": "Ping", "it": "Ping", "es": "Ping", "de": "Ping", "pt": "Ping",
        "fr": "Ping", "zh_Hans": "Ping", "zh_Hant": "Ping", "ja": "Ping",
        "th": "Ping", "ru": "Ping", "uk": "Ping", "pl": "Ping", "cs": "Ping",
        "ko": "Ping", "hi": "Ping",
    },
    "toolPingSub": {
        "en": "Live ping with graph", "it": "Ping in tempo reale con grafico",
        "es": "Ping en vivo con gráfico", "de": "Live-Ping mit Diagramm",
        "pt": "Ping em tempo real com gráfico", "fr": "Ping en direct avec graphique",
        "zh_Hans": "带图表的实时 Ping", "zh_Hant": "帶圖表的即時 Ping",
        "ja": "グラフ付きライブ Ping", "th": "Ping สดพร้อมกราฟ",
        "ru": "Ping в реальном времени с графиком",
        "uk": "Ping у реальному часі з графіком",
        "pl": "Ping na żywo z wykresem", "cs": "Živý ping s grafem",
        "ko": "그래프가 있는 실시간 Ping", "hi": "ग्राफ़ के साथ लाइव Ping",
    },
    "toolTraceroute": {
        "en": "Traceroute", "it": "Traceroute", "es": "Traceroute",
        "de": "Traceroute", "pt": "Traceroute", "fr": "Traceroute",
        "zh_Hans": "路由跟踪", "zh_Hant": "路由追蹤", "ja": "Traceroute",
        "th": "Traceroute", "ru": "Traceroute", "uk": "Traceroute",
        "pl": "Traceroute", "cs": "Traceroute", "ko": "Traceroute", "hi": "Traceroute",
    },
    "toolTracerouteSub": {
        "en": "Hop-by-hop path to any host",
        "it": "Percorso salto per salto verso un host",
        "es": "Ruta salto a salto a cualquier host",
        "de": "Hop-für-Hop-Pfad zu jedem Host",
        "pt": "Caminho salto a salto até qualquer host",
        "fr": "Chemin saut par saut vers n'importe quel hôte",
        "zh_Hans": "到任意主机的逐跳路径",
        "zh_Hant": "到任意主機的逐跳路徑",
        "ja": "任意のホストへのホップごとの経路",
        "th": "เส้นทางทีละ hop ไปยังโฮสต์ใด ๆ",
        "ru": "Пошаговый маршрут до любого узла",
        "uk": "Покроковий маршрут до будь-якого вузла",
        "pl": "Ścieżka skok po skoku do dowolnego hosta",
        "cs": "Cesta skok po skoku k libovolnému hostiteli",
        "ko": "모든 호스트로의 홉별 경로",
        "hi": "किसी भी होस्ट तक hop-दर-hop पथ",
    },
    "toolWhois": {
        "en": "Who Is…", "it": "Chi è…", "es": "Quién es…",
        "de": "Who Is…", "pt": "Quem é…", "fr": "Who Is…",
        "zh_Hans": "Who Is…", "zh_Hant": "Who Is…", "ja": "Who Is…",
        "th": "Who Is…", "ru": "Who Is…", "uk": "Who Is…",
        "pl": "Who Is…", "cs": "Who Is…", "ko": "Who Is…", "hi": "Who Is…",
    },
    "toolWhoisSub": {
        "en": "WHOIS, DNS & reverse lookup", "it": "WHOIS, DNS e ricerca inversa",
        "es": "WHOIS, DNS y búsqueda inversa", "de": "WHOIS, DNS & Reverse-Lookup",
        "pt": "WHOIS, DNS e pesquisa inversa", "fr": "WHOIS, DNS et recherche inversée",
        "zh_Hans": "WHOIS、DNS 和反向查询", "zh_Hant": "WHOIS、DNS 與反向查詢",
        "ja": "WHOIS、DNS、逆引き", "th": "WHOIS, DNS และค้นหาย้อนกลับ",
        "ru": "WHOIS, DNS и обратный поиск", "uk": "WHOIS, DNS та зворотний пошук",
        "pl": "WHOIS, DNS i wyszukiwanie wsteczne", "cs": "WHOIS, DNS a zpětné vyhledávání",
        "ko": "WHOIS, DNS 및 역방향 조회", "hi": "WHOIS, DNS और रिवर्स लुकअप",
    },
    "toolWifiChannels": {
        "en": "Wi-Fi Channels", "it": "Canali Wi-Fi", "es": "Canales Wi-Fi",
        "de": "WLAN-Kanäle", "pt": "Canais Wi-Fi", "fr": "Canaux Wi-Fi",
        "zh_Hans": "Wi-Fi 信道", "zh_Hant": "Wi-Fi 頻道", "ja": "Wi-Fi チャンネル",
        "th": "ช่อง Wi-Fi", "ru": "Каналы Wi-Fi", "uk": "Канали Wi-Fi",
        "pl": "Kanały Wi-Fi", "cs": "Kanály Wi-Fi", "ko": "Wi-Fi 채널", "hi": "Wi-Fi चैनल",
    },
    "toolWifiChannelsSub": {
        "en": "2.4 & 5 GHz interference map",
        "it": "Mappa interferenze 2,4 e 5 GHz",
        "es": "Mapa de interferencias 2,4 y 5 GHz",
        "de": "Interferenzkarte für 2,4 & 5 GHz",
        "pt": "Mapa de interferência 2,4 e 5 GHz",
        "fr": "Carte des interférences 2,4 et 5 GHz",
        "zh_Hans": "2.4 与 5 GHz 干扰图", "zh_Hant": "2.4 與 5 GHz 干擾圖",
        "ja": "2.4・5 GHz 干渉マップ", "th": "แผนที่การรบกวน 2.4 และ 5 GHz",
        "ru": "Карта помех 2,4 и 5 ГГц", "uk": "Карта завад 2,4 і 5 ГГц",
        "pl": "Mapa zakłóceń 2,4 i 5 GHz", "cs": "Mapa rušení 2,4 a 5 GHz",
        "ko": "2.4 및 5 GHz 간섭 지도", "hi": "2.4 और 5 GHz हस्तक्षेप मानचित्र",
    },
    "toolCellularInfo": {
        "en": "Cellular Info", "it": "Info cellulare", "es": "Info móvil",
        "de": "Mobilfunk-Info", "pt": "Info móvel", "fr": "Info cellulaire",
        "zh_Hans": "蜂窝信息", "zh_Hant": "行動網路資訊", "ja": "セルラー情報",
        "th": "ข้อมูลเซลลูลาร์", "ru": "Данные сотовой сети",
        "uk": "Дані стільникової мережі", "pl": "Informacje o sieci komórkowej",
        "cs": "Informace o mobilní síti", "ko": "셀룰러 정보", "hi": "सेल्युलर जानकारी",
    },
    "toolCellularInfoSub": {
        "en": "Signal, cell ID & tower data",
        "it": "Segnale, ID cella e dati torre",
        "es": "Señal, ID de celda y datos de torre",
        "de": "Signal, Zell-ID & Mastdaten",
        "pt": "Sinal, ID da célula e dados da torre",
        "fr": "Signal, ID de cellule et données d'antenne",
        "zh_Hans": "信号、小区 ID 和基站数据",
        "zh_Hant": "訊號、基地台 ID 與基地台資料",
        "ja": "信号、セル ID、基地局データ",
        "th": "สัญญาณ, cell ID และข้อมูลเสา",
        "ru": "Сигнал, ID соты и данные вышки",
        "uk": "Сигнал, ID соти та дані вежі",
        "pl": "Sygnał, ID komórki i dane masztu",
        "cs": "Signál, ID buňky a data vysílače",
        "ko": "신호, 셀 ID 및 기지국 데이터",
        "hi": "सिग्नल, सेल ID और टावर डेटा",
    },
    "about": {
        "en": "About", "it": "Informazioni", "es": "Acerca de",
        "de": "Über", "pt": "Sobre", "fr": "À propos", "zh_Hans": "关于",
        "zh_Hant": "關於", "ja": "情報", "th": "เกี่ยวกับ", "ru": "О программе",
        "uk": "Про програму", "pl": "O aplikacji", "cs": "O aplikaci",
        "ko": "정보", "hi": "परिचय",
    },
    "close": {
        "en": "Close", "it": "Chiudi", "es": "Cerrar", "de": "Schließen",
        "pt": "Fechar", "fr": "Fermer", "zh_Hans": "关闭", "zh_Hant": "關閉",
        "ja": "閉じる", "th": "ปิด", "ru": "Закрыть", "uk": "Закрити",
        "pl": "Zamknij", "cs": "Zavřít", "ko": "닫기", "hi": "बंद करें",
    },
    "cancel": {
        "en": "Cancel", "it": "Annulla", "es": "Cancelar", "de": "Abbrechen",
        "pt": "Cancelar", "fr": "Annuler", "zh_Hans": "取消", "zh_Hant": "取消",
        "ja": "キャンセル", "th": "ยกเลิก", "ru": "Отмена", "uk": "Скасувати",
        "pl": "Anuluj", "cs": "Zrušit", "ko": "취소", "hi": "रद्द करें",
    },
    "ok": {
        "en": "OK", "it": "OK", "es": "OK", "de": "OK", "pt": "OK", "fr": "OK",
        "zh_Hans": "确定", "zh_Hant": "確定", "ja": "OK", "th": "ตกลง",
        "ru": "ОК", "uk": "Гаразд", "pl": "OK", "cs": "OK", "ko": "확인", "hi": "ठीक है",
    },
    "delete": {
        "en": "Delete", "it": "Elimina", "es": "Eliminar", "de": "Löschen",
        "pt": "Eliminar", "fr": "Supprimer", "zh_Hans": "删除", "zh_Hant": "刪除",
        "ja": "削除", "th": "ลบ", "ru": "Удалить", "uk": "Видалити",
        "pl": "Usuń", "cs": "Smazat", "ko": "삭제", "hi": "हटाएं",
    },
    "retry": {
        "en": "Retry", "it": "Riprova", "es": "Reintentar", "de": "Wiederholen",
        "pt": "Tentar de novo", "fr": "Réessayer", "zh_Hans": "重试", "zh_Hant": "重試",
        "ja": "再試行", "th": "ลองใหม่", "ru": "Повторить", "uk": "Повторити",
        "pl": "Ponów", "cs": "Zkusit znovu", "ko": "다시 시도", "hi": "पुनः प्रयास",
    },
    "stop": {
        "en": "Stop", "it": "Ferma", "es": "Detener", "de": "Stopp",
        "pt": "Parar", "fr": "Arrêter", "zh_Hans": "停止", "zh_Hant": "停止",
        "ja": "停止", "th": "หยุด", "ru": "Стоп", "uk": "Стоп",
        "pl": "Zatrzymaj", "cs": "Zastavit", "ko": "중지", "hi": "रोकें",
    },
    "clear": {
        "en": "Clear", "it": "Cancella", "es": "Borrar", "de": "Löschen",
        "pt": "Limpar", "fr": "Effacer", "zh_Hans": "清除", "zh_Hant": "清除",
        "ja": "クリア", "th": "ล้าง", "ru": "Очистить", "uk": "Очистити",
        "pl": "Wyczyść", "cs": "Vymazat", "ko": "지우기", "hi": "साफ़ करें",
    },
    "copy": {
        "en": "Copy", "it": "Copia", "es": "Copiar", "de": "Kopieren",
        "pt": "Copiar", "fr": "Copier", "zh_Hans": "复制", "zh_Hant": "複製",
        "ja": "コピー", "th": "คัดลอก", "ru": "Копировать", "uk": "Копіювати",
        "pl": "Kopiuj", "cs": "Kopírovat", "ko": "복사", "hi": "कॉपी करें",
    },
    "copied": {
        "en": "Copied", "it": "Copiato", "es": "Copiado", "de": "Kopiert",
        "pt": "Copiado", "fr": "Copié", "zh_Hans": "已复制", "zh_Hant": "已複製",
        "ja": "コピーしました", "th": "คัดลอกแล้ว", "ru": "Скопировано", "uk": "Скопійовано",
        "pl": "Skopiowano", "cs": "Zkopírováno", "ko": "복사됨", "hi": "कॉपी किया गया",
    },
    "copyIp": {
        "en": "Copy IP", "it": "Copia IP", "es": "Copiar IP", "de": "IP kopieren",
        "pt": "Copiar IP", "fr": "Copier l'IP", "zh_Hans": "复制 IP", "zh_Hant": "複製 IP",
        "ja": "IP をコピー", "th": "คัดลอก IP", "ru": "Копировать IP", "uk": "Копіювати IP",
        "pl": "Kopiuj IP", "cs": "Kopírovat IP", "ko": "IP 복사", "hi": "IP कॉपी करें",
    },
    "hostHint": {
        "en": "IP address or hostname", "it": "Indirizzo IP o hostname",
        "es": "Dirección IP o nombre de host", "de": "IP-Adresse oder Hostname",
        "pt": "Endereço IP ou nome de host", "fr": "Adresse IP ou nom d'hôte",
        "zh_Hans": "IP 地址或主机名", "zh_Hant": "IP 位址或主機名稱",
        "ja": "IP アドレスまたはホスト名", "th": "ที่อยู่ IP หรือชื่อโฮสต์",
        "ru": "IP-адрес или имя хоста", "uk": "IP-адреса або ім'я хоста",
        "pl": "Adres IP lub nazwa hosta", "cs": "IP adresa nebo název hostitele",
        "ko": "IP 주소 또는 호스트 이름", "hi": "IP पता या होस्टनाम",
    },
    "domainHostHint": {
        "en": "Domain, IP address, or hostname",
        "it": "Dominio, indirizzo IP o hostname",
        "es": "Dominio, dirección IP o nombre de host",
        "de": "Domain, IP-Adresse oder Hostname",
        "pt": "Domínio, endereço IP ou nome de host",
        "fr": "Domaine, adresse IP ou nom d'hôte",
        "zh_Hans": "域名、IP 地址或主机名", "zh_Hant": "網域、IP 位址或主機名稱",
        "ja": "ドメイン、IP アドレス、またはホスト名",
        "th": "โดเมน, ที่อยู่ IP หรือชื่อโฮสต์",
        "ru": "Домен, IP-адрес или имя хоста",
        "uk": "Домен, IP-адреса або ім'я хоста",
        "pl": "Domena, adres IP lub nazwa hosta",
        "cs": "Doména, IP adresa nebo název hostitele",
        "ko": "도메인, IP 주소 또는 호스트 이름", "hi": "डोमेन, IP पता या होस्टनाम",
    },
    "go": {
        "en": "Go", "it": "Vai", "es": "Ir", "de": "Los",
        "pt": "Ir", "fr": "Go", "zh_Hans": "开始", "zh_Hant": "開始",
        "ja": "実行", "th": "เริ่ม", "ru": "Пуск", "uk": "Пуск",
        "pl": "Start", "cs": "Spustit", "ko": "실행", "hi": "जाएं",
    },
    "trace": {
        "en": "Trace", "it": "Traccia", "es": "Trazar", "de": "Verfolgen",
        "pt": "Traçar", "fr": "Tracer", "zh_Hans": "追踪", "zh_Hant": "追蹤",
        "ja": "追跡", "th": "ติดตาม", "ru": "Трассировать", "uk": "Трасувати",
        "pl": "Śledź", "cs": "Sledovat", "ko": "추적", "hi": "ट्रेस",
    },
    "lookUp": {
        "en": "Look up", "it": "Cerca", "es": "Buscar", "de": "Suchen",
        "pt": "Procurar", "fr": "Rechercher", "zh_Hans": "查询", "zh_Hant": "查詢",
        "ja": "検索", "th": "ค้นหา", "ru": "Найти", "uk": "Знайти",
        "pl": "Wyszukaj", "cs": "Vyhledat", "ko": "조회", "hi": "खोजें",
    },
    "lookingUp": {
        "en": "Looking up…", "it": "Ricerca…", "es": "Buscando…", "de": "Suche…",
        "pt": "A procurar…", "fr": "Recherche…", "zh_Hans": "查询中…", "zh_Hant": "查詢中…",
        "ja": "検索中…", "th": "กำลังค้นหา…", "ru": "Поиск…", "uk": "Пошук…",
        "pl": "Wyszukiwanie…", "cs": "Vyhledávání…", "ko": "조회 중…", "hi": "खोज रहे हैं…",
    },
    "enterHostGo": {
        "en": "Enter a host and press Go", "it": "Inserisci un host e premi Vai",
        "es": "Introduce un host y pulsa Ir", "de": "Host eingeben und Los drücken",
        "pt": "Introduza um host e prima Ir", "fr": "Saisissez un hôte et appuyez sur Go",
        "zh_Hans": "输入主机并点击开始", "zh_Hant": "輸入主機並點擊開始",
        "ja": "ホストを入力して実行を押してください", "th": "ป้อนโฮสต์แล้วกดเริ่ม",
        "ru": "Введите хост и нажмите Пуск", "uk": "Введіть хост і натисніть Пуск",
        "pl": "Wpisz hosta i naciśnij Start", "cs": "Zadejte hostitele a stiskněte Spustit",
        "ko": "호스트를 입력하고 실행을 누르세요", "hi": "होस्ट दर्ज करें और जाएं दबाएं",
    },
    "enterHostTrace": {
        "en": "Enter a host and press Trace", "it": "Inserisci un host e premi Traccia",
        "es": "Introduce un host y pulsa Trazar", "de": "Host eingeben und Verfolgen drücken",
        "pt": "Introduza um host e prima Traçar", "fr": "Saisissez un hôte et appuyez sur Tracer",
        "zh_Hans": "输入主机并点击追踪", "zh_Hant": "輸入主機並點擊追蹤",
        "ja": "ホストを入力して追跡を押してください", "th": "ป้อนโฮสต์แล้วกดติดตาม",
        "ru": "Введите хост и нажмите Трассировать", "uk": "Введіть хост і натисніть Трасувати",
        "pl": "Wpisz hosta i naciśnij Śledź", "cs": "Zadejte hostitele a stiskněte Sledovat",
        "ko": "호스트를 입력하고 추적을 누르세요", "hi": "होस्ट दर्ज करें और ट्रेस दबाएं",
    },
    "enterHostScan": {
        "en": "Enter a host and tap Scan", "it": "Inserisci un host e tocca Scansione",
        "es": "Introduce un host y toca Escanear", "de": "Host eingeben und auf Scannen tippen",
        "pt": "Introduza um host e toque em Analisar", "fr": "Saisissez un hôte et touchez Analyser",
        "zh_Hans": "输入主机并点击扫描", "zh_Hant": "輸入主機並點擊掃描",
        "ja": "ホストを入力してスキャンをタップ", "th": "ป้อนโฮสต์แล้วแตะสแกน",
        "ru": "Введите хост и нажмите Сканировать", "uk": "Введіть хост і натисніть Сканувати",
        "pl": "Wpisz hosta i dotknij Skanuj", "cs": "Zadejte hostitele a klepněte na Skenovat",
        "ko": "호스트를 입력하고 스캔을 누르세요", "hi": "होस्ट दर्ज करें और स्कैन टैप करें",
    },
    "enterDomainIp": {
        "en": "Enter a domain, IP, or hostname",
        "it": "Inserisci un dominio, IP o hostname",
        "es": "Introduce un dominio, IP o nombre de host",
        "de": "Domain, IP oder Hostname eingeben",
        "pt": "Introduza um domínio, IP ou nome de host",
        "fr": "Saisissez un domaine, une IP ou un nom d'hôte",
        "zh_Hans": "输入域名、IP 或主机名", "zh_Hant": "輸入網域、IP 或主機名稱",
        "ja": "ドメイン、IP、またはホスト名を入力",
        "th": "ป้อนโดเมน, IP หรือชื่อโฮสต์",
        "ru": "Введите домен, IP или имя хоста",
        "uk": "Введіть домен, IP або ім'я хоста",
        "pl": "Wpisz domenę, IP lub nazwę hosta",
        "cs": "Zadejte doménu, IP nebo název hostitele",
        "ko": "도메인, IP 또는 호스트 이름 입력", "hi": "डोमेन, IP या होस्टनाम दर्ज करें",
    },
    "aboutPing": {
        "en": "About Ping", "it": "Informazioni su Ping", "es": "Acerca de Ping",
        "de": "Über Ping", "pt": "Sobre o Ping", "fr": "À propos de Ping",
        "zh_Hans": "关于 Ping", "zh_Hant": "關於 Ping", "ja": "Ping について",
        "th": "เกี่ยวกับ Ping", "ru": "О Ping", "uk": "Про Ping",
        "pl": "O Ping", "cs": "O funkci Ping", "ko": "Ping 정보", "hi": "Ping के बारे में",
    },
    "aboutTraceroute": {
        "en": "About Traceroute", "it": "Informazioni su Traceroute",
        "es": "Acerca de Traceroute", "de": "Über Traceroute",
        "pt": "Sobre o Traceroute", "fr": "À propos de Traceroute",
        "zh_Hans": "关于 Traceroute", "zh_Hant": "關於 Traceroute",
        "ja": "Traceroute について", "th": "เกี่ยวกับ Traceroute",
        "ru": "О Traceroute", "uk": "Про Traceroute", "pl": "O Traceroute",
        "cs": "O funkci Traceroute", "ko": "Traceroute 정보", "hi": "Traceroute के बारे में",
    },
    "aboutWhois": {
        "en": "About Who Is", "it": "Informazioni su Who Is",
        "es": "Acerca de Who Is", "de": "Über Who Is",
        "pt": "Sobre o Who Is", "fr": "À propos de Who Is",
        "zh_Hans": "关于 Who Is", "zh_Hant": "關於 Who Is",
        "ja": "Who Is について", "th": "เกี่ยวกับ Who Is",
        "ru": "О Who Is", "uk": "Про Who Is", "pl": "O Who Is",
        "cs": "O funkci Who Is", "ko": "Who Is 정보", "hi": "Who Is के बारे में",
    },
    "aboutPortScan": {
        "en": "About Port Scan", "it": "Informazioni su Port Scan",
        "es": "Acerca de Port Scan", "de": "Über Port Scan",
        "pt": "Sobre o Port Scan", "fr": "À propos de Port Scan",
        "zh_Hans": "关于端口扫描", "zh_Hant": "關於連接埠掃描",
        "ja": "ポートスキャンについて", "th": "เกี่ยวกับ Port Scan",
        "ru": "О сканировании портов", "uk": "Про сканування портів",
        "pl": "O skanowaniu portów", "cs": "O skenování portů",
        "ko": "포트 스캔 정보", "hi": "पोर्ट स्कैन के बारे में",
    },
    "hiddenNode": {
        "en": "Hidden Node", "it": "Nodo nascosto", "es": "Nodo oculto",
        "de": "Verborgener Knoten", "pt": "Nó oculto", "fr": "Nœud caché",
        "zh_Hans": "隐藏节点", "zh_Hant": "隱藏節點", "ja": "非表示ノード",
        "th": "โหนดที่ซ่อนอยู่", "ru": "Скрытый узел", "uk": "Прихований вузол",
        "pl": "Ukryty węzeł", "cs": "Skrytý uzel", "ko": "숨겨진 노드", "hi": "छिपा नोड",
    },
    "destination": {
        "en": "Destination", "it": "Destinazione", "es": "Destino",
        "de": "Ziel", "pt": "Destino", "fr": "Destination",
        "zh_Hans": "目标", "zh_Hant": "目標", "ja": "宛先",
        "th": "ปลายทาง", "ru": "Назначение", "uk": "Призначення",
        "pl": "Cel", "cs": "Cíl", "ko": "목적지", "hi": "गंतव्य",
    },
    "yourRouter": {
        "en": "Your router", "it": "Il tuo router", "es": "Tu router",
        "de": "Dein Router", "pt": "O teu router", "fr": "Votre routeur",
        "zh_Hans": "你的路由器", "zh_Hant": "你的路由器", "ja": "あなたのルーター",
        "th": "เราเตอร์ของคุณ", "ru": "Ваш маршрутизатор", "uk": "Ваш маршрутизатор",
        "pl": "Twój router", "cs": "Váš router", "ko": "내 라우터", "hi": "आपका राउटर",
    },
    "networkHop": {
        "en": "Network Hop", "it": "Salto di rete", "es": "Salto de red",
        "de": "Netzwerk-Hop", "pt": "Salto de rede", "fr": "Saut réseau",
        "zh_Hans": "网络跳转", "zh_Hant": "網路躍點", "ja": "ネットワークホップ",
        "th": "ฮ็อพเครือข่าย", "ru": "Сетевой узел", "uk": "Мережевий вузол",
        "pl": "Przeskok sieciowy", "cs": "Síťový skok", "ko": "네트워크 홉", "hi": "नेटवर्क हॉप",
    },
    "hop": {
        "en": "Hop", "it": "Salto", "es": "Salto", "de": "Hop",
        "pt": "Salto", "fr": "Saut", "zh_Hans": "跳", "zh_Hant": "躍點",
        "ja": "ホップ", "th": "ฮ็อพ", "ru": "Узел", "uk": "Вузол",
        "pl": "Przeskok", "cs": "Skok", "ko": "홉", "hi": "हॉप",
    },
    "noReply": {
        "en": "no reply", "it": "nessuna risposta", "es": "sin respuesta",
        "de": "keine Antwort", "pt": "sem resposta", "fr": "aucune réponse",
        "zh_Hans": "无响应", "zh_Hant": "無回應", "ja": "応答なし",
        "th": "ไม่มีการตอบกลับ", "ru": "нет ответа", "uk": "немає відповіді",
        "pl": "brak odpowiedzi", "cs": "žádná odpověď", "ko": "응답 없음", "hi": "कोई उत्तर नहीं",
    },
    "probingNextHop": {
        "en": "Probing next hop…", "it": "Sondaggio salto successivo…",
        "es": "Sondeando siguiente salto…", "de": "Nächster Hop wird geprüft…",
        "pt": "A sondar próximo salto…", "fr": "Sondage du saut suivant…",
        "zh_Hans": "正在探测下一跳…", "zh_Hant": "正在探測下一躍點…",
        "ja": "次のホップを調査中…", "th": "กำลังตรวจฮ็อพถัดไป…",
        "ru": "Проверка следующего узла…", "uk": "Перевірка наступного вузла…",
        "pl": "Sondowanie następnego przeskoku…", "cs": "Zjišťování dalšího skoku…",
        "ko": "다음 홉 조사 중…", "hi": "अगला हॉप जांच रहे हैं…",
    },
    "hiddenNodeInfo": {
        "en": "This router did not reply to our probes. Many ISPs, firewalls "
              "and security appliances deliberately drop or rate-limit ICMP "
              "(ping) traffic, so the hop stays anonymous even though your "
              "data still passes through it.\n\nThis is normal and does not "
              "mean the route is broken.",
        "it": "Questo router non ha risposto ai nostri probe. Molti ISP, firewall "
              "e apparati di sicurezza scartano o limitano deliberatamente il "
              "traffico ICMP (ping), quindi il salto resta anonimo anche se i "
              "tuoi dati continuano a passarci.\n\nÈ normale e non significa "
              "che il percorso sia interrotto.",
        "es": "Este router no respondió a nuestros sondeos. Muchos ISP, "
              "firewalls y dispositivos de seguridad descartan o limitan "
              "deliberadamente el tráfico ICMP (ping), por lo que el salto "
              "permanece anónimo aunque tus datos sigan pasando por él.\n\nEs "
              "normal y no significa que la ruta esté rota.",
        "de": "Dieser Router hat auf unsere Anfragen nicht geantwortet. Viele "
              "ISPs, Firewalls und Sicherheitsgeräte verwerfen oder drosseln "
              "ICMP-(Ping-)Verkehr absichtlich, sodass der Hop anonym bleibt, "
              "obwohl deine Daten weiterhin darüber laufen.\n\nDas ist normal "
              "und bedeutet nicht, dass die Route unterbrochen ist.",
        "pt": "Este router não respondeu às nossas sondagens. Muitos ISPs, "
              "firewalls e dispositivos de segurança descartam ou limitam "
              "deliberadamente o tráfego ICMP (ping), por isso o salto "
              "permanece anónimo mesmo que os teus dados continuem a passar "
              "por ele.\n\nIsto é normal e não significa que a rota esteja "
              "quebrada.",
        "fr": "Ce routeur n'a pas répondu à nos sondes. De nombreux FAI, "
              "pare-feu et équipements de sécurité rejettent ou limitent "
              "délibérément le trafic ICMP (ping), de sorte que le saut reste "
              "anonyme même si vos données y transitent toujours.\n\nC'est "
              "normal et ne signifie pas que la route est rompue.",
        "zh_Hans": "该路由器未回应我们的探测。许多 ISP、防火墙和安全设备会故意丢弃或限制 "
                   "ICMP（ping）流量，因此即使数据仍经过该跳，它也保持匿名。\n\n这是正常现象，"
                   "并不意味着路由中断。",
        "zh_Hant": "此路由器未回應我們的探測。許多 ISP、防火牆與安全裝置會故意丟棄或限制 "
                   "ICMP（ping）流量，因此即使資料仍經過該躍點，它也保持匿名。\n\n這是正常現象，"
                   "並不代表路由中斷。",
        "ja": "このルーターはプローブに応答しませんでした。多くの ISP、ファイアウォール、"
              "セキュリティ機器は ICMP（ping）トラフィックを意図的に破棄または制限するため、"
              "データが通過していてもホップは匿名のままになります。\n\nこれは正常であり、"
              "経路が壊れていることを意味しません。",
        "th": "เราเตอร์นี้ไม่ตอบสนองต่อการตรวจสอบของเรา ISP, ไฟร์วอลล์ และอุปกรณ์รักษาความปลอดภัย"
              "จำนวนมากจงใจทิ้งหรือจำกัดทราฟฟิก ICMP (ping) ฮ็อพจึงยังคงไม่ระบุตัวตนแม้ข้อมูลของคุณ"
              "จะยังผ่านมันอยู่\n\nนี่เป็นเรื่องปกติและไม่ได้หมายความว่าเส้นทางเสียหาย",
        "ru": "Этот маршрутизатор не ответил на наши запросы. Многие "
              "интернет-провайдеры, брандмауэры и устройства безопасности "
              "намеренно отбрасывают или ограничивают трафик ICMP (ping), "
              "поэтому узел остаётся анонимным, хотя ваши данные всё равно "
              "проходят через него.\n\nЭто нормально и не означает, что "
              "маршрут нарушен.",
        "uk": "Цей маршрутизатор не відповів на наші запити. Багато "
              "інтернет-провайдерів, брандмауерів і пристроїв безпеки "
              "навмисно відкидають або обмежують трафік ICMP (ping), тож "
              "вузол залишається анонімним, хоча ваші дані все одно проходять "
              "через нього.\n\nЦе нормально й не означає, що маршрут порушено.",
        "pl": "Ten router nie odpowiedział na nasze sondy. Wielu dostawców "
              "internetu, zapór i urządzeń zabezpieczających celowo odrzuca "
              "lub ogranicza ruch ICMP (ping), więc przeskok pozostaje "
              "anonimowy, choć Twoje dane nadal przez niego przechodzą.\n\nTo "
              "normalne i nie oznacza, że trasa jest przerwana.",
        "cs": "Tento router neodpověděl na naše dotazy. Mnoho poskytovatelů "
              "internetu, firewallů a bezpečnostních zařízení záměrně zahazuje "
              "nebo omezuje provoz ICMP (ping), takže skok zůstává anonymní, "
              "i když jím vaše data stále procházejí.\n\nTo je normální a "
              "neznamená to, že je trasa přerušena.",
        "ko": "이 라우터는 프로브에 응답하지 않았습니다. 많은 ISP, 방화벽 및 보안 "
              "장비가 ICMP(ping) 트래픽을 의도적으로 폐기하거나 제한하므로, 데이터가 "
              "여전히 이 홉을 통과하더라도 익명으로 유지됩니다.\n\n이는 정상이며 "
              "경로가 끊어졌다는 뜻이 아닙니다.",
        "hi": "इस राउटर ने हमारी जांच का उत्तर नहीं दिया। कई ISP, फ़ायरवॉल और सुरक्षा "
              "उपकरण जानबूझकर ICMP (ping) ट्रैफ़िक को गिरा देते हैं या सीमित कर देते हैं, "
              "इसलिए आपका डेटा गुज़रने के बावजूद यह हॉप गुमनाम रहता है।\n\nयह सामान्य है और "
              "इसका मतलब यह नहीं कि मार्ग टूटा हुआ है।",
    },
    "portsLabel": {
        "en": "Ports:", "it": "Porte:", "es": "Puertos:", "de": "Ports:",
        "pt": "Portas:", "fr": "Ports :", "zh_Hans": "端口：", "zh_Hant": "連接埠：",
        "ja": "ポート:", "th": "พอร์ต:", "ru": "Порты:", "uk": "Порти:",
        "pl": "Porty:", "cs": "Porty:", "ko": "포트:", "hi": "पोर्ट:",
    },
    "wellKnown": {
        "en": "Well-known", "it": "Ben note", "es": "Conocidos",
        "de": "Bekannte", "pt": "Conhecidas", "fr": "Bien connus",
        "zh_Hans": "常用", "zh_Hant": "常用", "ja": "既知",
        "th": "ที่รู้จัก", "ru": "Известные", "uk": "Відомі",
        "pl": "Znane", "cs": "Známé", "ko": "잘 알려진", "hi": "प्रसिद्ध",
    },
    "rangeLabel": {
        "en": "Range", "it": "Intervallo", "es": "Rango", "de": "Bereich",
        "pt": "Intervalo", "fr": "Plage", "zh_Hans": "范围", "zh_Hant": "範圍",
        "ja": "範囲", "th": "ช่วง", "ru": "Диапазон", "uk": "Діапазон",
        "pl": "Zakres", "cs": "Rozsah", "ko": "범위", "hi": "श्रेणी",
    },
    "fromLabel": {
        "en": "From:", "it": "Da:", "es": "Desde:", "de": "Von:",
        "pt": "De:", "fr": "De :", "zh_Hans": "从：", "zh_Hant": "從：",
        "ja": "開始:", "th": "จาก:", "ru": "От:", "uk": "Від:",
        "pl": "Od:", "cs": "Od:", "ko": "시작:", "hi": "से:",
    },
    "toLabel": {
        "en": "To:", "it": "A:", "es": "Hasta:", "de": "Bis:",
        "pt": "Até:", "fr": "À :", "zh_Hans": "到：", "zh_Hant": "到：",
        "ja": "終了:", "th": "ถึง:", "ru": "До:", "uk": "До:",
        "pl": "Do:", "cs": "Do:", "ko": "끝:", "hi": "तक:",
    },
    "protocolLabel": {
        "en": "Protocol:", "it": "Protocollo:", "es": "Protocolo:",
        "de": "Protokoll:", "pt": "Protocolo:", "fr": "Protocole :",
        "zh_Hans": "协议：", "zh_Hant": "通訊協定：", "ja": "プロトコル:",
        "th": "โปรโตคอล:", "ru": "Протокол:", "uk": "Протокол:",
        "pl": "Protokół:", "cs": "Protokol:", "ko": "프로토콜:", "hi": "प्रोटोकॉल:",
    },
    "hideSettings": {
        "en": "Hide settings", "it": "Nascondi impostazioni",
        "es": "Ocultar ajustes", "de": "Einstellungen ausblenden",
        "pt": "Ocultar definições", "fr": "Masquer les paramètres",
        "zh_Hans": "隐藏设置", "zh_Hant": "隱藏設定", "ja": "設定を隠す",
        "th": "ซ่อนการตั้งค่า", "ru": "Скрыть настройки", "uk": "Сховати налаштування",
        "pl": "Ukryj ustawienia", "cs": "Skrýt nastavení", "ko": "설정 숨기기", "hi": "सेटिंग्स छिपाएं",
    },
    "myPublicIp": {
        "en": "My Public IP", "it": "Il mio IP pubblico", "es": "Mi IP pública",
        "de": "Meine öffentliche IP", "pt": "O meu IP público", "fr": "Mon IP publique",
        "zh_Hans": "我的公网 IP", "zh_Hant": "我的公用 IP", "ja": "自分のパブリック IP",
        "th": "IP สาธารณะของฉัน", "ru": "Мой публичный IP", "uk": "Мій публічний IP",
        "pl": "Mój publiczny IP", "cs": "Moje veřejná IP", "ko": "내 공용 IP", "hi": "मेरा सार्वजनिक IP",
    },
    "errorLabel": {
        "en": "Error", "it": "Errore", "es": "Error", "de": "Fehler",
        "pt": "Erro", "fr": "Erreur", "zh_Hans": "错误", "zh_Hant": "錯誤",
        "ja": "エラー", "th": "ข้อผิดพลาด", "ru": "Ошибка", "uk": "Помилка",
        "pl": "Błąd", "cs": "Chyba", "ko": "오류", "hi": "त्रुटि",
    },
    "infoUnavailable": {
        "en": "Information not available.", "it": "Informazioni non disponibili.",
        "es": "Información no disponible.", "de": "Informationen nicht verfügbar.",
        "pt": "Informação não disponível.", "fr": "Informations indisponibles.",
        "zh_Hans": "信息不可用。", "zh_Hant": "資訊不可用。", "ja": "情報を利用できません。",
        "th": "ไม่มีข้อมูล", "ru": "Информация недоступна.", "uk": "Інформація недоступна.",
        "pl": "Informacje niedostępne.", "cs": "Informace nejsou dostupné.",
        "ko": "정보를 사용할 수 없습니다.", "hi": "जानकारी उपलब्ध नहीं है।",
    },
    "startTest": {
        "en": "Start Test", "it": "Avvia test", "es": "Iniciar prueba",
        "de": "Test starten", "pt": "Iniciar teste", "fr": "Démarrer le test",
        "zh_Hans": "开始测试", "zh_Hant": "開始測試", "ja": "テスト開始",
        "th": "เริ่มทดสอบ", "ru": "Начать тест", "uk": "Почати тест",
        "pl": "Rozpocznij test", "cs": "Spustit test", "ko": "테스트 시작", "hi": "टेस्ट शुरू करें",
    },
    "download": {
        "en": "Download", "it": "Download", "es": "Descarga", "de": "Download",
        "pt": "Download", "fr": "Téléchargement", "zh_Hans": "下载", "zh_Hant": "下載",
        "ja": "ダウンロード", "th": "ดาวน์โหลด", "ru": "Загрузка", "uk": "Завантаження",
        "pl": "Pobieranie", "cs": "Stahování", "ko": "다운로드", "hi": "डाउनलोड",
    },
    "upload": {
        "en": "Upload", "it": "Upload", "es": "Subida", "de": "Upload",
        "pt": "Upload", "fr": "Téléversement", "zh_Hans": "上传", "zh_Hant": "上傳",
        "ja": "アップロード", "th": "อัปโหลด", "ru": "Отдача", "uk": "Віддача",
        "pl": "Wysyłanie", "cs": "Odesílání", "ko": "업로드", "hi": "अपलोड",
    },
    "statusReady": {
        "en": "Ready", "it": "Pronto", "es": "Listo", "de": "Bereit",
        "pt": "Pronto", "fr": "Prêt", "zh_Hans": "就绪", "zh_Hant": "就緒",
        "ja": "準備完了", "th": "พร้อม", "ru": "Готово", "uk": "Готово",
        "pl": "Gotowe", "cs": "Připraveno", "ko": "준비됨", "hi": "तैयार",
    },
    "statusDone": {
        "en": "Done", "it": "Fatto", "es": "Hecho", "de": "Fertig",
        "pt": "Concluído", "fr": "Terminé", "zh_Hans": "完成", "zh_Hant": "完成",
        "ja": "完了", "th": "เสร็จ", "ru": "Готово", "uk": "Готово",
        "pl": "Gotowe", "cs": "Hotovo", "ko": "완료", "hi": "पूर्ण",
    },
    "measuringPing": {
        "en": "Measuring ping…", "it": "Misurazione ping…", "es": "Midiendo ping…",
        "de": "Ping wird gemessen…", "pt": "A medir ping…", "fr": "Mesure du ping…",
        "zh_Hans": "正在测量 ping…", "zh_Hant": "正在測量 ping…", "ja": "ping を測定中…",
        "th": "กำลังวัด ping…", "ru": "Измерение ping…", "uk": "Вимірювання ping…",
        "pl": "Pomiar ping…", "cs": "Měření ping…", "ko": "ping 측정 중…", "hi": "ping माप रहे हैं…",
    },
    "findingServer": {
        "en": "Finding server…", "it": "Ricerca server…", "es": "Buscando servidor…",
        "de": "Server wird gesucht…", "pt": "A procurar servidor…", "fr": "Recherche du serveur…",
        "zh_Hans": "正在查找服务器…", "zh_Hant": "正在尋找伺服器…", "ja": "サーバーを検索中…",
        "th": "กำลังค้นหาเซิร์ฟเวอร์…", "ru": "Поиск сервера…", "uk": "Пошук сервера…",
        "pl": "Wyszukiwanie serwera…", "cs": "Hledání serveru…", "ko": "서버 찾는 중…", "hi": "सर्वर खोज रहे हैं…",
    },
    "testingDownload": {
        "en": "Testing download…", "it": "Test download…", "es": "Probando descarga…",
        "de": "Download wird getestet…", "pt": "A testar download…", "fr": "Test du téléchargement…",
        "zh_Hans": "正在测试下载…", "zh_Hant": "正在測試下載…", "ja": "ダウンロードをテスト中…",
        "th": "กำลังทดสอบดาวน์โหลด…", "ru": "Тест загрузки…", "uk": "Тест завантаження…",
        "pl": "Test pobierania…", "cs": "Test stahování…", "ko": "다운로드 테스트 중…", "hi": "डाउनलोड परीक्षण…",
    },
    "testingUpload": {
        "en": "Testing upload…", "it": "Test upload…", "es": "Probando subida…",
        "de": "Upload wird getestet…", "pt": "A testar upload…", "fr": "Test du téléversement…",
        "zh_Hans": "正在测试上传…", "zh_Hant": "正在測試上傳…", "ja": "アップロードをテスト中…",
        "th": "กำลังทดสอบอัปโหลด…", "ru": "Тест отдачи…", "uk": "Тест віддачі…",
        "pl": "Test wysyłania…", "cs": "Test odesílání…", "ko": "업로드 테스트 중…", "hi": "अपलोड परीक्षण…",
    },
    "viaCloudflare": {
        "en": "Via Cloudflare", "it": "Tramite Cloudflare", "es": "Vía Cloudflare",
        "de": "Über Cloudflare", "pt": "Via Cloudflare", "fr": "Via Cloudflare",
        "zh_Hans": "通过 Cloudflare", "zh_Hant": "透過 Cloudflare", "ja": "Cloudflare 経由",
        "th": "ผ่าน Cloudflare", "ru": "Через Cloudflare", "uk": "Через Cloudflare",
        "pl": "Przez Cloudflare", "cs": "Přes Cloudflare", "ko": "Cloudflare 사용", "hi": "Cloudflare के माध्यम से",
    },
    "viaOokla": {
        "en": "Via Ookla", "it": "Tramite Ookla", "es": "Vía Ookla",
        "de": "Über Ookla", "pt": "Via Ookla", "fr": "Via Ookla",
        "zh_Hans": "通过 Ookla", "zh_Hant": "透過 Ookla", "ja": "Ookla 経由",
        "th": "ผ่าน Ookla", "ru": "Через Ookla", "uk": "Через Ookla",
        "pl": "Przez Ookla", "cs": "Přes Ookla", "ko": "Ookla 사용", "hi": "Ookla के माध्यम से",
    },
    "aboutSpeedTestTip": {
        "en": "About the speed test", "it": "Informazioni sul test di velocità",
        "es": "Acerca de la prueba de velocidad", "de": "Über den Geschwindigkeitstest",
        "pt": "Sobre o teste de velocidade", "fr": "À propos du test de débit",
        "zh_Hans": "关于速度测试", "zh_Hant": "關於速度測試", "ja": "速度テストについて",
        "th": "เกี่ยวกับการทดสอบความเร็ว", "ru": "О тесте скорости", "uk": "Про тест швидкості",
        "pl": "O teście prędkości", "cs": "O testu rychlosti", "ko": "속도 테스트 정보", "hi": "स्पीड टेस्ट के बारे में",
    },
    "speedTestInfo": {
        "en": "Speed Test Info", "it": "Info test velocità",
        "es": "Info prueba de velocidad", "de": "Geschwindigkeitstest-Info",
        "pt": "Info teste de velocidade", "fr": "Info test de débit",
        "zh_Hans": "速度测试信息", "zh_Hant": "速度測試資訊", "ja": "速度テスト情報",
        "th": "ข้อมูลการทดสอบความเร็ว", "ru": "О тесте скорости", "uk": "Про тест швидкості",
        "pl": "Informacje o teście prędkości", "cs": "Informace o testu rychlosti",
        "ko": "속도 테스트 정보", "hi": "स्पीड टेस्ट जानकारी",
    },
    "previousMeasurements": {
        "en": "Previous Measurements", "it": "Misurazioni precedenti",
        "es": "Mediciones anteriores", "de": "Frühere Messungen",
        "pt": "Medições anteriores", "fr": "Mesures précédentes",
        "zh_Hans": "历史测量", "zh_Hant": "先前的測量", "ja": "過去の測定",
        "th": "การวัดก่อนหน้า", "ru": "Предыдущие измерения", "uk": "Попередні вимірювання",
        "pl": "Poprzednie pomiary", "cs": "Předchozí měření", "ko": "이전 측정", "hi": "पिछले माप",
    },
    "noMeasurements": {
        "en": "No measurements yet.", "it": "Nessuna misurazione ancora.",
        "es": "Aún no hay mediciones.", "de": "Noch keine Messungen.",
        "pt": "Ainda sem medições.", "fr": "Aucune mesure pour l'instant.",
        "zh_Hans": "暂无测量。", "zh_Hant": "尚無測量。", "ja": "まだ測定がありません。",
        "th": "ยังไม่มีการวัด", "ru": "Измерений пока нет.", "uk": "Вимірювань поки немає.",
        "pl": "Brak pomiarów.", "cs": "Zatím žádná měření.", "ko": "아직 측정이 없습니다.", "hi": "अभी तक कोई माप नहीं।",
    },
    "dateTime": {
        "en": "Date / Time", "it": "Data / Ora", "es": "Fecha / Hora",
        "de": "Datum / Zeit", "pt": "Data / Hora", "fr": "Date / Heure",
        "zh_Hans": "日期 / 时间", "zh_Hant": "日期 / 時間", "ja": "日付 / 時刻",
        "th": "วันที่ / เวลา", "ru": "Дата / Время", "uk": "Дата / Час",
        "pl": "Data / Godzina", "cs": "Datum / Čas", "ko": "날짜 / 시간", "hi": "दिनांक / समय",
    },
    "switchToOokla": {
        "en": "Switch to Ookla?", "it": "Passare a Ookla?", "es": "¿Cambiar a Ookla?",
        "de": "Zu Ookla wechseln?", "pt": "Mudar para Ookla?", "fr": "Passer à Ookla ?",
        "zh_Hans": "切换到 Ookla？", "zh_Hant": "切換到 Ookla？", "ja": "Ookla に切り替えますか？",
        "th": "สลับไป Ookla?", "ru": "Переключиться на Ookla?", "uk": "Перейти на Ookla?",
        "pl": "Przełączyć na Ookla?", "cs": "Přepnout na Ookla?", "ko": "Ookla로 전환?", "hi": "Ookla पर स्विच करें?",
    },
    "ooklaConsentBody": {
        "en": "Switching to Ookla requires connecting to third-party servers. "
              "Ookla collects and shares your IP address, device identifiers, "
              "and location data.",
        "it": "Passare a Ookla richiede la connessione a server di terze parti. "
              "Ookla raccoglie e condivide il tuo indirizzo IP, gli "
              "identificatori del dispositivo e i dati di posizione.",
        "es": "Cambiar a Ookla requiere conectarse a servidores de terceros. "
              "Ookla recopila y comparte tu dirección IP, los identificadores "
              "del dispositivo y los datos de ubicación.",
        "de": "Der Wechsel zu Ookla erfordert eine Verbindung zu "
              "Drittanbieter-Servern. Ookla sammelt und teilt deine "
              "IP-Adresse, Gerätekennungen und Standortdaten.",
        "pt": "Mudar para Ookla exige ligar-se a servidores de terceiros. "
              "A Ookla recolhe e partilha o teu endereço IP, identificadores "
              "do dispositivo e dados de localização.",
        "fr": "Passer à Ookla nécessite de se connecter à des serveurs tiers. "
              "Ookla collecte et partage votre adresse IP, les identifiants de "
              "l'appareil et les données de localisation.",
        "zh_Hans": "切换到 Ookla 需要连接第三方服务器。Ookla 会收集并共享你的 IP 地址、"
                   "设备标识符和位置信息。",
        "zh_Hant": "切換到 Ookla 需要連線到第三方伺服器。Ookla 會收集並分享你的 IP 位址、"
                   "裝置識別碼與位置資料。",
        "ja": "Ookla に切り替えるにはサードパーティのサーバーへの接続が必要です。Ookla は "
              "あなたの IP アドレス、デバイス識別子、位置情報を収集・共有します。",
        "th": "การสลับไป Ookla ต้องเชื่อมต่อกับเซิร์ฟเวอร์บุคคลที่สาม Ookla จะเก็บและแบ่งปัน"
              "ที่อยู่ IP, ตัวระบุอุปกรณ์ และข้อมูลตำแหน่งของคุณ",
        "ru": "Переключение на Ookla требует подключения к сторонним серверам. "
              "Ookla собирает и передаёт ваш IP-адрес, идентификаторы "
              "устройства и данные о местоположении.",
        "uk": "Перехід на Ookla потребує підключення до сторонніх серверів. "
              "Ookla збирає та передає вашу IP-адресу, ідентифікатори "
              "пристрою й дані про місцезнаходження.",
        "pl": "Przełączenie na Ookla wymaga połączenia z serwerami zewnętrznymi. "
              "Ookla zbiera i udostępnia Twój adres IP, identyfikatory "
              "urządzenia oraz dane o lokalizacji.",
        "cs": "Přepnutí na Ookla vyžaduje připojení k serverům třetích stran. "
              "Ookla shromažďuje a sdílí vaši IP adresu, identifikátory "
              "zařízení a údaje o poloze.",
        "ko": "Ookla로 전환하려면 타사 서버에 연결해야 합니다. Ookla는 사용자의 IP "
              "주소, 기기 식별자 및 위치 데이터를 수집하고 공유합니다.",
        "hi": "Ookla पर स्विच करने के लिए तृतीय-पक्ष सर्वरों से कनेक्ट करना आवश्यक है। "
              "Ookla आपका IP पता, डिवाइस पहचानकर्ता और स्थान डेटा एकत्र और साझा करता है।",
    },
    "decline": {
        "en": "Decline", "it": "Rifiuta", "es": "Rechazar", "de": "Ablehnen",
        "pt": "Recusar", "fr": "Refuser", "zh_Hans": "拒绝", "zh_Hant": "拒絕",
        "ja": "拒否", "th": "ปฏิเสธ", "ru": "Отклонить", "uk": "Відхилити",
        "pl": "Odrzuć", "cs": "Odmítnout", "ko": "거부", "hi": "अस्वीकार करें",
    },
    "accept": {
        "en": "Accept", "it": "Accetta", "es": "Aceptar", "de": "Akzeptieren",
        "pt": "Aceitar", "fr": "Accepter", "zh_Hans": "接受", "zh_Hant": "接受",
        "ja": "同意", "th": "ยอมรับ", "ru": "Принять", "uk": "Прийняти",
        "pl": "Akceptuj", "cs": "Přijmout", "ko": "동의", "hi": "स्वीकार करें",
    },
    "clearHistoryTitle": {
        "en": "Clear History?", "it": "Cancellare la cronologia?",
        "es": "¿Borrar historial?", "de": "Verlauf löschen?",
        "pt": "Limpar histórico?", "fr": "Effacer l'historique ?",
        "zh_Hans": "清除历史记录？", "zh_Hant": "清除歷史記錄？", "ja": "履歴を消去しますか？",
        "th": "ล้างประวัติ?", "ru": "Очистить историю?", "uk": "Очистити історію?",
        "pl": "Wyczyścić historię?", "cs": "Vymazat historii?", "ko": "기록을 지울까요?", "hi": "इतिहास साफ़ करें?",
    },
    "clearHistoryBody": {
        "en": "This will permanently delete all measurement records.",
        "it": "Questo eliminerà definitivamente tutti i record di misurazione.",
        "es": "Esto eliminará permanentemente todos los registros de medición.",
        "de": "Dadurch werden alle Messdatensätze dauerhaft gelöscht.",
        "pt": "Isto eliminará permanentemente todos os registos de medição.",
        "fr": "Cela supprimera définitivement tous les enregistrements de mesure.",
        "zh_Hans": "这将永久删除所有测量记录。", "zh_Hant": "這將永久刪除所有測量記錄。",
        "ja": "すべての測定記録を完全に削除します。", "th": "การดำเนินการนี้จะลบบันทึกการวัดทั้งหมดอย่างถาวร",
        "ru": "Это навсегда удалит все записи измерений.",
        "uk": "Це назавжди видалить усі записи вимірювань.",
        "pl": "Spowoduje to trwałe usunięcie wszystkich zapisów pomiarów.",
        "cs": "Tím se trvale odstraní všechny záznamy měření.",
        "ko": "모든 측정 기록이 영구적으로 삭제됩니다.", "hi": "इससे सभी माप रिकॉर्ड स्थायी रूप से हट जाएंगे।",
    },
    "aboutThisScan": {
        "en": "About this scan", "it": "Informazioni su questa scansione",
        "es": "Acerca de este escaneo", "de": "Über diesen Scan",
        "pt": "Sobre esta análise", "fr": "À propos de cette analyse",
        "zh_Hans": "关于此扫描", "zh_Hant": "關於此掃描", "ja": "このスキャンについて",
        "th": "เกี่ยวกับการสแกนนี้", "ru": "Об этом сканировании", "uk": "Про це сканування",
        "pl": "O tym skanowaniu", "cs": "O tomto skenování", "ko": "이 스캔 정보", "hi": "इस स्कैन के बारे में",
    },
    "scanInfoBody": {
        "en": "Devices blocking ICMP (pings) will not appear here. Run the "
              "'IoT Devices' or 'IP Cameras' scan to locate them via their open "
              "ports and services.\n\nIn Android 11+ devices, MAC addresses "
              "cannot be retrieved due to Google's privacy restrictions, so "
              "they are not displayed.",
        "it": "I dispositivi che bloccano ICMP (ping) non appariranno qui. "
              "Esegui la scansione 'Dispositivi IoT' o 'Telecamere IP' per "
              "individuarli tramite le loro porte e servizi aperti.\n\nSui "
              "dispositivi Android 11+, gli indirizzi MAC non possono essere "
              "recuperati a causa delle restrizioni sulla privacy di Google, "
              "quindi non vengono mostrati.",
        "es": "Los dispositivos que bloquean ICMP (pings) no aparecerán aquí. "
              "Ejecuta el escaneo 'Dispositivos IoT' o 'Cámaras IP' para "
              "localizarlos mediante sus puertos y servicios abiertos.\n\nEn "
              "dispositivos Android 11+, las direcciones MAC no se pueden "
              "obtener debido a las restricciones de privacidad de Google, por "
              "lo que no se muestran.",
        "de": "Geräte, die ICMP (Pings) blockieren, erscheinen hier nicht. "
              "Führe den Scan 'IoT-Geräte' oder 'IP-Kameras' aus, um sie über "
              "ihre offenen Ports und Dienste zu finden.\n\nAuf Android-11+-"
              "Geräten können MAC-Adressen aufgrund von Googles "
              "Datenschutzbeschränkungen nicht abgerufen und daher nicht "
              "angezeigt werden.",
        "pt": "Os dispositivos que bloqueiam ICMP (pings) não aparecerão aqui. "
              "Execute a análise 'Dispositivos IoT' ou 'Câmaras IP' para os "
              "localizar através das suas portas e serviços abertos.\n\nEm "
              "dispositivos Android 11+, os endereços MAC não podem ser obtidos "
              "devido às restrições de privacidade da Google, pelo que não são "
              "apresentados.",
        "fr": "Les appareils qui bloquent ICMP (pings) n'apparaîtront pas ici. "
              "Lancez l'analyse « Appareils IoT » ou « Caméras IP » pour les "
              "localiser via leurs ports et services ouverts.\n\nSur les "
              "appareils Android 11+, les adresses MAC ne peuvent pas être "
              "récupérées en raison des restrictions de confidentialité de "
              "Google, elles ne sont donc pas affichées.",
        "zh_Hans": "屏蔽 ICMP（ping）的设备不会显示在此处。运行"
                   "\u201cIoT 设备\u201d或\u201cIP 摄像头\u201d扫描，通过其开放端口和服务来定位它们。"
                   "\n\n在 Android 11+ 设备上，由于 Google 的隐私限制，无法获取 MAC 地址，"
                   "因此不予显示。",
        "zh_Hant": "封鎖 ICMP（ping）的裝置不會顯示在此處。執行"
                   "\u201cIoT 裝置\u201d或\u201cIP 攝影機\u201d掃描，透過其開放連接埠與服務來定位它們。"
                   "\n\n在 Android 11+ 裝置上，由於 Google 的隱私限制，無法取得 MAC 位址，"
                   "因此不予顯示。",
        "ja": "ICMP（ping）をブロックするデバイスはここに表示されません。「IoT デバイス」"
              "または「IP カメラ」スキャンを実行して、開いているポートとサービスから検出して"
              "ください。\n\nAndroid 11 以降のデバイスでは、Google のプライバシー制限により "
              "MAC アドレスを取得できないため表示されません。",
        "th": "อุปกรณ์ที่บล็อก ICMP (ping) จะไม่แสดงที่นี่ ให้เรียกใช้การสแกน 'อุปกรณ์ IoT' "
              "หรือ 'กล้อง IP' เพื่อค้นหาผ่านพอร์ตและบริการที่เปิดอยู่\n\nบนอุปกรณ์ Android 11+ "
              "จะไม่สามารถดึงที่อยู่ MAC ได้เนื่องจากข้อจำกัดด้านความเป็นส่วนตัวของ Google "
              "จึงไม่แสดง",
        "ru": "Устройства, блокирующие ICMP (ping), здесь не отображаются. "
              "Запустите сканирование «IoT-устройства» или «IP-камеры», чтобы "
              "найти их по открытым портам и службам.\n\nНа устройствах Android "
              "11+ MAC-адреса не могут быть получены из-за ограничений "
              "конфиденциальности Google, поэтому они не отображаются.",
        "uk": "Пристрої, що блокують ICMP (ping), тут не відображаються. "
              "Запустіть сканування «IoT-пристрої» або «IP-камери», щоб знайти "
              "їх за відкритими портами та службами.\n\nНа пристроях Android "
              "11+ MAC-адреси не можна отримати через обмеження приватності "
              "Google, тож вони не відображаються.",
        "pl": "Urządzenia blokujące ICMP (ping) nie pojawią się tutaj. Uruchom "
              "skanowanie „Urządzenia IoT” lub „Kamery IP”, aby zlokalizować je "
              "poprzez ich otwarte porty i usługi.\n\nNa urządzeniach z Android "
              "11+ adresy MAC nie mogą być pobrane ze względu na ograniczenia "
              "prywatności Google, więc nie są wyświetlane.",
        "cs": "Zařízení blokující ICMP (ping) se zde nezobrazí. Spusťte "
              "skenování „Zařízení IoT“ nebo „IP kamery“, abyste je našli podle "
              "otevřených portů a služeb.\n\nNa zařízeních s Androidem 11+ "
              "nelze MAC adresy získat kvůli omezením soukromí od Googlu, proto "
              "se nezobrazují.",
        "ko": "ICMP(ping)를 차단하는 기기는 여기에 표시되지 않습니다. 'IoT 기기' 또는 "
              "'IP 카메라' 스캔을 실행하여 열린 포트와 서비스를 통해 찾으세요.\n\nAndroid "
              "11 이상 기기에서는 Google의 개인정보 보호 제한으로 인해 MAC 주소를 가져올 "
              "수 없어 표시되지 않습니다.",
        "hi": "ICMP (ping) को ब्लॉक करने वाले डिवाइस यहां नहीं दिखेंगे। उन्हें उनके खुले पोर्ट और "
              "सेवाओं के माध्यम से खोजने के लिए 'IoT डिवाइस' या 'IP कैमरा' स्कैन चलाएं।\n\nAndroid "
              "11+ डिवाइस पर, Google की गोपनीयता प्रतिबंधों के कारण MAC पते प्राप्त नहीं किए जा "
              "सकते, इसलिए वे प्रदर्शित नहीं होते।",
    },
    "stopScan": {
        "en": "Stop scan", "it": "Ferma scansione", "es": "Detener escaneo",
        "de": "Scan stoppen", "pt": "Parar análise", "fr": "Arrêter l'analyse",
        "zh_Hans": "停止扫描", "zh_Hant": "停止掃描", "ja": "スキャンを停止",
        "th": "หยุดสแกน", "ru": "Остановить сканирование", "uk": "Зупинити сканування",
        "pl": "Zatrzymaj skanowanie", "cs": "Zastavit skenování", "ko": "스캔 중지", "hi": "स्कैन रोकें",
    },
    "reScan": {
        "en": "Re-scan", "it": "Ripeti scansione", "es": "Reescanear",
        "de": "Erneut scannen", "pt": "Analisar de novo", "fr": "Relancer l'analyse",
        "zh_Hans": "重新扫描", "zh_Hant": "重新掃描", "ja": "再スキャン",
        "th": "สแกนใหม่", "ru": "Пересканировать", "uk": "Пересканувати",
        "pl": "Skanuj ponownie", "cs": "Znovu skenovat", "ko": "다시 스캔", "hi": "फिर से स्कैन करें",
    },
    "hostsFound": {
        "en": "host(s) found", "it": "host trovati", "es": "host encontrados",
        "de": "Host(s) gefunden", "pt": "host encontrados", "fr": "hôte(s) trouvé(s)",
        "zh_Hans": "个主机", "zh_Hant": "個主機", "ja": "台のホストを検出",
        "th": "โฮสต์ที่พบ", "ru": "хостов найдено", "uk": "хостів знайдено",
        "pl": "znalezionych hostów", "cs": "nalezených hostitelů", "ko": "개 호스트 발견", "hi": "होस्ट मिले",
    },
    "hostname": {
        "en": "Hostname", "it": "Hostname", "es": "Nombre de host",
        "de": "Hostname", "pt": "Nome de host", "fr": "Nom d'hôte",
        "zh_Hans": "主机名", "zh_Hant": "主機名稱", "ja": "ホスト名",
        "th": "ชื่อโฮสต์", "ru": "Имя хоста", "uk": "Ім'я хоста",
        "pl": "Nazwa hosta", "cs": "Název hostitele", "ko": "호스트 이름", "hi": "होस्टनाम",
    },
    "noSavedResults": {
        "en": "No saved results", "it": "Nessun risultato salvato",
        "es": "Sin resultados guardados", "de": "Keine gespeicherten Ergebnisse",
        "pt": "Sem resultados guardados", "fr": "Aucun résultat enregistré",
        "zh_Hans": "无保存的结果", "zh_Hant": "無已儲存的結果", "ja": "保存された結果はありません",
        "th": "ไม่มีผลลัพธ์ที่บันทึกไว้", "ru": "Нет сохранённых результатов",
        "uk": "Немає збережених результатів", "pl": "Brak zapisanych wyników",
        "cs": "Žádné uložené výsledky", "ko": "저장된 결과 없음", "hi": "कोई सहेजा गया परिणाम नहीं",
    },
    "noNetworkTarget": {
        "en": "No network target set", "it": "Nessuna destinazione di rete impostata",
        "es": "Sin objetivo de red definido", "de": "Kein Netzwerkziel festgelegt",
        "pt": "Nenhum alvo de rede definido", "fr": "Aucune cible réseau définie",
        "zh_Hans": "未设置网络目标", "zh_Hant": "未設定網路目標", "ja": "ネットワーク対象が未設定",
        "th": "ยังไม่ได้ตั้งเป้าหมายเครือข่าย", "ru": "Цель сети не задана",
        "uk": "Ціль мережі не задано", "pl": "Nie ustawiono celu sieci",
        "cs": "Není nastaven cíl sítě", "ko": "네트워크 대상이 설정되지 않음", "hi": "कोई नेटवर्क लक्ष्य सेट नहीं",
    },
    "tapRefreshToScan": {
        "en": "Tap the refresh button to scan",
        "it": "Tocca il pulsante di aggiornamento per scansionare",
        "es": "Toca el botón de actualizar para escanear",
        "de": "Tippe auf die Aktualisieren-Schaltfläche, um zu scannen",
        "pt": "Toque no botão de atualizar para analisar",
        "fr": "Touchez le bouton d'actualisation pour analyser",
        "zh_Hans": "点击刷新按钮进行扫描", "zh_Hant": "點擊重新整理按鈕進行掃描",
        "ja": "更新ボタンをタップしてスキャン", "th": "แตะปุ่มรีเฟรชเพื่อสแกน",
        "ru": "Нажмите кнопку обновления для сканирования",
        "uk": "Натисніть кнопку оновлення для сканування",
        "pl": "Dotknij przycisku odświeżania, aby skanować",
        "cs": "Klepnutím na tlačítko obnovit spustíte skenování",
        "ko": "새로 고침 버튼을 눌러 스캔하세요", "hi": "स्कैन करने के लिए रीफ़्रेश बटन दबाएं",
    },
    "setTargetHome": {
        "en": "Set a target on the Home screen",
        "it": "Imposta una destinazione nella schermata Home",
        "es": "Define un objetivo en la pantalla de inicio",
        "de": "Lege ein Ziel auf dem Startbildschirm fest",
        "pt": "Defina um alvo no ecrã inicial",
        "fr": "Définissez une cible sur l'écran d'accueil",
        "zh_Hans": "在主屏幕上设置目标", "zh_Hant": "在主畫面上設定目標",
        "ja": "ホーム画面で対象を設定してください", "th": "ตั้งเป้าหมายบนหน้าจอหลัก",
        "ru": "Задайте цель на главном экране", "uk": "Задайте ціль на головному екрані",
        "pl": "Ustaw cel na ekranie głównym", "cs": "Nastavte cíl na domovské obrazovce",
        "ko": "홈 화면에서 대상을 설정하세요", "hi": "होम स्क्रीन पर लक्ष्य सेट करें",
    },
    "openInBrowser": {
        "en": "Open in browser (HTTP)", "it": "Apri nel browser (HTTP)",
        "es": "Abrir en el navegador (HTTP)", "de": "Im Browser öffnen (HTTP)",
        "pt": "Abrir no navegador (HTTP)", "fr": "Ouvrir dans le navigateur (HTTP)",
        "zh_Hans": "在浏览器中打开 (HTTP)", "zh_Hant": "在瀏覽器中開啟 (HTTP)",
        "ja": "ブラウザで開く (HTTP)", "th": "เปิดในเบราว์เซอร์ (HTTP)",
        "ru": "Открыть в браузере (HTTP)", "uk": "Відкрити у браузері (HTTP)",
        "pl": "Otwórz w przeglądarce (HTTP)", "cs": "Otevřít v prohlížeči (HTTP)",
        "ko": "브라우저에서 열기 (HTTP)", "hi": "ब्राउज़र में खोलें (HTTP)",
    },
    "openSsh": {
        "en": "Open SSH", "it": "Apri SSH", "es": "Abrir SSH", "de": "SSH öffnen",
        "pt": "Abrir SSH", "fr": "Ouvrir SSH", "zh_Hans": "打开 SSH", "zh_Hant": "開啟 SSH",
        "ja": "SSH を開く", "th": "เปิด SSH", "ru": "Открыть SSH", "uk": "Відкрити SSH",
        "pl": "Otwórz SSH", "cs": "Otevřít SSH", "ko": "SSH 열기", "hi": "SSH खोलें",
    },
    "couldNotOpenBrowser": {
        "en": "Could not open browser", "it": "Impossibile aprire il browser",
        "es": "No se pudo abrir el navegador", "de": "Browser konnte nicht geöffnet werden",
        "pt": "Não foi possível abrir o navegador", "fr": "Impossible d'ouvrir le navigateur",
        "zh_Hans": "无法打开浏览器", "zh_Hant": "無法開啟瀏覽器", "ja": "ブラウザを開けませんでした",
        "th": "ไม่สามารถเปิดเบราว์เซอร์", "ru": "Не удалось открыть браузер",
        "uk": "Не вдалося відкрити браузер", "pl": "Nie można otworzyć przeglądarki",
        "cs": "Nelze otevřít prohlížeč", "ko": "브라우저를 열 수 없습니다", "hi": "ब्राउज़र नहीं खुल सका",
    },
    "noSshApp": {
        "en": "No SSH app found. Install ConnectBot or Termius.",
        "it": "Nessuna app SSH trovata. Installa ConnectBot o Termius.",
        "es": "No se encontró ninguna app SSH. Instala ConnectBot o Termius.",
        "de": "Keine SSH-App gefunden. Installiere ConnectBot oder Termius.",
        "pt": "Nenhuma app SSH encontrada. Instale o ConnectBot ou o Termius.",
        "fr": "Aucune application SSH trouvée. Installez ConnectBot ou Termius.",
        "zh_Hans": "未找到 SSH 应用。请安装 ConnectBot 或 Termius。",
        "zh_Hant": "找不到 SSH 應用程式。請安裝 ConnectBot 或 Termius。",
        "ja": "SSH アプリが見つかりません。ConnectBot または Termius をインストールしてください。",
        "th": "ไม่พบแอป SSH ติดตั้ง ConnectBot หรือ Termius",
        "ru": "Приложение SSH не найдено. Установите ConnectBot или Termius.",
        "uk": "Застосунок SSH не знайдено. Встановіть ConnectBot або Termius.",
        "pl": "Nie znaleziono aplikacji SSH. Zainstaluj ConnectBot lub Termius.",
        "cs": "Nenalezena žádná SSH aplikace. Nainstalujte ConnectBot nebo Termius.",
        "ko": "SSH 앱을 찾을 수 없습니다. ConnectBot 또는 Termius를 설치하세요.",
        "hi": "कोई SSH ऐप नहीं मिला। ConnectBot या Termius इंस्टॉल करें।",
    },
    "deviceInfo": {
        "en": "Device Info", "it": "Info dispositivo", "es": "Info del dispositivo",
        "de": "Geräteinfo", "pt": "Info do dispositivo", "fr": "Infos appareil",
        "zh_Hans": "设备信息", "zh_Hant": "裝置資訊", "ja": "デバイス情報",
        "th": "ข้อมูลอุปกรณ์", "ru": "Сведения об устройстве", "uk": "Відомості про пристрій",
        "pl": "Informacje o urządzeniu", "cs": "Informace o zařízení", "ko": "기기 정보", "hi": "डिवाइस जानकारी",
    },
    "ipAddress": {
        "en": "IP Address", "it": "Indirizzo IP", "es": "Dirección IP",
        "de": "IP-Adresse", "pt": "Endereço IP", "fr": "Adresse IP",
        "zh_Hans": "IP 地址", "zh_Hant": "IP 位址", "ja": "IP アドレス",
        "th": "ที่อยู่ IP", "ru": "IP-адрес", "uk": "IP-адреса",
        "pl": "Adres IP", "cs": "IP adresa", "ko": "IP 주소", "hi": "IP पता",
    },
    "macAddress": {
        "en": "MAC Address", "it": "Indirizzo MAC", "es": "Dirección MAC",
        "de": "MAC-Adresse", "pt": "Endereço MAC", "fr": "Adresse MAC",
        "zh_Hans": "MAC 地址", "zh_Hant": "MAC 位址", "ja": "MAC アドレス",
        "th": "ที่อยู่ MAC", "ru": "MAC-адрес", "uk": "MAC-адреса",
        "pl": "Adres MAC", "cs": "MAC adresa", "ko": "MAC 주소", "hi": "MAC पता",
    },
    "manufacturer": {
        "en": "Manufacturer", "it": "Produttore", "es": "Fabricante",
        "de": "Hersteller", "pt": "Fabricante", "fr": "Fabricant",
        "zh_Hans": "制造商", "zh_Hant": "製造商", "ja": "メーカー",
        "th": "ผู้ผลิต", "ru": "Производитель", "uk": "Виробник",
        "pl": "Producent", "cs": "Výrobce", "ko": "제조사", "hi": "निर्माता",
    },
    "deviceTypeLabel": {
        "en": "Device Type", "it": "Tipo di dispositivo", "es": "Tipo de dispositivo",
        "de": "Gerätetyp", "pt": "Tipo de dispositivo", "fr": "Type d'appareil",
        "zh_Hans": "设备类型", "zh_Hant": "裝置類型", "ja": "デバイスの種類",
        "th": "ประเภทอุปกรณ์", "ru": "Тип устройства", "uk": "Тип пристрою",
        "pl": "Typ urządzenia", "cs": "Typ zařízení", "ko": "기기 유형", "hi": "डिवाइस प्रकार",
    },
    "openPorts": {
        "en": "Open Ports", "it": "Porte aperte", "es": "Puertos abiertos",
        "de": "Offene Ports", "pt": "Portas abertas", "fr": "Ports ouverts",
        "zh_Hans": "开放端口", "zh_Hant": "開放連接埠", "ja": "開いているポート",
        "th": "พอร์ตที่เปิด", "ru": "Открытые порты", "uk": "Відкриті порти",
        "pl": "Otwarte porty", "cs": "Otevřené porty", "ko": "열린 포트", "hi": "खुले पोर्ट",
    },
    "stopPortScan": {
        "en": "Stop port scan", "it": "Ferma scansione porte", "es": "Detener escaneo de puertos",
        "de": "Port-Scan stoppen", "pt": "Parar análise de portas", "fr": "Arrêter l'analyse des ports",
        "zh_Hans": "停止端口扫描", "zh_Hant": "停止連接埠掃描", "ja": "ポートスキャンを停止",
        "th": "หยุดสแกนพอร์ต", "ru": "Остановить сканирование портов", "uk": "Зупинити сканування портів",
        "pl": "Zatrzymaj skanowanie portów", "cs": "Zastavit skenování portů",
        "ko": "포트 스캔 중지", "hi": "पोर्ट स्कैन रोकें",
    },
    "portScanSettings": {
        "en": "Port scan settings", "it": "Impostazioni scansione porte",
        "es": "Ajustes de escaneo de puertos", "de": "Port-Scan-Einstellungen",
        "pt": "Definições da análise de portas", "fr": "Paramètres de l'analyse des ports",
        "zh_Hans": "端口扫描设置", "zh_Hant": "連接埠掃描設定", "ja": "ポートスキャン設定",
        "th": "การตั้งค่าสแกนพอร์ต", "ru": "Настройки сканирования портов",
        "uk": "Налаштування сканування портів", "pl": "Ustawienia skanowania portów",
        "cs": "Nastavení skenování portů", "ko": "포트 스캔 설정", "hi": "पोर्ट स्कैन सेटिंग्स",
    },
    "reScanPorts": {
        "en": "Re-scan ports", "it": "Riscansiona porte", "es": "Reescanear puertos",
        "de": "Ports erneut scannen", "pt": "Analisar portas de novo", "fr": "Relancer l'analyse des ports",
        "zh_Hans": "重新扫描端口", "zh_Hant": "重新掃描連接埠", "ja": "ポートを再スキャン",
        "th": "สแกนพอร์ตใหม่", "ru": "Пересканировать порты", "uk": "Пересканувати порти",
        "pl": "Skanuj porty ponownie", "cs": "Znovu skenovat porty", "ko": "포트 다시 스캔", "hi": "पोर्ट फिर से स्कैन करें",
    },
    "noOpenPorts": {
        "en": "No open ports found.", "it": "Nessuna porta aperta trovata.",
        "es": "No se encontraron puertos abiertos.", "de": "Keine offenen Ports gefunden.",
        "pt": "Nenhuma porta aberta encontrada.", "fr": "Aucun port ouvert trouvé.",
        "zh_Hans": "未找到开放端口。", "zh_Hant": "未找到開放連接埠。", "ja": "開いているポートが見つかりません。",
        "th": "ไม่พบพอร์ตที่เปิด", "ru": "Открытые порты не найдены.", "uk": "Відкритих портів не знайдено.",
        "pl": "Nie znaleziono otwartych portów.", "cs": "Nebyly nalezeny žádné otevřené porty.",
        "ko": "열린 포트를 찾을 수 없습니다.", "hi": "कोई खुला पोर्ट नहीं मिला।",
    },
    "applyRescan": {
        "en": "Apply & Rescan", "it": "Applica e riscansiona",
        "es": "Aplicar y reescanear", "de": "Anwenden & neu scannen",
        "pt": "Aplicar e reanalisar", "fr": "Appliquer et relancer",
        "zh_Hans": "应用并重新扫描", "zh_Hant": "套用並重新掃描", "ja": "適用して再スキャン",
        "th": "ใช้และสแกนใหม่", "ru": "Применить и пересканировать",
        "uk": "Застосувати й пересканувати", "pl": "Zastosuj i skanuj ponownie",
        "cs": "Použít a znovu skenovat", "ko": "적용 및 다시 스캔", "hi": "लागू करें और फिर स्कैन करें",
    },
    "diagnostics": {
        "en": "Diagnostics", "it": "Diagnostica", "es": "Diagnóstico",
        "de": "Diagnose", "pt": "Diagnóstico", "fr": "Diagnostics",
        "zh_Hans": "诊断", "zh_Hant": "診斷", "ja": "診断",
        "th": "การวินิจฉัย", "ru": "Диагностика", "uk": "Діагностика",
        "pl": "Diagnostyka", "cs": "Diagnostika", "ko": "진단", "hi": "निदान",
    },
    "times": {
        "en": "times", "it": "volte", "es": "veces", "de": "mal",
        "pt": "vezes", "fr": "fois", "zh_Hans": "次", "zh_Hant": "次",
        "ja": "回", "th": "ครั้ง", "ru": "раз", "uk": "разів",
        "pl": "razy", "cs": "krát", "ko": "회", "hi": "बार",
    },
    "deleteAllLogs": {
        "en": "Delete all logs", "it": "Elimina tutti i log",
        "es": "Eliminar todos los registros", "de": "Alle Protokolle löschen",
        "pt": "Eliminar todos os registos", "fr": "Supprimer tous les journaux",
        "zh_Hans": "删除所有日志", "zh_Hant": "刪除所有記錄", "ja": "すべてのログを削除",
        "th": "ลบบันทึกทั้งหมด", "ru": "Удалить все журналы", "uk": "Видалити всі журнали",
        "pl": "Usuń wszystkie logi", "cs": "Smazat všechny protokoly",
        "ko": "모든 로그 삭제", "hi": "सभी लॉग हटाएं",
    },
    "deleteAllLogsQ": {
        "en": "Delete all logs?", "it": "Eliminare tutti i log?",
        "es": "¿Eliminar todos los registros?", "de": "Alle Protokolle löschen?",
        "pt": "Eliminar todos os registos?", "fr": "Supprimer tous les journaux ?",
        "zh_Hans": "删除所有日志？", "zh_Hant": "刪除所有記錄？", "ja": "すべてのログを削除しますか？",
        "th": "ลบบันทึกทั้งหมด?", "ru": "Удалить все журналы?", "uk": "Видалити всі журнали?",
        "pl": "Usunąć wszystkie logi?", "cs": "Smazat všechny protokoly?",
        "ko": "모든 로그를 삭제할까요?", "hi": "सभी लॉग हटाएं?",
    },
    "cannotBeUndone": {
        "en": "This cannot be undone.", "it": "Questa azione non può essere annullata.",
        "es": "Esto no se puede deshacer.", "de": "Dies kann nicht rückgängig gemacht werden.",
        "pt": "Isto não pode ser desfeito.", "fr": "Cette action est irréversible.",
        "zh_Hans": "此操作无法撤销。", "zh_Hant": "此操作無法復原。", "ja": "この操作は元に戻せません。",
        "th": "การดำเนินการนี้ไม่สามารถยกเลิกได้", "ru": "Это действие нельзя отменить.",
        "uk": "Цю дію не можна скасувати.", "pl": "Tej operacji nie można cofnąć.",
        "cs": "Tuto akci nelze vrátit zpět.", "ko": "이 작업은 취소할 수 없습니다.",
        "hi": "इसे पूर्ववत नहीं किया जा सकता।",
    },
    "deleteAll": {
        "en": "Delete all", "it": "Elimina tutti", "es": "Eliminar todos",
        "de": "Alle löschen", "pt": "Eliminar tudo", "fr": "Tout supprimer",
        "zh_Hans": "全部删除", "zh_Hant": "全部刪除", "ja": "すべて削除",
        "th": "ลบทั้งหมด", "ru": "Удалить все", "uk": "Видалити всі",
        "pl": "Usuń wszystko", "cs": "Smazat vše", "ko": "모두 삭제", "hi": "सभी हटाएं",
    },
    "deleteLogQ": {
        "en": "Delete log?", "it": "Eliminare il log?", "es": "¿Eliminar registro?",
        "de": "Protokoll löschen?", "pt": "Eliminar registo?", "fr": "Supprimer le journal ?",
        "zh_Hans": "删除日志？", "zh_Hant": "刪除記錄？", "ja": "ログを削除しますか？",
        "th": "ลบบันทึก?", "ru": "Удалить журнал?", "uk": "Видалити журнал?",
        "pl": "Usunąć log?", "cs": "Smazat protokol?", "ko": "로그를 삭제할까요?", "hi": "लॉग हटाएं?",
    },
    "noLogsYet": {
        "en": "No logs yet", "it": "Nessun log ancora", "es": "Aún no hay registros",
        "de": "Noch keine Protokolle", "pt": "Ainda sem registos", "fr": "Aucun journal pour l'instant",
        "zh_Hans": "暂无日志", "zh_Hant": "尚無記錄", "ja": "ログはまだありません",
        "th": "ยังไม่มีบันทึก", "ru": "Пока нет журналов", "uk": "Ще немає журналів",
        "pl": "Brak logów", "cs": "Zatím žádné protokoly", "ko": "아직 로그가 없습니다", "hi": "अभी तक कोई लॉग नहीं",
    },
    "scanningEllipsis": {
        "en": "Scanning…", "it": "Scansione…", "es": "Escaneando…",
        "de": "Scannen…", "pt": "A analisar…", "fr": "Analyse…",
        "zh_Hans": "扫描中…", "zh_Hant": "掃描中…", "ja": "スキャン中…",
        "th": "กำลังสแกน…", "ru": "Сканирование…", "uk": "Сканування…",
        "pl": "Skanowanie…", "cs": "Skenování…", "ko": "스캔 중…", "hi": "स्कैन हो रहा है…",
    },
    "iotDevicesFound": {
        "en": "IoT device(s) found", "it": "dispositivi IoT trovati",
        "es": "dispositivos IoT encontrados", "de": "IoT-Gerät(e) gefunden",
        "pt": "dispositivos IoT encontrados", "fr": "appareil(s) IoT trouvé(s)",
        "zh_Hans": "个 IoT 设备", "zh_Hant": "個 IoT 裝置", "ja": "台の IoT デバイスを検出",
        "th": "อุปกรณ์ IoT ที่พบ", "ru": "устройств IoT найдено", "uk": "пристроїв IoT знайдено",
        "pl": "znalezionych urządzeń IoT", "cs": "nalezených zařízení IoT",
        "ko": "개 IoT 기기 발견", "hi": "IoT डिवाइस मिले",
    },
    "iotNoSaved": {
        "en": "No saved results.\nTap refresh to scan.",
        "it": "Nessun risultato salvato.\nTocca aggiorna per scansionare.",
        "es": "Sin resultados guardados.\nToca actualizar para escanear.",
        "de": "Keine gespeicherten Ergebnisse.\nZum Scannen aktualisieren.",
        "pt": "Sem resultados guardados.\nToque em atualizar para analisar.",
        "fr": "Aucun résultat enregistré.\nActualisez pour analyser.",
        "zh_Hans": "无保存的结果。\n点击刷新进行扫描。", "zh_Hant": "無已儲存的結果。\n點擊重新整理進行掃描。",
        "ja": "保存された結果はありません。\n更新してスキャンしてください。",
        "th": "ไม่มีผลลัพธ์ที่บันทึกไว้\nแตะรีเฟรชเพื่อสแกน",
        "ru": "Нет сохранённых результатов.\nНажмите обновить для сканирования.",
        "uk": "Немає збережених результатів.\nНатисніть оновити для сканування.",
        "pl": "Brak zapisanych wyników.\nDotknij odśwież, aby skanować.",
        "cs": "Žádné uložené výsledky.\nKlepnutím na obnovit spustíte skenování.",
        "ko": "저장된 결과 없음.\n새로 고침을 눌러 스캔하세요.",
        "hi": "कोई सहेजा गया परिणाम नहीं।\nस्कैन करने के लिए रीफ़्रेश दबाएं।",
    },
    "unknown": {
        "en": "Unknown", "it": "Sconosciuto", "es": "Desconocido",
        "de": "Unbekannt", "pt": "Desconhecido", "fr": "Inconnu",
        "zh_Hans": "未知", "zh_Hant": "未知", "ja": "不明",
        "th": "ไม่ทราบ", "ru": "Неизвестно", "uk": "Невідомо",
        "pl": "Nieznany", "cs": "Neznámé", "ko": "알 수 없음", "hi": "अज्ञात",
    },
    "viaLabel": {
        "en": "via", "it": "tramite", "es": "vía", "de": "über",
        "pt": "via", "fr": "via", "zh_Hans": "通过", "zh_Hant": "透過",
        "ja": "経由", "th": "ผ่าน", "ru": "через", "uk": "через",
        "pl": "przez", "cs": "přes", "ko": "경유", "hi": "के द्वारा",
    },
    "confDefinite": {
        "en": "definite", "it": "certo", "es": "seguro", "de": "sicher",
        "pt": "definido", "fr": "certain", "zh_Hans": "确定", "zh_Hant": "確定",
        "ja": "確実", "th": "แน่นอน", "ru": "точно", "uk": "точно",
        "pl": "pewne", "cs": "jisté", "ko": "확실", "hi": "निश्चित",
    },
    "confProbable": {
        "en": "probable", "it": "probabile", "es": "probable", "de": "wahrscheinlich",
        "pt": "provável", "fr": "probable", "zh_Hans": "可能", "zh_Hant": "可能",
        "ja": "たぶん", "th": "น่าจะ", "ru": "вероятно", "uk": "ймовірно",
        "pl": "prawdopodobne", "cs": "pravděpodobné", "ko": "가능성 높음", "hi": "संभावित",
    },
    "confPossible": {
        "en": "possible", "it": "possibile", "es": "posible", "de": "möglich",
        "pt": "possível", "fr": "possible", "zh_Hans": "或许", "zh_Hant": "或許",
        "ja": "可能性あり", "th": "อาจ", "ru": "возможно", "uk": "можливо",
        "pl": "możliwe", "cs": "možné", "ko": "가능", "hi": "मुमकिन",
    },
    "ipCameraScan": {
        "en": "IP Camera Scan", "it": "Scansione telecamere IP",
        "es": "Escaneo de cámaras IP", "de": "IP-Kamera-Scan",
        "pt": "Análise de câmaras IP", "fr": "Analyse des caméras IP",
        "zh_Hans": "IP 摄像头扫描", "zh_Hant": "IP 攝影機掃描", "ja": "IP カメラスキャン",
        "th": "สแกนกล้อง IP", "ru": "Сканирование IP-камер", "uk": "Сканування IP-камер",
        "pl": "Skanowanie kamer IP", "cs": "Skenování IP kamer", "ko": "IP 카메라 스캔", "hi": "IP कैमरा स्कैन",
    },
    "camMethodProtocolPort": {
        "en": "Protocol port", "it": "Porta protocollo", "es": "Puerto de protocolo",
        "de": "Protokoll-Port", "pt": "Porta de protocolo", "fr": "Port de protocole",
        "zh_Hans": "协议端口", "zh_Hant": "協定連接埠", "ja": "プロトコルポート",
        "th": "พอร์ตโปรโตคอล", "ru": "Порт протокола", "uk": "Порт протоколу",
        "pl": "Port protokołu", "cs": "Port protokolu", "ko": "프로토콜 포트", "hi": "प्रोटोकॉल पोर्ट",
    },
    "camMethodKnownVendor": {
        "en": "Known vendor", "it": "Produttore noto", "es": "Fabricante conocido",
        "de": "Bekannter Hersteller", "pt": "Fabricante conhecido", "fr": "Fabricant connu",
        "zh_Hans": "已知厂商", "zh_Hant": "已知廠商", "ja": "既知のベンダー",
        "th": "ผู้ผลิตที่รู้จัก", "ru": "Известный производитель", "uk": "Відомий виробник",
        "pl": "Znany producent", "cs": "Známý výrobce", "ko": "알려진 제조사", "hi": "ज्ञात विक्रेता",
    },
    "camMethodHttpFingerprint": {
        "en": "HTTP fingerprint", "it": "Impronta HTTP", "es": "Huella HTTP",
        "de": "HTTP-Fingerabdruck", "pt": "Impressão HTTP", "fr": "Empreinte HTTP",
        "zh_Hans": "HTTP 指纹", "zh_Hant": "HTTP 指紋", "ja": "HTTP フィンガープリント",
        "th": "ลายนิ้วมือ HTTP", "ru": "HTTP-отпечаток", "uk": "HTTP-відбиток",
        "pl": "Odcisk HTTP", "cs": "Otisk HTTP", "ko": "HTTP 지문", "hi": "HTTP फ़िंगरप्रिंट",
    },
    "camMethodWsDiscovery": {
        "en": "WS-Discovery", "it": "WS-Discovery", "es": "WS-Discovery",
        "de": "WS-Discovery", "pt": "WS-Discovery", "fr": "WS-Discovery",
        "zh_Hans": "WS-Discovery", "zh_Hant": "WS-Discovery", "ja": "WS-Discovery",
        "th": "WS-Discovery", "ru": "WS-Discovery", "uk": "WS-Discovery",
        "pl": "WS-Discovery", "cs": "WS-Discovery", "ko": "WS-Discovery", "hi": "WS-Discovery",
    },
    "camScanningStatus": {
        "en": "Scanning… {done}/{total} hosts — {n} camera(s)",
        "it": "Scansione… {done}/{total} host — {n} telecamere",
        "es": "Escaneando… {done}/{total} hosts — {n} cámara(s)",
        "de": "Scannen… {done}/{total} Hosts — {n} Kamera(s)",
        "pt": "A analisar… {done}/{total} hosts — {n} câmara(s)",
        "fr": "Analyse… {done}/{total} hôtes — {n} caméra(s)",
        "zh_Hans": "扫描中… {done}/{total} 主机 — {n} 个摄像头",
        "zh_Hant": "掃描中… {done}/{total} 主機 — {n} 個攝影機",
        "ja": "スキャン中… {done}/{total} ホスト — カメラ {n} 台",
        "th": "กำลังสแกน… {done}/{total} โฮสต์ — {n} กล้อง",
        "ru": "Сканирование… {done}/{total} хостов — {n} камер",
        "uk": "Сканування… {done}/{total} хостів — {n} камер",
        "pl": "Skanowanie… {done}/{total} hostów — {n} kamer",
        "cs": "Skenování… {done}/{total} hostitelů — {n} kamer",
        "ko": "스캔 중… {done}/{total} 호스트 — 카메라 {n}대",
        "hi": "स्कैन हो रहा है… {done}/{total} होस्ट — {n} कैमरे",
    },
    "camNoSaved": {
        "en": "No saved results — tap refresh to scan {cidr}",
        "it": "Nessun risultato salvato — tocca aggiorna per scansionare {cidr}",
        "es": "Sin resultados guardados — toca actualizar para escanear {cidr}",
        "de": "Keine gespeicherten Ergebnisse — zum Scannen von {cidr} aktualisieren",
        "pt": "Sem resultados guardados — toque em atualizar para analisar {cidr}",
        "fr": "Aucun résultat enregistré — actualisez pour analyser {cidr}",
        "zh_Hans": "无保存的结果 — 点击刷新以扫描 {cidr}",
        "zh_Hant": "無已儲存的結果 — 點擊重新整理以掃描 {cidr}",
        "ja": "保存された結果はありません — 更新して {cidr} をスキャン",
        "th": "ไม่มีผลลัพธ์ที่บันทึกไว้ — แตะรีเฟรชเพื่อสแกน {cidr}",
        "ru": "Нет сохранённых результатов — нажмите обновить для сканирования {cidr}",
        "uk": "Немає збережених результатів — натисніть оновити для сканування {cidr}",
        "pl": "Brak zapisanych wyników — dotknij odśwież, aby skanować {cidr}",
        "cs": "Žádné uložené výsledky — klepnutím na obnovit prohledáte {cidr}",
        "ko": "저장된 결과 없음 — 새로 고침을 눌러 {cidr} 스캔",
        "hi": "कोई सहेजा गया परिणाम नहीं — {cidr} स्कैन करने के लिए रीफ़्रेश दबाएं",
    },
    "camFound": {
        "en": "{n} camera(s) found — {cidr}",
        "it": "{n} telecamere trovate — {cidr}",
        "es": "{n} cámara(s) encontradas — {cidr}",
        "de": "{n} Kamera(s) gefunden — {cidr}",
        "pt": "{n} câmara(s) encontradas — {cidr}",
        "fr": "{n} caméra(s) trouvée(s) — {cidr}",
        "zh_Hans": "找到 {n} 个摄像头 — {cidr}",
        "zh_Hant": "找到 {n} 個攝影機 — {cidr}",
        "ja": "カメラ {n} 台を検出 — {cidr}",
        "th": "พบ {n} กล้อง — {cidr}",
        "ru": "Найдено камер: {n} — {cidr}",
        "uk": "Знайдено камер: {n} — {cidr}",
        "pl": "Znaleziono {n} kamer — {cidr}",
        "cs": "Nalezeno {n} kamer — {cidr}",
        "ko": "카메라 {n}대 발견 — {cidr}",
        "hi": "{n} कैमरे मिले — {cidr}",
    },
    "noCamerasFound": {
        "en": "No cameras found.", "it": "Nessuna telecamera trovata.",
        "es": "No se encontraron cámaras.", "de": "Keine Kameras gefunden.",
        "pt": "Nenhuma câmara encontrada.", "fr": "Aucune caméra trouvée.",
        "zh_Hans": "未找到摄像头。", "zh_Hant": "未找到攝影機。", "ja": "カメラが見つかりません。",
        "th": "ไม่พบกล้อง", "ru": "Камеры не найдены.", "uk": "Камер не знайдено.",
        "pl": "Nie znaleziono kamer.", "cs": "Nebyly nalezeny žádné kamery.",
        "ko": "카메라를 찾을 수 없습니다.", "hi": "कोई कैमरा नहीं मिला।",
    },
    "mqttSettingsTitle": {
        "en": "MQTT Settings", "it": "Impostazioni MQTT", "es": "Ajustes MQTT",
        "de": "MQTT-Einstellungen", "pt": "Definições MQTT", "fr": "Paramètres MQTT",
        "zh_Hans": "MQTT 设置", "zh_Hant": "MQTT 設定", "ja": "MQTT 設定",
        "th": "การตั้งค่า MQTT", "ru": "Настройки MQTT", "uk": "Налаштування MQTT",
        "pl": "Ustawienia MQTT", "cs": "Nastavení MQTT", "ko": "MQTT 설정", "hi": "MQTT सेटिंग्स",
    },
    "brokerIpFqdn": {
        "en": "Broker IP / FQDN", "it": "IP / FQDN del broker",
        "es": "IP / FQDN del broker", "de": "Broker-IP / FQDN",
        "pt": "IP / FQDN do broker", "fr": "IP / FQDN du broker",
        "zh_Hans": "代理 IP / FQDN", "zh_Hant": "代理 IP / FQDN", "ja": "ブローカー IP / FQDN",
        "th": "IP / FQDN ของโบรกเกอร์", "ru": "IP / FQDN брокера", "uk": "IP / FQDN брокера",
        "pl": "IP / FQDN brokera", "cs": "IP / FQDN brokera", "ko": "브로커 IP / FQDN", "hi": "ब्रोकर IP / FQDN",
    },
    "searchingSubnet": {
        "en": "Searching subnet…", "it": "Ricerca nella subnet…",
        "es": "Buscando en la subred…", "de": "Subnetz wird durchsucht…",
        "pt": "A procurar na sub-rede…", "fr": "Recherche du sous-réseau…",
        "zh_Hans": "正在搜索子网…", "zh_Hant": "正在搜尋子網路…", "ja": "サブネットを検索中…",
        "th": "กำลังค้นหาซับเน็ต…", "ru": "Поиск в подсети…", "uk": "Пошук у підмережі…",
        "pl": "Przeszukiwanie podsieci…", "cs": "Prohledávání podsítě…",
        "ko": "서브넷 검색 중…", "hi": "सबनेट खोजा जा रहा है…",
    },
    "brokerHint": {
        "en": "e.g. 192.168.1.10 or broker.example.com",
        "it": "es. 192.168.1.10 o broker.example.com",
        "es": "p. ej. 192.168.1.10 o broker.example.com",
        "de": "z. B. 192.168.1.10 oder broker.example.com",
        "pt": "ex. 192.168.1.10 ou broker.example.com",
        "fr": "ex. 192.168.1.10 ou broker.example.com",
        "zh_Hans": "例如 192.168.1.10 或 broker.example.com",
        "zh_Hant": "例如 192.168.1.10 或 broker.example.com",
        "ja": "例: 192.168.1.10 または broker.example.com",
        "th": "เช่น 192.168.1.10 หรือ broker.example.com",
        "ru": "напр. 192.168.1.10 или broker.example.com",
        "uk": "напр. 192.168.1.10 або broker.example.com",
        "pl": "np. 192.168.1.10 lub broker.example.com",
        "cs": "např. 192.168.1.10 nebo broker.example.com",
        "ko": "예: 192.168.1.10 또는 broker.example.com",
        "hi": "उदा. 192.168.1.10 या broker.example.com",
    },
    "portLabel": {
        "en": "Port", "it": "Porta", "es": "Puerto", "de": "Port",
        "pt": "Porta", "fr": "Port", "zh_Hans": "端口", "zh_Hant": "連接埠",
        "ja": "ポート", "th": "พอร์ต", "ru": "Порт", "uk": "Порт",
        "pl": "Port", "cs": "Port", "ko": "포트", "hi": "पोर्ट",
    },
    "usernameOptional": {
        "en": "Username (optional)", "it": "Nome utente (opzionale)",
        "es": "Usuario (opcional)", "de": "Benutzername (optional)",
        "pt": "Nome de utilizador (opcional)", "fr": "Nom d'utilisateur (facultatif)",
        "zh_Hans": "用户名（可选）", "zh_Hant": "使用者名稱（選填）", "ja": "ユーザー名（任意）",
        "th": "ชื่อผู้ใช้ (ไม่บังคับ)", "ru": "Имя пользователя (необязательно)",
        "uk": "Ім'я користувача (необов'язково)", "pl": "Nazwa użytkownika (opcjonalnie)",
        "cs": "Uživatelské jméno (volitelné)", "ko": "사용자 이름 (선택)", "hi": "उपयोगकर्ता नाम (वैकल्पिक)",
    },
    "leaveEmptyOptional": {
        "en": "leave empty if not required", "it": "lascia vuoto se non richiesto",
        "es": "déjalo vacío si no es necesario", "de": "leer lassen, falls nicht erforderlich",
        "pt": "deixe vazio se não for necessário", "fr": "laisser vide si non requis",
        "zh_Hans": "如不需要请留空", "zh_Hant": "如不需要請留空", "ja": "不要な場合は空欄のまま",
        "th": "เว้นว่างไว้หากไม่จำเป็น", "ru": "оставьте пустым, если не требуется",
        "uk": "залиште порожнім, якщо не потрібно", "pl": "pozostaw puste, jeśli nie jest wymagane",
        "cs": "ponechte prázdné, pokud není vyžadováno", "ko": "필요하지 않으면 비워 두세요",
        "hi": "यदि आवश्यक न हो तो खाली छोड़ें",
    },
    "passwordOptional": {
        "en": "Password (optional)", "it": "Password (opzionale)",
        "es": "Contraseña (opcional)", "de": "Passwort (optional)",
        "pt": "Palavra-passe (opcional)", "fr": "Mot de passe (facultatif)",
        "zh_Hans": "密码（可选）", "zh_Hant": "密碼（選填）", "ja": "パスワード（任意）",
        "th": "รหัสผ่าน (ไม่บังคับ)", "ru": "Пароль (необязательно)",
        "uk": "Пароль (необов'язково)", "pl": "Hasło (opcjonalnie)",
        "cs": "Heslo (volitelné)", "ko": "비밀번호 (선택)", "hi": "पासवर्ड (वैकल्पिक)",
    },
    "keepPassword": {
        "en": "Keep password (not recommended)",
        "it": "Conserva password (sconsigliato)",
        "es": "Guardar contraseña (no recomendado)",
        "de": "Passwort speichern (nicht empfohlen)",
        "pt": "Guardar palavra-passe (não recomendado)",
        "fr": "Conserver le mot de passe (déconseillé)",
        "zh_Hans": "保存密码（不推荐）", "zh_Hant": "儲存密碼（不建議）",
        "ja": "パスワードを保存（非推奨）", "th": "เก็บรหัสผ่าน (ไม่แนะนำ)",
        "ru": "Сохранять пароль (не рекомендуется)",
        "uk": "Зберігати пароль (не рекомендовано)",
        "pl": "Zachowaj hasło (niezalecane)", "cs": "Uchovat heslo (nedoporučeno)",
        "ko": "비밀번호 저장 (권장하지 않음)", "hi": "पासवर्ड रखें (अनुशंसित नहीं)",
    },
    "keepPasswordSub": {
        "en": "Password is stored in plain text in app storage.",
        "it": "La password è salvata in chiaro nella memoria dell'app.",
        "es": "La contraseña se guarda en texto plano en el almacenamiento de la app.",
        "de": "Das Passwort wird im Klartext im App-Speicher abgelegt.",
        "pt": "A palavra-passe é guardada em texto simples no armazenamento da app.",
        "fr": "Le mot de passe est stocké en clair dans le stockage de l'app.",
        "zh_Hans": "密码以明文形式存储在应用存储中。",
        "zh_Hant": "密碼以明文形式儲存在應用程式儲存空間中。",
        "ja": "パスワードはアプリのストレージに平文で保存されます。",
        "th": "รหัสผ่านถูกจัดเก็บเป็นข้อความธรรมดาในที่จัดเก็บของแอป",
        "ru": "Пароль хранится в открытом виде в хранилище приложения.",
        "uk": "Пароль зберігається у відкритому вигляді в сховищі застосунку.",
        "pl": "Hasło jest przechowywane jako zwykły tekst w pamięci aplikacji.",
        "cs": "Heslo je uloženo jako prostý text v úložišti aplikace.",
        "ko": "비밀번호는 앱 저장소에 평문으로 저장됩니다.",
        "hi": "पासवर्ड ऐप स्टोरेज में सादे टेक्स्ट में संग्रहीत होता है।",
    },
    "save": {
        "en": "Save", "it": "Salva", "es": "Guardar", "de": "Speichern",
        "pt": "Guardar", "fr": "Enregistrer", "zh_Hans": "保存", "zh_Hant": "儲存",
        "ja": "保存", "th": "บันทึก", "ru": "Сохранить", "uk": "Зберегти",
        "pl": "Zapisz", "cs": "Uložit", "ko": "저장", "hi": "सहेजें",
    },
    "screenStaysOn": {
        "en": "Screen stays on", "it": "Schermo sempre acceso",
        "es": "La pantalla permanece encendida", "de": "Bildschirm bleibt an",
        "pt": "Ecrã permanece ligado", "fr": "L'écran reste allumé",
        "zh_Hans": "屏幕保持常亮", "zh_Hant": "螢幕保持常亮", "ja": "画面をオンのままにする",
        "th": "หน้าจอเปิดตลอด", "ru": "Экран не гаснет", "uk": "Екран не гасне",
        "pl": "Ekran pozostaje włączony", "cs": "Obrazovka zůstává zapnutá",
        "ko": "화면 켜짐 유지", "hi": "स्क्रीन चालू रहती है",
    },
    "screenMaySleep": {
        "en": "Screen may sleep", "it": "Lo schermo può spegnersi",
        "es": "La pantalla puede apagarse", "de": "Bildschirm kann sich abschalten",
        "pt": "O ecrã pode desligar-se", "fr": "L'écran peut s'éteindre",
        "zh_Hans": "屏幕可能休眠", "zh_Hant": "螢幕可能休眠", "ja": "画面がスリープする場合があります",
        "th": "หน้าจออาจดับ", "ru": "Экран может погаснуть", "uk": "Екран може згаснути",
        "pl": "Ekran może się wyłączyć", "cs": "Obrazovka může zhasnout",
        "ko": "화면이 꺼질 수 있음", "hi": "स्क्रीन बंद हो सकती है",
    },
    "mqttSubscribe": {
        "en": "MQTT Subscribe", "it": "MQTT Subscribe", "es": "MQTT Subscribe",
        "de": "MQTT Subscribe", "pt": "MQTT Subscribe", "fr": "MQTT Subscribe",
        "zh_Hans": "MQTT 订阅", "zh_Hant": "MQTT 訂閱", "ja": "MQTT 購読",
        "th": "MQTT Subscribe", "ru": "MQTT Подписка", "uk": "MQTT Підписка",
        "pl": "MQTT Subscribe", "cs": "MQTT Subscribe", "ko": "MQTT 구독", "hi": "MQTT सब्सक्राइब",
    },
    "mqttPublish": {
        "en": "MQTT Publish", "it": "MQTT Publish", "es": "MQTT Publish",
        "de": "MQTT Publish", "pt": "MQTT Publish", "fr": "MQTT Publish",
        "zh_Hans": "MQTT 发布", "zh_Hant": "MQTT 發布", "ja": "MQTT 発行",
        "th": "MQTT Publish", "ru": "MQTT Публикация", "uk": "MQTT Публікація",
        "pl": "MQTT Publish", "cs": "MQTT Publish", "ko": "MQTT 게시", "hi": "MQTT पब्लिश",
    },
    "topicLabel": {
        "en": "Topic", "it": "Argomento", "es": "Tema", "de": "Thema",
        "pt": "Tópico", "fr": "Sujet", "zh_Hans": "主题", "zh_Hant": "主題",
        "ja": "トピック", "th": "หัวข้อ", "ru": "Топик", "uk": "Тема",
        "pl": "Temat", "cs": "Téma", "ko": "토픽", "hi": "टॉपिक",
    },
    "topicSubHint": {
        "en": "e.g. home/sensor/# or home/sensor/temp",
        "it": "es. home/sensor/# o home/sensor/temp",
        "es": "p. ej. home/sensor/# o home/sensor/temp",
        "de": "z. B. home/sensor/# oder home/sensor/temp",
        "pt": "ex. home/sensor/# ou home/sensor/temp",
        "fr": "ex. home/sensor/# ou home/sensor/temp",
        "zh_Hans": "例如 home/sensor/# 或 home/sensor/temp",
        "zh_Hant": "例如 home/sensor/# 或 home/sensor/temp",
        "ja": "例: home/sensor/# または home/sensor/temp",
        "th": "เช่น home/sensor/# หรือ home/sensor/temp",
        "ru": "напр. home/sensor/# или home/sensor/temp",
        "uk": "напр. home/sensor/# або home/sensor/temp",
        "pl": "np. home/sensor/# lub home/sensor/temp",
        "cs": "např. home/sensor/# nebo home/sensor/temp",
        "ko": "예: home/sensor/# 또는 home/sensor/temp",
        "hi": "उदा. home/sensor/# या home/sensor/temp",
    },
    "listen": {
        "en": "Listen", "it": "Ascolta", "es": "Escuchar", "de": "Empfangen",
        "pt": "Ouvir", "fr": "Écouter", "zh_Hans": "监听", "zh_Hant": "監聽",
        "ja": "受信", "th": "ฟัง", "ru": "Слушать", "uk": "Слухати",
        "pl": "Nasłuchuj", "cs": "Naslouchat", "ko": "수신", "hi": "सुनें",
    },
    "humanReadableJson": {
        "en": "Human-readable JSON", "it": "JSON leggibile",
        "es": "JSON legible", "de": "Lesbares JSON",
        "pt": "JSON legível", "fr": "JSON lisible",
        "zh_Hans": "易读 JSON", "zh_Hant": "易讀 JSON", "ja": "読みやすい JSON",
        "th": "JSON ที่อ่านง่าย", "ru": "Читаемый JSON", "uk": "Читабельний JSON",
        "pl": "Czytelny JSON", "cs": "Čitelný JSON", "ko": "읽기 쉬운 JSON", "hi": "पठनीय JSON",
    },
    "waitingForMessages": {
        "en": "Waiting for messages…", "it": "In attesa di messaggi…",
        "es": "Esperando mensajes…", "de": "Warte auf Nachrichten…",
        "pt": "À espera de mensagens…", "fr": "En attente de messages…",
        "zh_Hans": "正在等待消息…", "zh_Hant": "正在等待訊息…", "ja": "メッセージを待機中…",
        "th": "กำลังรอข้อความ…", "ru": "Ожидание сообщений…", "uk": "Очікування повідомлень…",
        "pl": "Oczekiwanie na wiadomości…", "cs": "Čekání na zprávy…",
        "ko": "메시지 대기 중…", "hi": "संदेशों की प्रतीक्षा…",
    },
    "enterTopicListen": {
        "en": "Enter a topic and tap Listen",
        "it": "Inserisci un argomento e tocca Ascolta",
        "es": "Introduce un tema y toca Escuchar",
        "de": "Thema eingeben und auf Empfangen tippen",
        "pt": "Introduza um tópico e toque em Ouvir",
        "fr": "Saisissez un sujet et touchez Écouter",
        "zh_Hans": "输入主题并点击监听", "zh_Hant": "輸入主題並點擊監聽",
        "ja": "トピックを入力して受信をタップ", "th": "ป้อนหัวข้อแล้วแตะฟัง",
        "ru": "Введите топик и нажмите Слушать", "uk": "Введіть тему й натисніть Слухати",
        "pl": "Wpisz temat i dotknij Nasłuchuj", "cs": "Zadejte téma a klepněte na Naslouchat",
        "ko": "토픽을 입력하고 수신을 누르세요", "hi": "एक टॉपिक दर्ज करें और सुनें दबाएं",
    },
    "tapListenReceive": {
        "en": "Tap Listen to start receiving",
        "it": "Tocca Ascolta per iniziare a ricevere",
        "es": "Toca Escuchar para empezar a recibir",
        "de": "Auf Empfangen tippen, um zu empfangen",
        "pt": "Toque em Ouvir para começar a receber",
        "fr": "Touchez Écouter pour commencer à recevoir",
        "zh_Hans": "点击监听开始接收", "zh_Hant": "點擊監聽開始接收",
        "ja": "受信をタップして受信開始", "th": "แตะฟังเพื่อเริ่มรับ",
        "ru": "Нажмите Слушать, чтобы начать приём", "uk": "Натисніть Слухати, щоб почати отримання",
        "pl": "Dotknij Nasłuchuj, aby zacząć odbierać", "cs": "Klepnutím na Naslouchat začnete přijímat",
        "ko": "수신을 눌러 수신을 시작하세요", "hi": "प्राप्त करना शुरू करने के लिए सुनें दबाएं",
    },
    "enterTopicTapListen": {
        "en": "Enter the topic and tap Listen",
        "it": "Inserisci l'argomento e tocca Ascolta",
        "es": "Introduce el tema y toca Escuchar",
        "de": "Thema eingeben und auf Empfangen tippen",
        "pt": "Introduza o tópico e toque em Ouvir",
        "fr": "Saisissez le sujet et touchez Écouter",
        "zh_Hans": "输入主题并点击监听", "zh_Hant": "輸入主題並點擊監聽",
        "ja": "トピックを入力して受信をタップ", "th": "ป้อนหัวข้อแล้วแตะฟัง",
        "ru": "Введите топик и нажмите Слушать", "uk": "Введіть тему й натисніть Слухати",
        "pl": "Wpisz temat i dotknij Nasłuchuj", "cs": "Zadejte téma a klepněte na Naslouchat",
        "ko": "토픽을 입력하고 수신을 누르세요", "hi": "टॉपिक दर्ज करें और सुनें दबाएं",
    },
    "enterTopicFirst": {
        "en": "Enter a topic first.", "it": "Inserisci prima un argomento.",
        "es": "Primero introduce un tema.", "de": "Bitte zuerst ein Thema eingeben.",
        "pt": "Introduza primeiro um tópico.", "fr": "Saisissez d'abord un sujet.",
        "zh_Hans": "请先输入主题。", "zh_Hant": "請先輸入主題。", "ja": "先にトピックを入力してください。",
        "th": "กรุณาป้อนหัวข้อก่อน", "ru": "Сначала введите топик.", "uk": "Спершу введіть тему.",
        "pl": "Najpierw wpisz temat.", "cs": "Nejprve zadejte téma.",
        "ko": "먼저 토픽을 입력하세요.", "hi": "पहले एक टॉपिक दर्ज करें।",
    },
    "stoppedStatus": {
        "en": "Stopped.", "it": "Fermato.", "es": "Detenido.", "de": "Gestoppt.",
        "pt": "Parado.", "fr": "Arrêté.", "zh_Hans": "已停止。", "zh_Hant": "已停止。",
        "ja": "停止しました。", "th": "หยุดแล้ว", "ru": "Остановлено.", "uk": "Зупинено.",
        "pl": "Zatrzymano.", "cs": "Zastaveno.", "ko": "중지됨.", "hi": "रुक गया।",
    },
    "connectingStatus": {
        "en": "Connecting…", "it": "Connessione…", "es": "Conectando…",
        "de": "Verbinde…", "pt": "A ligar…", "fr": "Connexion…",
        "zh_Hans": "连接中…", "zh_Hant": "連線中…", "ja": "接続中…",
        "th": "กำลังเชื่อมต่อ…", "ru": "Подключение…", "uk": "Підключення…",
        "pl": "Łączenie…", "cs": "Připojování…", "ko": "연결 중…", "hi": "कनेक्ट हो रहा है…",
    },
    "reconnectingStatus": {
        "en": "Reconnecting…", "it": "Riconnessione…", "es": "Reconectando…",
        "de": "Verbinde erneut…", "pt": "A religar…", "fr": "Reconnexion…",
        "zh_Hans": "重新连接中…", "zh_Hant": "重新連線中…", "ja": "再接続中…",
        "th": "กำลังเชื่อมต่อใหม่…", "ru": "Переподключение…", "uk": "Перепідключення…",
        "pl": "Ponowne łączenie…", "cs": "Opětovné připojování…", "ko": "재연결 중…", "hi": "फिर से कनेक्ट हो रहा है…",
    },
    "listeningOn": {
        "en": "Listening on \"{topic}\"", "it": "In ascolto su \"{topic}\"",
        "es": "Escuchando en \"{topic}\"", "de": "Empfange auf \"{topic}\"",
        "pt": "A ouvir em \"{topic}\"", "fr": "Écoute sur \"{topic}\"",
        "zh_Hans": "正在监听 \"{topic}\"", "zh_Hant": "正在監聽 \"{topic}\"",
        "ja": "\"{topic}\" を受信中", "th": "กำลังฟังบน \"{topic}\"",
        "ru": "Прослушивание \"{topic}\"", "uk": "Прослуховування \"{topic}\"",
        "pl": "Nasłuchiwanie na \"{topic}\"", "cs": "Naslouchání na \"{topic}\"",
        "ko": "\"{topic}\" 수신 중", "hi": "\"{topic}\" पर सुन रहे हैं",
    },
    "connFailed": {
        "en": "Connection failed: {e}", "it": "Connessione fallita: {e}",
        "es": "Conexión fallida: {e}", "de": "Verbindung fehlgeschlagen: {e}",
        "pt": "Ligação falhou: {e}", "fr": "Échec de la connexion : {e}",
        "zh_Hans": "连接失败：{e}", "zh_Hant": "連線失敗：{e}", "ja": "接続に失敗しました: {e}",
        "th": "การเชื่อมต่อล้มเหลว: {e}", "ru": "Ошибка подключения: {e}",
        "uk": "Помилка підключення: {e}", "pl": "Połączenie nie powiodło się: {e}",
        "cs": "Připojení selhalo: {e}", "ko": "연결 실패: {e}", "hi": "कनेक्शन विफल: {e}",
    },
    "topicPubHint": {
        "en": "e.g. home/light/switch", "it": "es. home/light/switch",
        "es": "p. ej. home/light/switch", "de": "z. B. home/light/switch",
        "pt": "ex. home/light/switch", "fr": "ex. home/light/switch",
        "zh_Hans": "例如 home/light/switch", "zh_Hant": "例如 home/light/switch",
        "ja": "例: home/light/switch", "th": "เช่น home/light/switch",
        "ru": "напр. home/light/switch", "uk": "напр. home/light/switch",
        "pl": "np. home/light/switch", "cs": "např. home/light/switch",
        "ko": "예: home/light/switch", "hi": "उदा. home/light/switch",
    },
    "messageLabel": {
        "en": "Message", "it": "Messaggio", "es": "Mensaje", "de": "Nachricht",
        "pt": "Mensagem", "fr": "Message", "zh_Hans": "消息", "zh_Hant": "訊息",
        "ja": "メッセージ", "th": "ข้อความ", "ru": "Сообщение", "uk": "Повідомлення",
        "pl": "Wiadomość", "cs": "Zpráva", "ko": "메시지", "hi": "संदेश",
    },
    "enterPayload": {
        "en": "Enter payload…", "it": "Inserisci il payload…",
        "es": "Introduce el contenido…", "de": "Nutzdaten eingeben…",
        "pt": "Introduza o conteúdo…", "fr": "Saisir la charge utile…",
        "zh_Hans": "输入负载…", "zh_Hant": "輸入負載…", "ja": "ペイロードを入力…",
        "th": "ป้อนเพย์โหลด…", "ru": "Введите данные…", "uk": "Введіть дані…",
        "pl": "Wpisz ładunek…", "cs": "Zadejte data…", "ko": "페이로드 입력…", "hi": "पेलोड दर्ज करें…",
    },
    "retain": {
        "en": "Retain", "it": "Mantieni", "es": "Retener", "de": "Beibehalten",
        "pt": "Reter", "fr": "Conserver", "zh_Hans": "保留", "zh_Hant": "保留",
        "ja": "保持", "th": "เก็บไว้", "ru": "Сохранять", "uk": "Утримувати",
        "pl": "Zachowaj", "cs": "Ponechat", "ko": "유지", "hi": "बनाए रखें",
    },
    "retainSub": {
        "en": "Broker keeps the last message for new subscribers.",
        "it": "Il broker mantiene l'ultimo messaggio per i nuovi iscritti.",
        "es": "El broker guarda el último mensaje para nuevos suscriptores.",
        "de": "Der Broker behält die letzte Nachricht für neue Abonnenten.",
        "pt": "O broker mantém a última mensagem para novos subscritores.",
        "fr": "Le broker conserve le dernier message pour les nouveaux abonnés.",
        "zh_Hans": "代理为新订阅者保留最后一条消息。",
        "zh_Hant": "代理為新訂閱者保留最後一則訊息。",
        "ja": "ブローカーは新しい購読者のために最後のメッセージを保持します。",
        "th": "โบรกเกอร์เก็บข้อความล่าสุดไว้สำหรับผู้ติดตามใหม่",
        "ru": "Брокер хранит последнее сообщение для новых подписчиков.",
        "uk": "Брокер зберігає останнє повідомлення для нових підписників.",
        "pl": "Broker zachowuje ostatnią wiadomość dla nowych subskrybentów.",
        "cs": "Broker uchová poslední zprávu pro nové odběratele.",
        "ko": "브로커가 새 구독자를 위해 마지막 메시지를 유지합니다.",
        "hi": "ब्रोकर नए सब्सक्राइबर के लिए अंतिम संदेश रखता है।",
    },
    "publish": {
        "en": "Publish", "it": "Pubblica", "es": "Publicar", "de": "Veröffentlichen",
        "pt": "Publicar", "fr": "Publier", "zh_Hans": "发布", "zh_Hant": "發布",
        "ja": "発行", "th": "เผยแพร่", "ru": "Опубликовать", "uk": "Опублікувати",
        "pl": "Opublikuj", "cs": "Publikovat", "ko": "게시", "hi": "प्रकाशित करें",
    },
    "connectedEnterTopic": {
        "en": "Connected — enter a topic below",
        "it": "Connesso — inserisci un argomento sotto",
        "es": "Conectado — introduce un tema abajo",
        "de": "Verbunden — Thema unten eingeben",
        "pt": "Ligado — introduza um tópico abaixo",
        "fr": "Connecté — saisissez un sujet ci-dessous",
        "zh_Hans": "已连接 — 在下方输入主题", "zh_Hant": "已連線 — 在下方輸入主題",
        "ja": "接続済み — 下にトピックを入力", "th": "เชื่อมต่อแล้ว — ป้อนหัวข้อด้านล่าง",
        "ru": "Подключено — введите топик ниже", "uk": "Підключено — введіть тему нижче",
        "pl": "Połączono — wpisz temat poniżej", "cs": "Připojeno — zadejte téma níže",
        "ko": "연결됨 — 아래에 토픽을 입력하세요", "hi": "कनेक्ट हो गया — नीचे टॉपिक दर्ज करें",
    },
    "connectedTopic": {
        "en": "Connected — topic: \"{topic}\"",
        "it": "Connesso — argomento: \"{topic}\"",
        "es": "Conectado — tema: \"{topic}\"",
        "de": "Verbunden — Thema: \"{topic}\"",
        "pt": "Ligado — tópico: \"{topic}\"",
        "fr": "Connecté — sujet : \"{topic}\"",
        "zh_Hans": "已连接 — 主题：\"{topic}\"", "zh_Hant": "已連線 — 主題：\"{topic}\"",
        "ja": "接続済み — トピック: \"{topic}\"", "th": "เชื่อมต่อแล้ว — หัวข้อ: \"{topic}\"",
        "ru": "Подключено — топик: \"{topic}\"", "uk": "Підключено — тема: \"{topic}\"",
        "pl": "Połączono — temat: \"{topic}\"", "cs": "Připojeno — téma: \"{topic}\"",
        "ko": "연결됨 — 토픽: \"{topic}\"", "hi": "कनेक्ट हो गया — टॉपिक: \"{topic}\"",
    },
    "disconnectedStatus": {
        "en": "Disconnected", "it": "Disconnesso", "es": "Desconectado",
        "de": "Getrennt", "pt": "Desligado", "fr": "Déconnecté",
        "zh_Hans": "已断开连接", "zh_Hant": "已中斷連線", "ja": "切断されました",
        "th": "ตัดการเชื่อมต่อแล้ว", "ru": "Отключено", "uk": "Відключено",
        "pl": "Rozłączono", "cs": "Odpojeno", "ko": "연결 끊김", "hi": "डिस्कनेक्ट हो गया",
    },
    "publishedTo": {
        "en": "Published to \"{topic}\"", "it": "Pubblicato su \"{topic}\"",
        "es": "Publicado en \"{topic}\"", "de": "Veröffentlicht auf \"{topic}\"",
        "pt": "Publicado em \"{topic}\"", "fr": "Publié sur \"{topic}\"",
        "zh_Hans": "已发布到 \"{topic}\"", "zh_Hant": "已發布到 \"{topic}\"",
        "ja": "\"{topic}\" に発行しました", "th": "เผยแพร่ไปยัง \"{topic}\" แล้ว",
        "ru": "Опубликовано в \"{topic}\"", "uk": "Опубліковано в \"{topic}\"",
        "pl": "Opublikowano w \"{topic}\"", "cs": "Publikováno do \"{topic}\"",
        "ko": "\"{topic}\"에 게시됨", "hi": "\"{topic}\" पर प्रकाशित",
    },
    "about5GhzChannels": {
        "en": "About 5 GHz channels", "it": "Informazioni sui canali 5 GHz",
        "es": "Acerca de los canales de 5 GHz", "de": "Über 5-GHz-Kanäle",
        "pt": "Sobre os canais de 5 GHz", "fr": "À propos des canaux 5 GHz",
        "zh_Hans": "关于 5 GHz 信道", "zh_Hant": "關於 5 GHz 頻道", "ja": "5 GHz チャンネルについて",
        "th": "เกี่ยวกับช่อง 5 GHz", "ru": "О каналах 5 ГГц", "uk": "Про канали 5 ГГц",
        "pl": "O kanałach 5 GHz", "cs": "O kanálech 5 GHz", "ko": "5 GHz 채널 정보", "hi": "5 GHz चैनलों के बारे में",
    },
    "wifiBandInfoTitle": {
        "en": "Dual access point detection in 5 GHz network",
        "it": "Rilevamento di doppio access point nella rete 5 GHz",
        "es": "Detección de doble punto de acceso en la red de 5 GHz",
        "de": "Erkennung doppelter Access Points im 5-GHz-Netz",
        "pt": "Deteção de duplo ponto de acesso na rede 5 GHz",
        "fr": "Détection de point d'accès double sur le réseau 5 GHz",
        "zh_Hans": "5 GHz 网络中的双接入点检测",
        "zh_Hant": "5 GHz 網路中的雙存取點偵測",
        "ja": "5 GHz ネットワークでのデュアルアクセスポイント検出",
        "th": "การตรวจจับจุดเข้าใช้งานคู่ในเครือข่าย 5 GHz",
        "ru": "Обнаружение двойной точки доступа в сети 5 ГГц",
        "uk": "Виявлення подвійної точки доступу в мережі 5 ГГц",
        "pl": "Wykrywanie podwójnego punktu dostępu w sieci 5 GHz",
        "cs": "Detekce dvojitého přístupového bodu v síti 5 GHz",
        "ko": "5 GHz 네트워크의 이중 액세스 포인트 감지",
        "hi": "5 GHz नेटवर्क में डुअल एक्सेस पॉइंट का पता लगाना",
    },
    "wifiBandInfoBody": {
        "en": "💡 Hold SSID to see full Access Point name.\n\n"
              "ℹ️ On the 5 GHz band you will usually see each access point appear on "
              "two (or more) channels at once. That is normal.\n\n"
              "To go faster, modern routers glue neighbouring 20 MHz channels "
              "together into one wider lane — 40, 80, or even 160 MHz. This is "
              "called \"channel bonding\". A wider lane carries more data, just "
              "like a wider road carries more cars.\n\n"
              "With \"dynamic channel width\" the router picks the widest lane it "
              "can and narrows it automatically when the air gets busy or noisy, "
              "so it stays fast without stepping on the neighbours.\n\n"
              "So a single 5 GHz network showing on channels 36 and 40, for "
              "example, is just one access point using an 40 MHz-wide bonded "
              "channel — not two separate networks.",
        "it": "💡 Tieni premuto l'SSID per vedere il nome completo dell'access point.\n\n"
              "ℹ️ Sulla banda 5 GHz di solito vedrai ogni access point apparire su "
              "due (o più) canali contemporaneamente. È normale.\n\n"
              "Per andare più veloci, i router moderni uniscono canali vicini da 20 MHz "
              "in una corsia più ampia — 40, 80 o persino 160 MHz. Questo si chiama "
              "\"channel bonding\". Una corsia più ampia trasporta più dati, proprio "
              "come una strada più larga trasporta più auto.\n\n"
              "Con la \"larghezza di canale dinamica\" il router sceglie la corsia più "
              "ampia possibile e la restringe automaticamente quando l'etere è affollato "
              "o rumoroso, per restare veloce senza disturbare i vicini.\n\n"
              "Quindi una singola rete 5 GHz che appare sui canali 36 e 40, ad esempio, "
              "è solo un access point che usa un canale unito ampio 40 MHz — non due "
              "reti separate.",
        "es": "💡 Mantén pulsado el SSID para ver el nombre completo del punto de acceso.\n\n"
              "ℹ️ En la banda de 5 GHz normalmente verás cada punto de acceso en "
              "dos (o más) canales a la vez. Es normal.\n\n"
              "Para ir más rápido, los routers modernos unen canales vecinos de 20 MHz "
              "en un carril más ancho — 40, 80 o incluso 160 MHz. Esto se llama "
              "\"channel bonding\". Un carril más ancho transporta más datos, igual "
              "que una carretera más ancha transporta más coches.\n\n"
              "Con el \"ancho de canal dinámico\" el router elige el carril más ancho "
              "posible y lo estrecha automáticamente cuando el aire está ocupado o con "
              "ruido, para seguir siendo rápido sin molestar a los vecinos.\n\n"
              "Así que una sola red de 5 GHz que aparece en los canales 36 y 40, por "
              "ejemplo, es solo un punto de acceso usando un canal unido de 40 MHz — "
              "no dos redes separadas.",
        "de": "💡 SSID gedrückt halten, um den vollständigen Access-Point-Namen zu sehen.\n\n"
              "ℹ️ Im 5-GHz-Band erscheint jeder Access Point üblicherweise auf "
              "zwei (oder mehr) Kanälen gleichzeitig. Das ist normal.\n\n"
              "Um schneller zu sein, koppeln moderne Router benachbarte 20-MHz-Kanäle "
              "zu einer breiteren Spur — 40, 80 oder sogar 160 MHz. Das nennt man "
              "\"Channel Bonding\". Eine breitere Spur transportiert mehr Daten, so "
              "wie eine breitere Straße mehr Autos aufnimmt.\n\n"
              "Mit \"dynamischer Kanalbreite\" wählt der Router die breiteste mögliche "
              "Spur und verengt sie automatisch, wenn die Luft voll oder verrauscht "
              "wird, um schnell zu bleiben, ohne die Nachbarn zu stören.\n\n"
              "Ein einzelnes 5-GHz-Netz, das z. B. auf den Kanälen 36 und 40 erscheint, "
              "ist also nur ein Access Point mit einem 40 MHz breiten gekoppelten "
              "Kanal — nicht zwei getrennte Netze.",
        "pt": "💡 Mantenha o SSID premido para ver o nome completo do ponto de acesso.\n\n"
              "ℹ️ Na banda 5 GHz verá normalmente cada ponto de acesso em "
              "dois (ou mais) canais ao mesmo tempo. Isso é normal.\n\n"
              "Para irem mais rápido, os routers modernos juntam canais vizinhos de 20 MHz "
              "numa faixa mais larga — 40, 80 ou até 160 MHz. Isto chama-se "
              "\"channel bonding\". Uma faixa mais larga transporta mais dados, tal "
              "como uma estrada mais larga transporta mais carros.\n\n"
              "Com a \"largura de canal dinâmica\" o router escolhe a faixa mais larga "
              "possível e estreita-a automaticamente quando o ar fica ocupado ou com "
              "ruído, mantendo-se rápido sem incomodar os vizinhos.\n\n"
              "Portanto, uma única rede 5 GHz que aparece nos canais 36 e 40, por "
              "exemplo, é apenas um ponto de acesso a usar um canal unido de 40 MHz — "
              "não duas redes separadas.",
        "fr": "💡 Maintenez le SSID pour voir le nom complet du point d'accès.\n\n"
              "ℹ️ Sur la bande 5 GHz, vous verrez généralement chaque point d'accès sur "
              "deux canaux (ou plus) à la fois. C'est normal.\n\n"
              "Pour aller plus vite, les routeurs modernes collent des canaux voisins de "
              "20 MHz en une voie plus large — 40, 80 ou même 160 MHz. Cela s'appelle "
              "le \"channel bonding\". Une voie plus large transporte plus de données, "
              "comme une route plus large accueille plus de voitures.\n\n"
              "Avec la \"largeur de canal dynamique\", le routeur choisit la voie la plus "
              "large possible et la rétrécit automatiquement quand l'air devient chargé "
              "ou bruyant, pour rester rapide sans gêner les voisins.\n\n"
              "Ainsi, un seul réseau 5 GHz apparaissant sur les canaux 36 et 40, par "
              "exemple, n'est qu'un point d'accès utilisant un canal lié de 40 MHz — "
              "pas deux réseaux distincts.",
        "zh_Hans": "💡 长按 SSID 查看完整的接入点名称。\n\n"
                   "ℹ️ 在 5 GHz 频段上，你通常会看到每个接入点同时出现在两个（或更多）信道上。这是正常的。\n\n"
                   "为了更快，现代路由器会把相邻的 20 MHz 信道粘合成一条更宽的车道——40、80 甚至 160 MHz。"
                   "这称为\"信道绑定\"。更宽的车道能承载更多数据，就像更宽的道路能容纳更多汽车一样。\n\n"
                   "通过\"动态信道宽度\"，路由器会选择它能用的最宽车道，并在空中变得繁忙或嘈杂时自动收窄，"
                   "从而在不打扰邻居的情况下保持高速。\n\n"
                   "所以，例如一个同时出现在信道 36 和 40 上的 5 GHz 网络，只是一个使用 40 MHz 宽绑定信道的"
                   "接入点——而不是两个独立的网络。",
        "zh_Hant": "💡 長按 SSID 查看完整的存取點名稱。\n\n"
                   "ℹ️ 在 5 GHz 頻段上，你通常會看到每個存取點同時出現在兩個（或更多）頻道上。這是正常的。\n\n"
                   "為了更快，現代路由器會把相鄰的 20 MHz 頻道黏合成一條更寬的車道——40、80 甚至 160 MHz。"
                   "這稱為\"頻道綁定\"。更寬的車道能承載更多資料，就像更寬的道路能容納更多汽車一樣。\n\n"
                   "透過\"動態頻道寬度\"，路由器會選擇它能用的最寬車道，並在空中變得繁忙或嘈雜時自動收窄，"
                   "從而在不打擾鄰居的情況下保持高速。\n\n"
                   "所以，例如一個同時出現在頻道 36 和 40 上的 5 GHz 網路，只是一個使用 40 MHz 寬綁定頻道的"
                   "存取點——而不是兩個獨立的網路。",
        "ja": "💡 SSID を長押しすると、アクセスポイントの完全な名前が表示されます。\n\n"
              "ℹ️ 5 GHz 帯では通常、各アクセスポイントが 2 つ（またはそれ以上）のチャンネルに同時に"
              "表示されます。これは正常です。\n\n"
              "高速化のため、最近のルーターは隣接する 20 MHz のチャンネルをつなげて、より広いレーン"
              "——40、80、さらには 160 MHz——にします。これを\"チャンネルボンディング\"と呼びます。"
              "広いレーンは、広い道路がより多くの車を通すように、より多くのデータを運びます。\n\n"
              "\"動的チャンネル幅\"では、ルーターは使える最も広いレーンを選び、電波が混雑したり"
              "ノイズが増えたりすると自動的に狭めるので、近隣に干渉せずに高速を保ちます。\n\n"
              "つまり、たとえばチャンネル 36 と 40 に表示される 1 つの 5 GHz ネットワークは、40 MHz 幅の"
              "結合チャンネルを使う 1 台のアクセスポイントであり、2 つの別々のネットワークではありません。",
        "th": "💡 กด SSID ค้างไว้เพื่อดูชื่อจุดเข้าใช้งานแบบเต็ม\n\n"
              "ℹ️ ในย่าน 5 GHz คุณมักจะเห็นแต่ละจุดเข้าใช้งานปรากฏบนสอง (หรือมากกว่า) ช่องพร้อมกัน "
              "ซึ่งเป็นเรื่องปกติ\n\n"
              "เพื่อให้เร็วขึ้น เราเตอร์รุ่นใหม่จะรวมช่อง 20 MHz ที่อยู่ติดกันเป็นเลนที่กว้างขึ้น — 40, 80 "
              "หรือแม้แต่ 160 MHz เรียกว่า \"channel bonding\" เลนที่กว้างขึ้นรองรับข้อมูลได้มากขึ้น "
              "เช่นเดียวกับถนนที่กว้างขึ้นรองรับรถได้มากขึ้น\n\n"
              "ด้วย \"ความกว้างช่องแบบไดนามิก\" เราเตอร์จะเลือกเลนที่กว้างที่สุดเท่าที่ทำได้ และแคบลง"
              "โดยอัตโนมัติเมื่ออากาศแออัดหรือมีสัญญาณรบกวน จึงยังคงเร็วโดยไม่รบกวนเพื่อนบ้าน\n\n"
              "ดังนั้น เครือข่าย 5 GHz เดียวที่แสดงบนช่อง 36 และ 40 เช่น จึงเป็นเพียงจุดเข้าใช้งานเดียว"
              "ที่ใช้ช่องรวมกว้าง 40 MHz — ไม่ใช่สองเครือข่ายแยกกัน",
        "ru": "💡 Удерживайте SSID, чтобы увидеть полное имя точки доступа.\n\n"
              "ℹ️ В диапазоне 5 ГГц вы обычно увидите каждую точку доступа сразу на "
              "двух (или более) каналах. Это нормально.\n\n"
              "Чтобы работать быстрее, современные роутеры объединяют соседние каналы "
              "по 20 МГц в одну более широкую полосу — 40, 80 или даже 160 МГц. Это "
              "называется \"объединением каналов\". Более широкая полоса несёт больше "
              "данных, как более широкая дорога вмещает больше машин.\n\n"
              "При \"динамической ширине канала\" роутер выбирает самую широкую доступную "
              "полосу и автоматически сужает её, когда эфир загружен или зашумлён, "
              "оставаясь быстрым и не мешая соседям.\n\n"
              "Так что одна сеть 5 ГГц, отображаемая, например, на каналах 36 и 40, — это "
              "просто одна точка доступа, использующая объединённый канал шириной 40 МГц, "
              "а не две отдельные сети.",
        "uk": "💡 Утримуйте SSID, щоб побачити повне ім'я точки доступу.\n\n"
              "ℹ️ У діапазоні 5 ГГц ви зазвичай побачите кожну точку доступу одразу на "
              "двох (або більше) каналах. Це нормально.\n\n"
              "Щоб працювати швидше, сучасні роутери об'єднують сусідні канали по 20 МГц "
              "в одну ширшу смугу — 40, 80 або навіть 160 МГц. Це називається "
              "\"об'єднанням каналів\". Ширша смуга несе більше даних, як ширша дорога "
              "вміщує більше машин.\n\n"
              "За \"динамічної ширини каналу\" роутер обирає найширшу доступну смугу і "
              "автоматично звужує її, коли ефір завантажений чи зашумлений, залишаючись "
              "швидким і не заважаючи сусідам.\n\n"
              "Отже, одна мережа 5 ГГц, що відображається, наприклад, на каналах 36 і 40, — "
              "це лише одна точка доступу, яка використовує об'єднаний канал шириною 40 МГц, "
              "а не дві окремі мережі.",
        "pl": "💡 Przytrzymaj SSID, aby zobaczyć pełną nazwę punktu dostępu.\n\n"
              "ℹ️ W paśmie 5 GHz zwykle zobaczysz każdy punkt dostępu jednocześnie na "
              "dwóch (lub więcej) kanałach. To normalne.\n\n"
              "Aby przyspieszyć, nowoczesne routery łączą sąsiednie kanały 20 MHz "
              "w jeden szerszy pas — 40, 80 lub nawet 160 MHz. Nazywa się to "
              "\"łączeniem kanałów\". Szerszy pas przenosi więcej danych, tak jak "
              "szersza droga mieści więcej samochodów.\n\n"
              "Przy \"dynamicznej szerokości kanału\" router wybiera najszerszy możliwy "
              "pas i automatycznie go zwęża, gdy eter jest zajęty lub zaszumiony, "
              "pozostając szybki bez przeszkadzania sąsiadom.\n\n"
              "Zatem pojedyncza sieć 5 GHz pojawiająca się np. na kanałach 36 i 40 to "
              "tylko jeden punkt dostępu używający połączonego kanału o szerokości 40 MHz "
              "— a nie dwie osobne sieci.",
        "cs": "💡 Podržte SSID pro zobrazení celého názvu přístupového bodu.\n\n"
              "ℹ️ V pásmu 5 GHz obvykle uvidíte každý přístupový bod na "
              "dvou (nebo více) kanálech současně. To je normální.\n\n"
              "Pro vyšší rychlost moderní routery spojují sousední kanály po 20 MHz "
              "do jednoho širšího pruhu — 40, 80 nebo dokonce 160 MHz. Tomu se říká "
              "\"spojování kanálů\". Širší pruh přenese více dat, stejně jako širší "
              "silnice pojme více aut.\n\n"
              "Při \"dynamické šířce kanálu\" router zvolí nejširší možný pruh a "
              "automaticky jej zúží, když je éter vytížený nebo zarušený, aby zůstal "
              "rychlý a nerušil sousedy.\n\n"
              "Jedna síť 5 GHz zobrazená například na kanálech 36 a 40 je tedy jen "
              "jeden přístupový bod používající spojený kanál o šířce 40 MHz — nikoli "
              "dvě samostatné sítě.",
        "ko": "💡 SSID를 길게 누르면 액세스 포인트의 전체 이름을 볼 수 있습니다.\n\n"
              "ℹ️ 5 GHz 대역에서는 보통 각 액세스 포인트가 두 개(또는 그 이상)의 채널에 동시에 "
              "나타납니다. 이는 정상입니다.\n\n"
              "더 빠르게 하기 위해 최신 라우터는 인접한 20 MHz 채널을 하나의 더 넓은 차선 — 40, 80, "
              "심지어 160 MHz — 으로 붙입니다. 이를 \"채널 본딩\"이라고 합니다. 더 넓은 도로가 더 많은 "
              "차를 수용하듯, 더 넓은 차선은 더 많은 데이터를 전달합니다.\n\n"
              "\"동적 채널 폭\"을 사용하면 라우터는 가능한 가장 넓은 차선을 선택하고 전파가 혼잡하거나 "
              "잡음이 많아지면 자동으로 좁혀서, 이웃을 방해하지 않으면서 빠른 속도를 유지합니다.\n\n"
              "따라서 예를 들어 채널 36과 40에 표시되는 하나의 5 GHz 네트워크는 40 MHz 폭의 결합 채널을 "
              "사용하는 하나의 액세스 포인트일 뿐이며, 두 개의 별도 네트워크가 아닙니다.",
        "hi": "💡 एक्सेस पॉइंट का पूरा नाम देखने के लिए SSID को दबाए रखें।\n\n"
              "ℹ️ 5 GHz बैंड पर आप आमतौर पर प्रत्येक एक्सेस पॉइंट को एक साथ दो (या अधिक) चैनलों पर "
              "देखेंगे। यह सामान्य है।\n\n"
              "तेज़ चलने के लिए, आधुनिक राउटर पड़ोसी 20 MHz चैनलों को जोड़कर एक चौड़ी लेन बनाते हैं — "
              "40, 80 या यहाँ तक कि 160 MHz। इसे \"चैनल बॉन्डिंग\" कहते हैं। चौड़ी लेन अधिक डेटा ले "
              "जाती है, जैसे चौड़ी सड़क अधिक कारें ले जाती है।\n\n"
              "\"डायनामिक चैनल चौड़ाई\" के साथ राउटर सबसे चौड़ी संभव लेन चुनता है और हवा के व्यस्त या "
              "शोरगुल वाले होने पर उसे अपने आप संकरा कर देता है, ताकि पड़ोसियों को परेशान किए बिना "
              "तेज़ बना रहे।\n\n"
              "इसलिए, उदाहरण के लिए, चैनल 36 और 40 पर दिखने वाला एक ही 5 GHz नेटवर्क सिर्फ़ एक "
              "एक्सेस पॉइंट है जो 40 MHz चौड़ा जुड़ा हुआ चैनल उपयोग कर रहा है — दो अलग नेटवर्क नहीं।",
    },
    "noResults": {
        "en": "No results.", "it": "Nessun risultato.", "es": "Sin resultados.",
        "de": "Keine Ergebnisse.", "pt": "Sem resultados.", "fr": "Aucun résultat.",
        "zh_Hans": "无结果。", "zh_Hant": "無結果。", "ja": "結果がありません。",
        "th": "ไม่มีผลลัพธ์", "ru": "Нет результатов.", "uk": "Немає результатів.",
        "pl": "Brak wyników.", "cs": "Žádné výsledky.", "ko": "결과 없음.", "hi": "कोई परिणाम नहीं।",
    },
    "scanErrorPrefix": {
        "en": "Scan error", "it": "Errore di scansione", "es": "Error de escaneo",
        "de": "Scan-Fehler", "pt": "Erro de análise", "fr": "Erreur d'analyse",
        "zh_Hans": "扫描错误", "zh_Hant": "掃描錯誤", "ja": "スキャンエラー",
        "th": "ข้อผิดพลาดการสแกน", "ru": "Ошибка сканирования", "uk": "Помилка сканування",
        "pl": "Błąd skanowania", "cs": "Chyba skenování", "ko": "스캔 오류", "hi": "स्कैन त्रुटि",
    },
    "noBandNetworks": {
        "en": "No {band} networks detected.",
        "it": "Nessuna rete {band} rilevata.",
        "es": "No se detectaron redes de {band}.",
        "de": "Keine {band}-Netzwerke erkannt.",
        "pt": "Nenhuma rede {band} detetada.",
        "fr": "Aucun réseau {band} détecté.",
        "zh_Hans": "未检测到 {band} 网络。", "zh_Hant": "未偵測到 {band} 網路。",
        "ja": "{band} ネットワークが検出されませんでした。",
        "th": "ไม่พบเครือข่าย {band}", "ru": "Сети {band} не обнаружены.",
        "uk": "Мережі {band} не виявлено.", "pl": "Nie wykryto sieci {band}.",
        "cs": "Nebyly zjištěny žádné sítě {band}.", "ko": "{band} 네트워크가 감지되지 않았습니다.",
        "hi": "कोई {band} नेटवर्क नहीं मिला।",
    },
    "securityLabel": {
        "en": "Security", "it": "Sicurezza", "es": "Seguridad", "de": "Sicherheit",
        "pt": "Segurança", "fr": "Sécurité", "zh_Hans": "安全", "zh_Hant": "安全",
        "ja": "セキュリティ", "th": "ความปลอดภัย", "ru": "Защита", "uk": "Захист",
        "pl": "Zabezpieczenia", "cs": "Zabezpečení", "ko": "보안", "hi": "सुरक्षा",
    },
    "qualityLabel": {
        "en": "Quality", "it": "Qualità", "es": "Calidad", "de": "Qualität",
        "pt": "Qualidade", "fr": "Qualité", "zh_Hans": "质量", "zh_Hant": "品質",
        "ja": "品質", "th": "คุณภาพ", "ru": "Качество", "uk": "Якість",
        "pl": "Jakość", "cs": "Kvalita", "ko": "품질", "hi": "गुणवत्ता",
    },
    "qExcellent": {
        "en": "Excellent", "it": "Eccellente", "es": "Excelente", "de": "Ausgezeichnet",
        "pt": "Excelente", "fr": "Excellent", "zh_Hans": "极佳", "zh_Hant": "極佳",
        "ja": "非常に良い", "th": "ดีเยี่ยม", "ru": "Отлично", "uk": "Відмінно",
        "pl": "Doskonała", "cs": "Vynikající", "ko": "매우 좋음", "hi": "उत्कृष्ट",
    },
    "qGood": {
        "en": "Good", "it": "Buono", "es": "Bueno", "de": "Gut",
        "pt": "Bom", "fr": "Bon", "zh_Hans": "良好", "zh_Hant": "良好",
        "ja": "良い", "th": "ดี", "ru": "Хорошо", "uk": "Добре",
        "pl": "Dobra", "cs": "Dobrá", "ko": "좋음", "hi": "अच्छा",
    },
    "qFair": {
        "en": "Fair", "it": "Discreto", "es": "Regular", "de": "Ausreichend",
        "pt": "Razoável", "fr": "Moyen", "zh_Hans": "一般", "zh_Hant": "一般",
        "ja": "普通", "th": "พอใช้", "ru": "Средне", "uk": "Задовільно",
        "pl": "Dostateczna", "cs": "Průměrná", "ko": "보통", "hi": "ठीक-ठाक",
    },
    "qWeak": {
        "en": "Weak", "it": "Debole", "es": "Débil", "de": "Schwach",
        "pt": "Fraco", "fr": "Faible", "zh_Hans": "较弱", "zh_Hant": "較弱",
        "ja": "弱い", "th": "อ่อน", "ru": "Слабо", "uk": "Слабко",
        "pl": "Słaba", "cs": "Slabá", "ko": "약함", "hi": "कमज़ोर",
    },
    "qPoor": {
        "en": "Poor", "it": "Scarso", "es": "Malo", "de": "Schlecht",
        "pt": "Mau", "fr": "Mauvais", "zh_Hans": "很差", "zh_Hant": "很差",
        "ja": "悪い", "th": "แย่", "ru": "Плохо", "uk": "Погано",
        "pl": "Słaba", "cs": "Špatná", "ko": "나쁨", "hi": "खराब",
    },
    "refresh": {
        "en": "Refresh", "it": "Aggiorna", "es": "Actualizar", "de": "Aktualisieren",
        "pt": "Atualizar", "fr": "Actualiser", "zh_Hans": "刷新", "zh_Hant": "重新整理",
        "ja": "更新", "th": "รีเฟรช", "ru": "Обновить", "uk": "Оновити",
        "pl": "Odśwież", "cs": "Obnovit", "ko": "새로 고침", "hi": "रीफ़्रेश",
    },
    "cellShowingDemo": {
        "en": "Showing demo data.", "it": "Visualizzazione dati dimostrativi.",
        "es": "Mostrando datos de demostración.", "de": "Zeige Demodaten.",
        "pt": "A mostrar dados de demonstração.", "fr": "Affichage de données de démonstration.",
        "zh_Hans": "正在显示演示数据。", "zh_Hant": "正在顯示示範資料。", "ja": "デモデータを表示しています。",
        "th": "กำลังแสดงข้อมูลตัวอย่าง", "ru": "Показаны демонстрационные данные.",
        "uk": "Показано демонстраційні дані.", "pl": "Wyświetlanie danych demonstracyjnych.",
        "cs": "Zobrazují se ukázková data.", "ko": "데모 데이터를 표시하고 있습니다.",
        "hi": "डेमो डेटा दिखाया जा रहा है।",
    },
    "noDataReturned": {
        "en": "No data returned from device.",
        "it": "Nessun dato restituito dal dispositivo.",
        "es": "El dispositivo no devolvió datos.",
        "de": "Keine Daten vom Gerät erhalten.",
        "pt": "O dispositivo não devolveu dados.",
        "fr": "Aucune donnée renvoyée par l'appareil.",
        "zh_Hans": "设备未返回任何数据。", "zh_Hant": "裝置未回傳任何資料。",
        "ja": "デバイスからデータが返されませんでした。", "th": "อุปกรณ์ไม่ส่งข้อมูลกลับมา",
        "ru": "Устройство не вернуло данные.", "uk": "Пристрій не повернув даних.",
        "pl": "Urządzenie nie zwróciło żadnych danych.", "cs": "Zařízení nevrátilo žádná data.",
        "ko": "기기에서 데이터를 반환하지 않았습니다.", "hi": "डिवाइस से कोई डेटा नहीं मिला।",
    },
    "platformErrorPrefix": {
        "en": "Platform error", "it": "Errore di piattaforma", "es": "Error de plataforma",
        "de": "Plattformfehler", "pt": "Erro de plataforma", "fr": "Erreur de plateforme",
        "zh_Hans": "平台错误", "zh_Hant": "平台錯誤", "ja": "プラットフォームエラー",
        "th": "ข้อผิดพลาดแพลตฟอร์ม", "ru": "Ошибка платформы", "uk": "Помилка платформи",
        "pl": "Błąd platformy", "cs": "Chyba platformy", "ko": "플랫폼 오류", "hi": "प्लेटफ़ॉर्म त्रुटि",
    },
    "carrier": {
        "en": "Carrier", "it": "Operatore", "es": "Operador", "de": "Anbieter",
        "pt": "Operadora", "fr": "Opérateur", "zh_Hans": "运营商", "zh_Hant": "電信業者",
        "ja": "通信事業者", "th": "ผู้ให้บริการ", "ru": "Оператор", "uk": "Оператор",
        "pl": "Operator", "cs": "Operátor", "ko": "통신사", "hi": "कैरियर",
    },
    "provider": {
        "en": "Provider", "it": "Operatore", "es": "Proveedor", "de": "Anbieter",
        "pt": "Fornecedor", "fr": "Fournisseur", "zh_Hans": "提供商", "zh_Hant": "供應商",
        "ja": "プロバイダー", "th": "ผู้ให้บริการ", "ru": "Провайдер", "uk": "Провайдер",
        "pl": "Dostawca", "cs": "Poskytovatel", "ko": "제공업체", "hi": "प्रदाता",
    },
    "technology": {
        "en": "Technology", "it": "Tecnologia", "es": "Tecnología", "de": "Technologie",
        "pt": "Tecnologia", "fr": "Technologie", "zh_Hans": "技术", "zh_Hant": "技術",
        "ja": "技術", "th": "เทคโนโลยี", "ru": "Технология", "uk": "Технологія",
        "pl": "Technologia", "cs": "Technologie", "ko": "기술", "hi": "प्रौद्योगिकी",
    },
    "roaming": {
        "en": "Roaming", "it": "Roaming", "es": "Itinerancia", "de": "Roaming",
        "pt": "Roaming", "fr": "Itinérance", "zh_Hans": "漫游", "zh_Hant": "漫遊",
        "ja": "ローミング", "th": "โรมมิ่ง", "ru": "Роуминг", "uk": "Роумінг",
        "pl": "Roaming", "cs": "Roaming", "ko": "로밍", "hi": "रोमिंग",
    },
    "dataState": {
        "en": "Data state", "it": "Stato dati", "es": "Estado de datos",
        "de": "Datenstatus", "pt": "Estado dos dados", "fr": "État des données",
        "zh_Hans": "数据状态", "zh_Hant": "數據狀態", "ja": "データの状態",
        "th": "สถานะข้อมูล", "ru": "Состояние данных", "uk": "Стан даних",
        "pl": "Stan danych", "cs": "Stav dat", "ko": "데이터 상태", "hi": "डेटा स्थिति",
    },
    "signalQuality": {
        "en": "Signal Quality", "it": "Qualità del segnale", "es": "Calidad de señal",
        "de": "Signalqualität", "pt": "Qualidade do sinal", "fr": "Qualité du signal",
        "zh_Hans": "信号质量", "zh_Hant": "訊號品質", "ja": "信号品質",
        "th": "คุณภาพสัญญาณ", "ru": "Качество сигнала", "uk": "Якість сигналу",
        "pl": "Jakość sygnału", "cs": "Kvalita signálu", "ko": "신호 품질", "hi": "सिग्नल गुणवत्ता",
    },
    "cellTower": {
        "en": "Cell Tower", "it": "Cella", "es": "Torre de telefonía",
        "de": "Mobilfunkmast", "pt": "Torre de celular", "fr": "Antenne-relais",
        "zh_Hans": "基站", "zh_Hant": "基地台", "ja": "基地局",
        "th": "เสาสัญญาณ", "ru": "Сотовая вышка", "uk": "Стільникова вежа",
        "pl": "Maszt komórkowy", "cs": "Buňková věž", "ko": "기지국", "hi": "सेल टावर",
    },
    "cellId": {
        "en": "Cell ID", "it": "ID cella", "es": "ID de celda", "de": "Zellen-ID",
        "pt": "ID da célula", "fr": "ID de cellule", "zh_Hans": "小区 ID", "zh_Hant": "細胞 ID",
        "ja": "セル ID", "th": "รหัสเซลล์", "ru": "ID соты", "uk": "ID соти",
        "pl": "ID komórki", "cs": "ID buňky", "ko": "셀 ID", "hi": "सेल ID",
    },
    "bandLabel": {
        "en": "Band", "it": "Banda", "es": "Banda", "de": "Band",
        "pt": "Banda", "fr": "Bande", "zh_Hans": "频段", "zh_Hant": "頻段",
        "ja": "バンド", "th": "แบนด์", "ru": "Диапазон", "uk": "Діапазон",
        "pl": "Pasmo", "cs": "Pásmo", "ko": "밴드", "hi": "बैंड",
    },
    "estDistance": {
        "en": "Est. distance", "it": "Distanza stim.", "es": "Distancia est.",
        "de": "Gesch. Entfernung", "pt": "Distância est.", "fr": "Distance est.",
        "zh_Hans": "估计距离", "zh_Hant": "估計距離", "ja": "推定距離",
        "th": "ระยะโดยประมาณ", "ru": "Расст. (оценка)", "uk": "Відстань (оцінка)",
        "pl": "Szac. odległość", "cs": "Odh. vzdálenost", "ko": "예상 거리", "hi": "अनुमानित दूरी",
    },
    "location": {
        "en": "Location", "it": "Posizione", "es": "Ubicación", "de": "Standort",
        "pt": "Localização", "fr": "Emplacement", "zh_Hans": "位置", "zh_Hant": "位置",
        "ja": "位置", "th": "ตำแหน่ง", "ru": "Местоположение", "uk": "Місцезнаходження",
        "pl": "Lokalizacja", "cs": "Poloha", "ko": "위치", "hi": "स्थान",
    },
    "coordinates": {
        "en": "Coordinates", "it": "Coordinate", "es": "Coordenadas", "de": "Koordinaten",
        "pt": "Coordenadas", "fr": "Coordonnées", "zh_Hans": "坐标", "zh_Hant": "座標",
        "ja": "座標", "th": "พิกัด", "ru": "Координаты", "uk": "Координати",
        "pl": "Współrzędne", "cs": "Souřadnice", "ko": "좌표", "hi": "निर्देशांक",
    },
    "locating": {
        "en": "Locating…", "it": "Localizzazione…", "es": "Localizando…",
        "de": "Standort wird ermittelt…", "pt": "A localizar…", "fr": "Localisation…",
        "zh_Hans": "正在定位…", "zh_Hant": "正在定位…", "ja": "位置を取得中…",
        "th": "กำลังระบุตำแหน่ง…", "ru": "Определение местоположения…", "uk": "Визначення розташування…",
        "pl": "Lokalizowanie…", "cs": "Zjišťování polohy…", "ko": "위치 확인 중…", "hi": "स्थान का पता लगाया जा रहा है…",
    },
    "nearestPlace": {
        "en": "Nearest place", "it": "Luogo più vicino", "es": "Lugar más cercano",
        "de": "Nächster Ort", "pt": "Local mais próximo", "fr": "Lieu le plus proche",
        "zh_Hans": "最近的地点", "zh_Hant": "最近的地點", "ja": "最寄りの場所",
        "th": "สถานที่ใกล้ที่สุด", "ru": "Ближайшее место", "uk": "Найближче місце",
        "pl": "Najbliższe miejsce", "cs": "Nejbližší místo", "ko": "가장 가까운 장소", "hi": "निकटतम स्थान",
    },
    "deniedByUser": {
        "en": "Denied by the user", "it": "Negato dall'utente",
        "es": "Denegado por el usuario", "de": "Vom Benutzer abgelehnt",
        "pt": "Negado pelo utilizador", "fr": "Refusé par l'utilisateur",
        "zh_Hans": "已被用户拒绝", "zh_Hant": "已被使用者拒絕", "ja": "ユーザーによって拒否されました",
        "th": "ผู้ใช้ปฏิเสธ", "ru": "Отклонено пользователем", "uk": "Відхилено користувачем",
        "pl": "Odrzucone przez użytkownika", "cs": "Uživatelem zamítnuto",
        "ko": "사용자가 거부함", "hi": "उपयोगकर्ता द्वारा अस्वीकृत",
    },
    "unavailablePrefix": {
        "en": "Unavailable", "it": "Non disponibile", "es": "No disponible",
        "de": "Nicht verfügbar", "pt": "Indisponível", "fr": "Indisponible",
        "zh_Hans": "不可用", "zh_Hant": "無法使用", "ja": "利用不可",
        "th": "ไม่พร้อมใช้งาน", "ru": "Недоступно", "uk": "Недоступно",
        "pl": "Niedostępne", "cs": "Nedostupné", "ko": "사용 불가", "hi": "अनुपलब्ध",
    },
    "signalStrength": {
        "en": "Signal strength", "it": "Intensità del segnale", "es": "Intensidad de señal",
        "de": "Signalstärke", "pt": "Força do sinal", "fr": "Force du signal",
        "zh_Hans": "信号强度", "zh_Hant": "訊號強度", "ja": "信号強度",
        "th": "ความแรงสัญญาณ", "ru": "Уровень сигнала", "uk": "Рівень сигналу",
        "pl": "Siła sygnału", "cs": "Síla signálu", "ko": "신호 강도", "hi": "सिग्नल शक्ति",
    },
    "rsrpHint": {
        "en": "RSRP — Reference Signal Received Power.\n\nThe average power of the cell's reference "
              "signals, measured in dBm. It reflects raw signal strength.\n\nTypical range: about "
              "\u221280 dBm (excellent) down to \u2212120 dBm (very weak). Higher (closer to zero) is "
              "better.",
        "it": "RSRP — Reference Signal Received Power (potenza ricevuta del segnale di riferimento).\n\n"
              "La potenza media dei segnali di riferimento della cella, misurata in dBm. Riflette "
              "l'intensità grezza del segnale.\n\nIntervallo tipico: da circa \u221280 dBm (eccellente) "
              "fino a \u2212120 dBm (molto debole). Più alto (vicino a zero) è meglio.",
        "es": "RSRP — Potencia recibida de la señal de referencia.\n\nLa potencia media de las señales "
              "de referencia de la celda, medida en dBm. Refleja la intensidad bruta de la señal.\n\n"
              "Rango típico: de unos \u221280 dBm (excelente) hasta \u2212120 dBm (muy débil). Más alto "
              "(cercano a cero) es mejor.",
        "de": "RSRP — Reference Signal Received Power (empfangene Leistung des Referenzsignals).\n\n"
              "Die durchschnittliche Leistung der Referenzsignale der Zelle, gemessen in dBm. Sie "
              "spiegelt die reine Signalstärke wider.\n\nTypischer Bereich: etwa \u221280 dBm "
              "(ausgezeichnet) bis \u2212120 dBm (sehr schwach). Höher (näher an null) ist besser.",
        "pt": "RSRP — Potência recebida do sinal de referência.\n\nA potência média dos sinais de "
              "referência da célula, medida em dBm. Reflete a intensidade bruta do sinal.\n\n"
              "Intervalo típico: cerca de \u221280 dBm (excelente) até \u2212120 dBm (muito fraco). "
              "Mais alto (próximo de zero) é melhor.",
        "fr": "RSRP — Puissance reçue du signal de référence.\n\nLa puissance moyenne des signaux de "
              "référence de la cellule, mesurée en dBm. Elle reflète la force brute du signal.\n\n"
              "Plage typique : d'environ \u221280 dBm (excellent) jusqu'à \u2212120 dBm (très faible). "
              "Plus élevé (proche de zéro) est meilleur.",
        "zh_Hans": "RSRP — 参考信号接收功率。\n\n小区参考信号的平均功率，以 dBm 为单位。它反映原始信号强度。\n\n"
                   "典型范围：约 \u221280 dBm（极佳）到 \u2212120 dBm（非常弱）。数值越高（越接近零）越好。",
        "zh_Hant": "RSRP — 參考訊號接收功率。\n\n細胞參考訊號的平均功率，以 dBm 為單位。它反映原始訊號強度。\n\n"
                   "典型範圍：約 \u221280 dBm（極佳）到 \u2212120 dBm（非常弱）。數值越高（越接近零）越好。",
        "ja": "RSRP — リファレンス信号受信電力。\n\nセルのリファレンス信号の平均電力で、dBm 単位で測定されます。"
              "生の信号強度を表します。\n\n一般的な範囲: 約 \u221280 dBm（非常に良い）から \u2212120 dBm"
              "（非常に弱い）まで。高い（ゼロに近い）ほど良好です。",
        "th": "RSRP — กำลังรับสัญญาณอ้างอิง\n\nกำลังเฉลี่ยของสัญญาณอ้างอิงของเซลล์ วัดเป็น dBm สะท้อนความแรง"
              "สัญญาณดิบ\n\nช่วงปกติ: ประมาณ \u221280 dBm (ดีเยี่ยม) ลงไปถึง \u2212120 dBm (อ่อนมาก) "
              "ยิ่งสูง (ใกล้ศูนย์) ยิ่งดี",
        "ru": "RSRP — мощность принятого опорного сигнала.\n\nСредняя мощность опорных сигналов соты, "
              "измеряется в дБм. Отражает исходный уровень сигнала.\n\nТипичный диапазон: примерно от "
              "\u221280 дБм (отлично) до \u2212120 дБм (очень слабо). Выше (ближе к нулю) — лучше.",
        "uk": "RSRP — потужність прийнятого опорного сигналу.\n\nСередня потужність опорних сигналів "
              "соти, вимірюється в дБм. Відображає вихідний рівень сигналу.\n\nТиповий діапазон: приблизно "
              "від \u221280 дБм (відмінно) до \u2212120 дБм (дуже слабко). Вище (ближче до нуля) — краще.",
        "pl": "RSRP — moc odebranego sygnału odniesienia.\n\nŚrednia moc sygnałów odniesienia komórki, "
              "mierzona w dBm. Odzwierciedla surową siłę sygnału.\n\nTypowy zakres: od około \u221280 dBm "
              "(doskonały) do \u2212120 dBm (bardzo słaby). Wyżej (bliżej zera) jest lepiej.",
        "cs": "RSRP — přijatý výkon referenčního signálu.\n\nPrůměrný výkon referenčních signálů buňky, "
              "měřený v dBm. Odráží surovou sílu signálu.\n\nTypický rozsah: přibližně od \u221280 dBm "
              "(vynikající) po \u2212120 dBm (velmi slabý). Vyšší (blíže nule) je lepší.",
        "ko": "RSRP — 기준 신호 수신 전력.\n\ndBm으로 측정되는 셀 기준 신호의 평균 전력입니다. 순수 신호 강도를 "
              "나타냅니다.\n\n일반적인 범위: 약 \u221280 dBm(매우 좋음)에서 \u2212120 dBm(매우 약함)까지. "
              "높을수록(0에 가까울수록) 좋습니다.",
        "hi": "RSRP — रेफ़रेंस सिग्नल प्राप्त शक्ति।\n\nसेल के रेफ़रेंस सिग्नलों की औसत शक्ति, dBm में मापी जाती है। "
              "यह कच्ची सिग्नल शक्ति को दर्शाती है।\n\nसामान्य सीमा: लगभग \u221280 dBm (उत्कृष्ट) से "
              "\u2212120 dBm (बहुत कमज़ोर) तक। अधिक (शून्य के करीब) बेहतर है।",
    },
    "rsrqHint": {
        "en": "RSRQ — Reference Signal Received Quality.\n\nSignal quality in dB, factoring in "
              "interference and network load alongside strength.\n\nTypical range: about \u22123 dB "
              "(excellent) down to \u221220 dB (poor). Higher is better.",
        "it": "RSRQ — Reference Signal Received Quality (qualità ricevuta del segnale di riferimento).\n\n"
              "Qualità del segnale in dB, che tiene conto di interferenze e carico di rete oltre "
              "all'intensità.\n\nIntervallo tipico: da circa \u22123 dB (eccellente) fino a \u221220 dB "
              "(scarso). Più alto è meglio.",
        "es": "RSRQ — Calidad recibida de la señal de referencia.\n\nCalidad de señal en dB, teniendo en "
              "cuenta interferencias y carga de red además de la intensidad.\n\nRango típico: de unos "
              "\u22123 dB (excelente) hasta \u221220 dB (malo). Más alto es mejor.",
        "de": "RSRQ — Reference Signal Received Quality (empfangene Qualität des Referenzsignals).\n\n"
              "Signalqualität in dB, die neben der Stärke auch Störungen und Netzlast berücksichtigt.\n\n"
              "Typischer Bereich: etwa \u22123 dB (ausgezeichnet) bis \u221220 dB (schlecht). Höher ist "
              "besser.",
        "pt": "RSRQ — Qualidade recebida do sinal de referência.\n\nQualidade do sinal em dB, tendo em "
              "conta interferências e carga da rede além da intensidade.\n\nIntervalo típico: cerca de "
              "\u22123 dB (excelente) até \u221220 dB (mau). Mais alto é melhor.",
        "fr": "RSRQ — Qualité reçue du signal de référence.\n\nQualité du signal en dB, prenant en compte "
              "les interférences et la charge du réseau en plus de la force.\n\nPlage typique : d'environ "
              "\u22123 dB (excellent) jusqu'à \u221220 dB (mauvais). Plus élevé est meilleur.",
        "zh_Hans": "RSRQ — 参考信号接收质量。\n\n以 dB 表示的信号质量，除强度外还考虑干扰和网络负载。\n\n"
                   "典型范围：约 \u22123 dB（极佳）到 \u221220 dB（差）。数值越高越好。",
        "zh_Hant": "RSRQ — 參考訊號接收品質。\n\n以 dB 表示的訊號品質，除強度外還考慮干擾和網路負載。\n\n"
                   "典型範圍：約 \u22123 dB（極佳）到 \u221220 dB（差）。數值越高越好。",
        "ja": "RSRQ — リファレンス信号受信品質。\n\ndB 単位の信号品質で、強度に加えて干渉やネットワーク負荷も"
              "考慮します。\n\n一般的な範囲: 約 \u22123 dB（非常に良い）から \u221220 dB（悪い）まで。"
              "高いほど良好です。",
        "th": "RSRQ — คุณภาพการรับสัญญาณอ้างอิง\n\nคุณภาพสัญญาณเป็น dB โดยคำนึงถึงการรบกวนและภาระเครือข่าย"
              "นอกเหนือจากความแรง\n\nช่วงปกติ: ประมาณ \u22123 dB (ดีเยี่ยม) ลงไปถึง \u221220 dB (แย่) "
              "ยิ่งสูงยิ่งดี",
        "ru": "RSRQ — качество принятого опорного сигнала.\n\nКачество сигнала в дБ, учитывающее помимо "
              "силы также помехи и нагрузку сети.\n\nТипичный диапазон: примерно от \u22123 дБ (отлично) "
              "до \u221220 дБ (плохо). Выше — лучше.",
        "uk": "RSRQ — якість прийнятого опорного сигналу.\n\nЯкість сигналу в дБ, що враховує окрім сили "
              "також завади та навантаження мережі.\n\nТиповий діапазон: приблизно від \u22123 дБ "
              "(відмінно) до \u221220 дБ (погано). Вище — краще.",
        "pl": "RSRQ — jakość odebranego sygnału odniesienia.\n\nJakość sygnału w dB, uwzględniająca poza "
              "siłą także zakłócenia i obciążenie sieci.\n\nTypowy zakres: od około \u22123 dB (doskonały) "
              "do \u221220 dB (słaby). Wyżej jest lepiej.",
        "cs": "RSRQ — přijatá kvalita referenčního signálu.\n\nKvalita signálu v dB, která kromě síly "
              "zohledňuje také rušení a zatížení sítě.\n\nTypický rozsah: přibližně od \u22123 dB "
              "(vynikající) po \u221220 dB (špatný). Vyšší je lepší.",
        "ko": "RSRQ — 기준 신호 수신 품질.\n\n강도 외에 간섭과 네트워크 부하도 고려한 dB 단위의 신호 품질입니다."
              "\n\n일반적인 범위: 약 \u22123 dB(매우 좋음)에서 \u221220 dB(나쁨)까지. 높을수록 좋습니다.",
        "hi": "RSRQ — रेफ़रेंस सिग्नल प्राप्त गुणवत्ता।\n\ndB में सिग्नल गुणवत्ता, जो शक्ति के साथ-साथ हस्तक्षेप और "
              "नेटवर्क लोड को भी ध्यान में रखती है।\n\nसामान्य सीमा: लगभग \u22123 dB (उत्कृष्ट) से "
              "\u221220 dB (खराब) तक। अधिक बेहतर है।",
    },
    "sinrHint": {
        "en": "SINR — Signal to Interference-plus-Noise Ratio.\n\nHow much the wanted signal exceeds "
              "interference plus background noise, in dB.\n\nHigher is better: above ~20 dB is excellent, "
              "around 0 dB or below is poor.",
        "it": "SINR — rapporto segnale/interferenza+rumore.\n\nDi quanto il segnale desiderato supera "
              "l'interferenza più il rumore di fondo, in dB.\n\nPiù alto è meglio: sopra ~20 dB è "
              "eccellente, intorno a 0 dB o meno è scarso.",
        "es": "SINR — relación señal/interferencia más ruido.\n\nCuánto supera la señal deseada a la "
              "interferencia más el ruido de fondo, en dB.\n\nMás alto es mejor: por encima de ~20 dB es "
              "excelente, alrededor de 0 dB o menos es malo.",
        "de": "SINR — Signal-zu-Interferenz-plus-Rausch-Verhältnis.\n\nUm wie viel das Nutzsignal die "
              "Interferenz plus das Hintergrundrauschen übersteigt, in dB.\n\nHöher ist besser: über "
              "~20 dB ist ausgezeichnet, um 0 dB oder darunter ist schlecht.",
        "pt": "SINR — relação sinal/interferência mais ruído.\n\nQuanto o sinal desejado excede a "
              "interferência mais o ruído de fundo, em dB.\n\nMais alto é melhor: acima de ~20 dB é "
              "excelente, cerca de 0 dB ou abaixo é mau.",
        "fr": "SINR — rapport signal sur interférence plus bruit.\n\nDe combien le signal utile dépasse "
              "l'interférence plus le bruit de fond, en dB.\n\nPlus élevé est meilleur : au-dessus de "
              "~20 dB est excellent, autour de 0 dB ou en dessous est mauvais.",
        "zh_Hans": "SINR — 信号与干扰加噪声比。\n\n有用信号比干扰加背景噪声高出多少，以 dB 表示。\n\n"
                   "数值越高越好：高于约 20 dB 为极佳，约 0 dB 或以下为差。",
        "zh_Hant": "SINR — 訊號與干擾加雜訊比。\n\n有用訊號比干擾加背景雜訊高出多少，以 dB 表示。\n\n"
                   "數值越高越好：高於約 20 dB 為極佳，約 0 dB 或以下為差。",
        "ja": "SINR — 信号対干渉雑音比。\n\n目的の信号が干渉と背景雑音をどれだけ上回るかを dB で示します。\n\n"
              "高いほど良好: 約 20 dB を超えると非常に良く、0 dB 前後以下は悪いです。",
        "th": "SINR — อัตราส่วนสัญญาณต่อการรบกวนบวกสัญญาณรบกวน\n\nสัญญาณที่ต้องการเกินการรบกวนบวกสัญญาณรบกวน"
              "พื้นหลังเท่าใด เป็น dB\n\nยิ่งสูงยิ่งดี: สูงกว่า ~20 dB ถือว่าดีเยี่ยม ราว 0 dB หรือต่ำกว่าถือว่าแย่",
        "ru": "SINR — отношение сигнал/(помеха+шум).\n\nНасколько полезный сигнал превышает помехи плюс "
              "фоновый шум, в дБ.\n\nВыше — лучше: выше ~20 дБ — отлично, около 0 дБ или ниже — плохо.",
        "uk": "SINR — відношення сигнал/(завада+шум).\n\nНаскільки корисний сигнал перевищує завади плюс "
              "фоновий шум, у дБ.\n\nВище — краще: вище ~20 дБ — відмінно, близько 0 дБ або нижче — погано.",
        "pl": "SINR — stosunek sygnału do interferencji i szumu.\n\nO ile pożądany sygnał przewyższa "
              "interferencję plus szum tła, w dB.\n\nWyżej jest lepiej: powyżej ~20 dB jest doskonale, "
              "około 0 dB lub poniżej jest słabo.",
        "cs": "SINR — poměr signálu k rušení a šumu.\n\nO kolik požadovaný signál převyšuje rušení plus "
              "šum pozadí, v dB.\n\nVyšší je lepší: nad ~20 dB je vynikající, kolem 0 dB nebo méně je "
              "špatné.",
        "ko": "SINR — 신호 대 간섭 및 잡음 비.\n\n원하는 신호가 간섭과 배경 잡음을 얼마나 초과하는지를 dB로 "
              "나타냅니다.\n\n높을수록 좋습니다: 약 20 dB 이상이면 매우 좋고, 0 dB 부근이나 그 이하는 나쁩니다.",
        "hi": "SINR — सिग्नल-टू-इंटरफ़ेरेंस-प्लस-नॉइज़ अनुपात।\n\nवांछित सिग्नल हस्तक्षेप और पृष्ठभूमि शोर से कितना "
              "अधिक है, dB में।\n\nअधिक बेहतर है: ~20 dB से ऊपर उत्कृष्ट, लगभग 0 dB या उससे कम खराब है।",
    },
    "pciHint": {
        "en": "PCI — Physical Cell ID.\n\nA number (0\u2013503 on LTE) that identifies the serving cell "
              "on the radio interface. Neighbouring cells use different PCIs so the phone can tell them "
              "apart.",
        "it": "PCI — Physical Cell ID (identificatore fisico della cella).\n\nUn numero (0\u2013503 su "
              "LTE) che identifica la cella servente sull'interfaccia radio. Le celle vicine usano PCI "
              "diversi così il telefono può distinguerle.",
        "es": "PCI — Identificador físico de celda.\n\nUn número (0\u2013503 en LTE) que identifica la "
              "celda que da servicio en la interfaz de radio. Las celdas vecinas usan PCI diferentes para "
              "que el teléfono pueda distinguirlas.",
        "de": "PCI — Physical Cell ID (physische Zellkennung).\n\nEine Zahl (0\u2013503 bei LTE), die die "
              "versorgende Zelle auf der Funkschnittstelle identifiziert. Benachbarte Zellen verwenden "
              "unterschiedliche PCIs, damit das Telefon sie unterscheiden kann.",
        "pt": "PCI — Identificador físico da célula.\n\nUm número (0\u2013503 em LTE) que identifica a "
              "célula de serviço na interface de rádio. As células vizinhas usam PCIs diferentes para que "
              "o telefone as possa distinguir.",
        "fr": "PCI — Identifiant physique de cellule.\n\nUn nombre (0\u2013503 en LTE) qui identifie la "
              "cellule desservante sur l'interface radio. Les cellules voisines utilisent des PCI "
              "différents pour que le téléphone puisse les distinguer.",
        "zh_Hans": "PCI — 物理小区标识。\n\n一个数字（LTE 上为 0\u2013503），用于在无线接口上标识服务小区。"
                   "相邻小区使用不同的 PCI，以便手机能够区分它们。",
        "zh_Hant": "PCI — 實體細胞識別碼。\n\n一個數字（LTE 上為 0\u2013503），用於在無線介面上標識服務細胞。"
                   "相鄰細胞使用不同的 PCI，以便手機能夠區分它們。",
        "ja": "PCI — 物理セル ID。\n\n無線インターフェース上でサービング セルを識別する番号（LTE では "
              "0\u2013503）。隣接セルは異なる PCI を使うため、端末はそれらを区別できます。",
        "th": "PCI — รหัสเซลล์ทางกายภาพ\n\nตัวเลข (0\u2013503 บน LTE) ที่ระบุเซลล์ที่ให้บริการบนอินเทอร์เฟซวิทยุ "
              "เซลล์ข้างเคียงใช้ PCI ต่างกันเพื่อให้โทรศัพท์แยกแยะได้",
        "ru": "PCI — физический идентификатор соты.\n\nЧисло (0\u2013503 в LTE), которое идентифицирует "
              "обслуживающую соту на радиоинтерфейсе. Соседние соты используют разные PCI, чтобы телефон "
              "мог их различать.",
        "uk": "PCI — фізичний ідентифікатор соти.\n\nЧисло (0\u2013503 у LTE), що ідентифікує обслуговуючу "
              "соту на радіоінтерфейсі. Сусідні соти використовують різні PCI, щоб телефон міг їх "
              "розрізняти.",
        "pl": "PCI — fizyczny identyfikator komórki.\n\nLiczba (0\u2013503 w LTE) identyfikująca komórkę "
              "obsługującą na interfejsie radiowym. Sąsiednie komórki używają różnych PCI, aby telefon "
              "mógł je rozróżnić.",
        "cs": "PCI — fyzický identifikátor buňky.\n\nČíslo (0\u2013503 v LTE) identifikující obsluhující "
              "buňku na rádiovém rozhraní. Sousední buňky používají různá PCI, aby je telefon mohl "
              "rozlišit.",
        "ko": "PCI — 물리적 셀 ID.\n\n무선 인터페이스에서 서비스 셀을 식별하는 번호(LTE에서 0\u2013503)입니다. "
              "인접 셀은 서로 다른 PCI를 사용하여 휴대폰이 구분할 수 있습니다.",
        "hi": "PCI — भौतिक सेल ID।\n\nएक संख्या (LTE पर 0\u2013503) जो रेडियो इंटरफ़ेस पर सेवा देने वाली सेल की "
              "पहचान करती है। पड़ोसी सेल अलग-अलग PCI उपयोग करती हैं ताकि फ़ोन उन्हें अलग कर सके।",
    },
    "earfcnHint": {
        "en": "EARFCN — E-UTRA Absolute Radio Frequency Channel Number.\n\nIdentifies the exact carrier "
              "frequency the device is using; it maps to a specific LTE band and channel.",
        "it": "EARFCN — numero assoluto di canale in radiofrequenza E-UTRA.\n\nIdentifica la frequenza "
              "portante esatta usata dal dispositivo; corrisponde a una specifica banda e canale LTE.",
        "es": "EARFCN — número absoluto de canal de radiofrecuencia E-UTRA.\n\nIdentifica la frecuencia "
              "portadora exacta que usa el dispositivo; corresponde a una banda y canal LTE específicos.",
        "de": "EARFCN — E-UTRA Absolute Radio Frequency Channel Number.\n\nIdentifiziert die exakte "
              "Trägerfrequenz, die das Gerät verwendet; sie ordnet sich einem bestimmten LTE-Band und "
              "-Kanal zu.",
        "pt": "EARFCN — número absoluto de canal de radiofrequência E-UTRA.\n\nIdentifica a frequência "
              "portadora exata que o dispositivo usa; corresponde a uma banda e canal LTE específicos.",
        "fr": "EARFCN — numéro absolu de canal de radiofréquence E-UTRA.\n\nIdentifie la fréquence "
              "porteuse exacte utilisée par l'appareil ; il correspond à une bande et un canal LTE "
              "spécifiques.",
        "zh_Hans": "EARFCN — E-UTRA 绝对射频信道号。\n\n标识设备正在使用的确切载波频率；它对应到特定的 LTE "
                   "频段和信道。",
        "zh_Hant": "EARFCN — E-UTRA 絕對射頻頻道號。\n\n標識裝置正在使用的確切載波頻率；它對應到特定的 LTE "
                   "頻段和頻道。",
        "ja": "EARFCN — E-UTRA 絶対無線周波数チャンネル番号。\n\nデバイスが使用している正確なキャリア周波数を"
              "識別します。特定の LTE バンドとチャンネルに対応します。",
        "th": "EARFCN — หมายเลขช่องความถี่วิทยุสัมบูรณ์ E-UTRA\n\nระบุความถี่พาหะที่แน่นอนที่อุปกรณ์ใช้อยู่ "
              "โดยจับคู่กับแบนด์และช่อง LTE เฉพาะ",
        "ru": "EARFCN — абсолютный номер радиочастотного канала E-UTRA.\n\nОпределяет точную несущую "
              "частоту, используемую устройством; соответствует конкретному диапазону и каналу LTE.",
        "uk": "EARFCN — абсолютний номер радіочастотного каналу E-UTRA.\n\nВизначає точну несучу частоту, "
              "яку використовує пристрій; відповідає конкретному діапазону та каналу LTE.",
        "pl": "EARFCN — bezwzględny numer kanału częstotliwości radiowej E-UTRA.\n\nIdentyfikuje dokładną "
              "częstotliwość nośną używaną przez urządzenie; odpowiada konkretnemu pasmu i kanałowi LTE.",
        "cs": "EARFCN — absolutní číslo rádiového frekvenčního kanálu E-UTRA.\n\nUrčuje přesnou nosnou "
              "frekvenci, kterou zařízení používá; odpovídá konkrétnímu pásmu a kanálu LTE.",
        "ko": "EARFCN — E-UTRA 절대 무선 주파수 채널 번호.\n\n기기가 사용 중인 정확한 반송 주파수를 식별합니다. "
              "특정 LTE 밴드 및 채널에 매핑됩니다.",
        "hi": "EARFCN — E-UTRA निरपेक्ष रेडियो फ़्रीक्वेंसी चैनल नंबर।\n\nडिवाइस जिस सटीक कैरियर फ़्रीक्वेंसी का "
              "उपयोग कर रहा है उसकी पहचान करता है; यह किसी विशिष्ट LTE बैंड और चैनल से मेल खाता है।",
    },
    "estDistHint": {
        "en": "Estimated distance to the cell tower.\n\nDerived from signal strength (RSRP) using a "
              "radio propagation model. It is a very rough, order-of-magnitude indication only \u2014 not "
              "a precise measurement.",
        "it": "Distanza stimata dalla cella.\n\nDerivata dall'intensità del segnale (RSRP) usando un "
              "modello di propagazione radio. È solo un'indicazione molto approssimativa, dell'ordine di "
              "grandezza \u2014 non una misura precisa.",
        "es": "Distancia estimada a la torre de telefonía.\n\nDerivada de la intensidad de señal (RSRP) "
              "usando un modelo de propagación de radio. Es solo una indicación muy aproximada, de orden "
              "de magnitud \u2014 no una medición precisa.",
        "de": "Geschätzte Entfernung zum Mobilfunkmast.\n\nAbgeleitet aus der Signalstärke (RSRP) mit "
              "einem Funkausbreitungsmodell. Es ist nur ein sehr grober Anhaltspunkt in der Größenordnung "
              "\u2014 keine präzise Messung.",
        "pt": "Distância estimada até à torre de celular.\n\nDerivada da força do sinal (RSRP) usando um "
              "modelo de propagação de rádio. É apenas uma indicação muito aproximada, da ordem de "
              "grandeza \u2014 não uma medição precisa.",
        "fr": "Distance estimée jusqu'à l'antenne-relais.\n\nDérivée de la force du signal (RSRP) à l'aide "
              "d'un modèle de propagation radio. Ce n'est qu'une indication très approximative, d'ordre de "
              "grandeur \u2014 pas une mesure précise.",
        "zh_Hans": "到基站的估计距离。\n\n通过无线传播模型从信号强度（RSRP）推算而来。这只是一个非常粗略的"
                   "数量级参考 \u2014 并非精确测量。",
        "zh_Hant": "到基地台的估計距離。\n\n透過無線傳播模型從訊號強度（RSRP）推算而來。這只是一個非常粗略的"
                   "數量級參考 \u2014 並非精確測量。",
        "ja": "基地局までの推定距離。\n\n電波伝搬モデルを用いて信号強度（RSRP）から算出しています。これは非常に"
              "おおまかな桁数レベルの目安であり \u2014 正確な測定値ではありません。",
        "th": "ระยะโดยประมาณถึงเสาสัญญาณ\n\nคำนวณจากความแรงสัญญาณ (RSRP) โดยใช้แบบจำลองการแพร่กระจายคลื่น"
              "วิทยุ เป็นเพียงการบ่งชี้แบบคร่าว ๆ ในระดับลำดับความสำคัญเท่านั้น \u2014 ไม่ใช่การวัดที่แม่นยำ",
        "ru": "Оценочное расстояние до сотовой вышки.\n\nВычислено из уровня сигнала (RSRP) с помощью "
              "модели распространения радиоволн. Это лишь очень грубая оценка порядка величины \u2014 не "
              "точное измерение.",
        "uk": "Оцінена відстань до стільникової вежі.\n\nОбчислено з рівня сигналу (RSRP) за допомогою "
              "моделі поширення радіохвиль. Це лише дуже груба оцінка порядку величини \u2014 не точне "
              "вимірювання.",
        "pl": "Szacowana odległość do masztu komórkowego.\n\nWyznaczona z siły sygnału (RSRP) za pomocą "
              "modelu propagacji radiowej. To tylko bardzo zgrubne wskazanie rzędu wielkości \u2014 nie "
              "precyzyjny pomiar.",
        "cs": "Odhadovaná vzdálenost k buňkové věži.\n\nOdvozena ze síly signálu (RSRP) pomocí modelu "
              "šíření rádiových vln. Jde jen o velmi hrubý řádový odhad \u2014 nikoli přesné měření.",
        "ko": "기지국까지의 예상 거리.\n\n전파 전파 모델을 사용해 신호 강도(RSRP)에서 산출됩니다. 이는 매우 "
              "대략적인 자릿수 수준의 참고일 뿐이며 \u2014 정밀한 측정값이 아닙니다.",
        "hi": "सेल टावर तक अनुमानित दूरी।\n\nरेडियो प्रसार मॉडल का उपयोग करके सिग्नल शक्ति (RSRP) से निकाली "
              "गई। यह केवल एक बहुत मोटा, परिमाण-क्रम का संकेत है \u2014 सटीक माप नहीं।",
    },
}


def arb_locale_tag(loc):
    # @@locale must match the ARB filename token exactly (underscore form for
    # script variants, e.g. app_zh_Hant.arb -> "zh_Hant"); gen-l10n rejects a
    # mismatch (e.g. the BCP-47 "zh-Hant" form).
    return loc


def value_for(key, loc):
    entry = T[key]
    if loc in entry:
        return entry[loc]
    # zh base falls back to simplified Chinese.
    if loc == "zh":
        return entry.get("zh_Hans", entry["en"])
    return entry["en"]


def main():
    out_dir = os.path.join(os.path.dirname(__file__), "..", "lib", "l10n")
    out_dir = os.path.abspath(out_dir)
    # Emit every UI locale plus the required 'zh' base fallback.
    for loc in LOCALES + ["zh"]:
        data = {"@@locale": arb_locale_tag(loc)}
        for key in T:
            data[key] = value_for(key, loc)
        path = os.path.join(out_dir, f"app_{loc}.arb")
        with open(path, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write("\n")
    print(f"Wrote {len(LOCALES) + 1} ARB files with {len(T)} keys each to {out_dir}")


if __name__ == "__main__":
    main()
