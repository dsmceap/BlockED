import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blocked_verifier_app/homepage.dart';
import 'AppTheme.dart';
import 'Providers/theme_state_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeStateNotifier>(
            create: (_) => ThemeStateNotifier(prefs.getBool("isDarkMode")??false),
          ),
        ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeStateProvider = Provider.of<ThemeStateNotifier>(context);
    return Consumer(
        builder: (context, appState, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'block.Ed Pass Verifier',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              home:  const MyHomePage(),
              themeMode:  themeStateProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light
          );
        }
    );
  }

}