import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simply_net/providers/log_provider.dart';
import 'package:simply_net/providers/scan_provider.dart';
import 'package:simply_net/providers/settings_provider.dart';
import 'package:simply_net/screens/about_screen.dart';
import 'package:simply_net/screens/home_screen.dart';
import 'package:simply_net/screens/logs_screen.dart';
import 'package:simply_net/screens/network_tools_screen.dart';
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
        ChangeNotifierProxyProvider<ScanProvider, LogProvider>(
          create: (_) => LogProvider(),
          update: (_, scanProv, logProv) {
            logProv!.listenToScanProvider(scanProv);
            return logProv;
          },
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (_, settings, _) {
          return MaterialApp(
            title: 'SimplyNet',
            debugShowCheckedModeBanner: false,
            themeMode: settings.themeMode,
            theme: _buildTheme(Brightness.light),
            darkTheme: _buildTheme(Brightness.dark),
            initialRoute: '/',
            routes: {
              '/':              (_) => const HomeScreen(),
              '/scan':          (_) => const ScanScreen(),
              '/logs':          (_) => const LogsScreen(),
              '/network_tools': (_) => const NetworkToolsScreen(),
              '/settings':      (_) => const SettingsScreen(),
              '/about':         (_) => const AboutScreen(),
            },
          );
        },
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    const seed = Color(0xFF1976D2);
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
          seedColor: seed, brightness: brightness),
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
    return base;
  }
}
