import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'screens/test_items_screen.dart';
import 'screens/reservation_screen.dart';
import 'screens/payments_screen.dart';
import 'services/auth_service.dart';
import 'models/home_section.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Page d\'accueil',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF00a8a3)),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasData) {
            return const MyHomePage(title: 'Page d\'accueil');
          }
          
          return const LoginScreen();
        },
      ),
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
  final _authService = AuthService();
  bool _isAdmin = false;

  final List<HomeSection> _sections = [
    HomeSection(title: 'Réservation', assetPath: 'assets/logo.JPG'),
    HomeSection(title: 'Gestion de maçon', assetPath: 'assets/logo.JPG'),
    // Add more sections as needed
  ];

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await _authService.isUserAdmin();
    if (mounted) {
      setState(() {
        _isAdmin = isAdmin;
      });
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _navigateToTestItems() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TestItemsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        elevation: 0,
        actions: [
          if (_isAdmin)
           /*  IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () {
                // TODO: Navigate to admin panel
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Admin Panel - Coming Soon')),
                );
              },
              tooltip: 'Admin Panel',
            ), */
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        itemCount: _sections.length,
        itemBuilder: (context, index) {
          final section = _sections[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            elevation: 0,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  section.assetPath,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                section.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReservationScreen()),
                  );
                } else if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentsScreen()),
                  );
                }
                // TODO: Add navigation for other sections
              },
            ),
          );
        },
      ),
      /* floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), */
    );
  }
}
