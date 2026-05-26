import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/providers/log_provider.dart';
import 'package:simply_net/providers/scan_provider.dart';
import 'package:simply_net/providers/settings_provider.dart';
import 'package:simply_net/screens/home_screen.dart';
import 'package:simply_net/screens/logs_screen.dart';
import 'package:simply_net/screens/network_tools_screen.dart';
import 'package:simply_net/screens/placeholder_screen.dart';
import 'package:simply_net/screens/scan_screen.dart';
import 'package:simply_net/screens/settings_screen.dart';
import 'package:simply_net/services/oui_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OuiService.init();
  runApp(const SimplyNetApp());
}

class SimplyNetApp extends StatelessWidget {
  const SimplyNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()..load()),
        ChangeNotifierProvider(create: (_) => ScanProvider()),
        ChangeNotifierProvider(create: (_) => LogProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (_, settings, _) {
          // Validate font scale: ensure it's positive and reasonable
          double scale = settings.settings.fontScale;
          if (scale <= 0 || scale.isNaN || scale.isInfinite) {
            scale = 1.0; // Fallback to medium size if corrupted
          }
          return MaterialApp(
            title: 'SimplyNet',
            debugShowCheckedModeBanner: false,
            themeMode: settings.themeMode,
            theme: _buildTheme(Brightness.light, scale),
            darkTheme: _buildTheme(Brightness.dark, scale),
            initialRoute: '/',
            routes: {
              '/': (_) => const HomeScreen(),
              '/scan': (_) => const ScanScreen(),
              '/logs': (_) => const LogsScreen(),
              '/network_tools': (_) => const NetworkToolsScreen(),
              '/wifi_tools': (_) =>
                  const PlaceholderScreen(title: 'WiFi Tools'),
              '/settings': (_) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness, double fontScale) {
    const seed = Color(0xFF1976D2);
    // Ensure font scale is valid
    fontScale = fontScale.clamp(0.5, 2.0);
    
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: brightness,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: seed,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(backgroundColor: seed),
      ),
    );
    // Apply font scale to every text style in the theme
    final scaled = base.textTheme.apply(fontSizeFactor: fontScale);
    return base.copyWith(
      textTheme: scaled,
      primaryTextTheme: base.primaryTextTheme.apply(fontSizeFactor: fontScale),
    );
  }
}
