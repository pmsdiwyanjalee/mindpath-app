import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mind_path/locale_manager.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/resources_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/journal_entries_screen.dart';
import 'screens/craving_tracker_screen.dart';
import 'screens/appointments_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/wellness_screen.dart';
import 'screens/support_group_directory_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/achievements_screen.dart';
import 'screens/coping_skills_screen.dart';
import 'screens/community_forum_screen.dart';
import 'screens/success_stories_screen.dart';
import 'screens/medication_tracker_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/emergency_resources_screen.dart';
import 'admin/admin_login_screen.dart';
import 'admin/admin_dashboard_screen.dart';
import 'admin/admin_users_management_screen.dart';
import 'admin/admin_counselors_management_screen.dart';
import 'admin/admin_resources_management_screen.dart';
import 'admin/admin_analytics_screen.dart';
import 'admin/admin_support_tickets_screen.dart';
import 'admin/admin_data_models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocaleManager.localeNotifier,
      builder: (context, locale, child) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          debugShowCheckedModeBanner: false,
          locale: locale,
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale == null) return const Locale('en');
            for (final supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }
            return const Locale('en');
          },
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('si'), // Sinhala
            Locale('ta'), // Tamil
          ],
          theme: ThemeData(
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a purple toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to run the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const LoginScreen(),
          routes: {
            '/register': (_) => const RegisterScreen(),
            '/dashboard': (_) => const DashboardScreen(),
            '/chat': (_) => const ChatScreen(),
            '/resources': (_) => const ResourcesScreen(),
            '/progress': (_) => const ProgressScreen(),
            '/journal': (_) => const JournalEntriesScreen(),
            '/cravings': (_) => const CravingTrackerScreen(),
            '/appointments': (_) => const AppointmentsScreen(),
            '/profile': (_) => const ProfileScreen(),
            '/wellness': (_) => const WellnessScreen(),
            '/support-groups': (_) => const SupportGroupDirectoryScreen(),
            '/settings': (_) => const SettingsScreen(),
            '/achievements': (_) => const AchievementsScreen(),
            '/coping-skills': (_) => const CopingSkillsScreen(),
            '/community': (_) => const CommunityForumScreen(),
            '/success-stories': (_) => const SuccessStoriesScreen(),
            '/medications': (_) => const MedicationTrackerScreen(),
            '/notifications': (_) => const NotificationsScreen(),
            '/emergency': (_) => const EmergencyResourcesScreen(),
            '/admin-login': (_) => const AdminLoginScreen(),
            '/admin-dashboard': (context) {
              final args =
                  ModalRoute.of(context)?.settings.arguments as AdminUser?;
              return AdminDashboardScreen(
                  adminUser: args ??
                      AdminUser(
                        id: 'default',
                        email: 'admin@mindpath.com',
                        password: 'Admin@2024',
                        fullName: 'Admin User',
                        role: 'admin',
                        createdAt: DateTime.now(),
                        isActive: true,
                        permissions: ['read', 'write', 'delete'],
                      ));
            },
            '/admin-users': (_) => const AdminUsersManagementScreen(),
            '/admin-counselors': (_) => const AdminCounselorsManagementScreen(),
            '/admin-resources': (_) => const AdminResourcesManagementScreen(),
            '/admin-analytics': (_) => const AdminAnalyticsScreen(),
            '/admin-support': (_) => const AdminSupportTicketsScreen(),
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
