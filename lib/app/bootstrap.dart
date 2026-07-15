import 'package:calora/app/calora_app.dart';
import 'package:calora/app/providers/app_providers.dart';
import 'package:calora/app/services/theme_preferences_service.dart';
import 'package:calora/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final themePreferences = SharedPreferencesThemePreferencesService();
  final initialThemeMode = await themePreferences.loadThemeMode();
  runApp(
    MultiProvider(
      providers: appProviders(
        themePreferences: themePreferences,
        initialThemeMode: initialThemeMode,
      ),
      child: const CaloraApp(),
    ),
  );
}
