import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:hustle_gpt/screens/home_screen.dart';
import 'package:hustle_gpt/screens/explore_screen.dart';
import 'package:hustle_gpt/screens/history_screen.dart';
import 'package:hustle_gpt/screens/profile_screen.dart';
import 'package:hustle_gpt/providers/analysis_provider.dart';
import 'package:hustle_gpt/providers/theme_provider.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AnalysisProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: MyApp(cameras: cameras),
      ),
    );
  } catch (e) {
    debugPrint('Error initializing cameras: $e');
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AnalysisProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MyApp(cameras: []),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final baseTheme = ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        },
      ),
    );

    return MaterialApp(
      title: 'HustleGPT',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: _buildTheme(Brightness.light, baseTheme),
      darkTheme: _buildTheme(Brightness.dark, baseTheme),
      home: MainScreen(cameras: cameras),
    );
  }

  ThemeData _buildTheme(Brightness brightness, ThemeData baseTheme) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: const Color(0xFF82D1E3), // Light blue
      onPrimary: Colors.white,
      secondary: const Color(0xFF6C63FF), // Purple
      onSecondary: Colors.white,
      tertiary: const Color(0xFFE5E7EB),
      background: isDark ? Colors.black : Colors.white,
      onBackground: isDark ? Colors.white : Colors.black,
      surface: isDark ? const Color(0xFF121212) : Colors.white,
      onSurface: isDark ? Colors.white : const Color(0xFF1A1A1A),
      error: const Color(0xFFDC2626),
      onError: Colors.white,
    );

    return baseTheme.copyWith(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: colorScheme.background,

      // Text Theme
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.onBackground.withOpacity(0.05)),
        ),
        margin: EdgeInsets.zero,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: colorScheme.onBackground,
        ),
        iconTheme: IconThemeData(color: colorScheme.onBackground),
      ),

      // Bottom Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        height: 80,
        elevation: 0,
        backgroundColor: colorScheme.background,
        indicatorColor: colorScheme.primary.withOpacity(0.12),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: states.contains(MaterialState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
            color: states.contains(MaterialState.selected)
                ? colorScheme.primary
                : colorScheme.onBackground.withOpacity(0.7),
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          return IconThemeData(
            size: 24,
            color: states.contains(MaterialState.selected)
                ? colorScheme.primary
                : colorScheme.onBackground.withOpacity(0.7),
          );
        }),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const MainScreen({super.key, required this.cameras});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(cameras: widget.cameras),
      const HistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          height: 80,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Theme.of(context).colorScheme.background,
          indicatorColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: _selectedIndex == 0
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.history_outlined,
                color: _selectedIndex == 1
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
              ),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person_outline,
                color: _selectedIndex == 2
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
