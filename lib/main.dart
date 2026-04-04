import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

/// Global navigator key used by notification tap callbacks to navigate.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ── Initialise Notification Service ──
  await NotificationService().initialize(
    onTap: (String? payload) {
      // Navigate to the appropriate screen based on payload route
      if (payload != null && navigatorKey.currentState != null) {
        debugPrint('🔔 Navigating to: $payload');
        // Payload-based routing can be extended here
        navigatorKey.currentState?.pushNamed(payload);
      }
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Looms Management',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.themeMode,
            navigatorKey: navigatorKey,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
