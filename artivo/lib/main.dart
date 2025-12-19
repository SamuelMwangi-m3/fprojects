// main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'auth/login_screen.dart';
import 'catalog/catalog_screen.dart';
import 'wishlist/wishlist_screen.dart';
import 'orders/orders_screen.dart';
import 'artist_dashboard/artist_dashboard_screen.dart';
import 'chat/chat_screen.dart';
import 'loyalty/loyalty_screen.dart';
import 'utils/constants.dart';
import 'admin/admin_dashboard.dart';
import 'screens/search_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/help_center_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'sb_publishable_ltaNA7nnVozoSCOcZIjg'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'sb_publishable_YpotEpinEWsC2dI7FIKI'),
  );
  runApp(const ArtCommerceApp());
}

class ArtCommerceApp extends StatefulWidget {
  const ArtCommerceApp({Key? key}) : super(key: key);

  @override
  State<ArtCommerceApp> createState() => _ArtCommerceAppState();
}

class _ArtCommerceAppState extends State<ArtCommerceApp> {
  final ThemeController _theme = ThemeController();

  @override
  void initState() {
    super.initState();
    _theme.addListener(_onTheme);
  }

  @override
  void dispose() {
    _theme.removeListener(_onTheme);
    super.dispose();
  }

  void _onTheme() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Commerce',
      themeMode: _theme.mode,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const MainNavigationScreen(),
      routes: {
        '/product-detail': (ctx) => const ProductDetailScreen(),
        '/cart': (ctx) => const CartScreen(),
        AppRoutes.login: (ctx) => const LoginScreen(),
        AppRoutes.catalog: (ctx) => const CatalogScreen(),
        AppRoutes.wishlist: (ctx) => const WishlistScreen(),
        AppRoutes.orders: (ctx) => const OrdersScreen(),
        AppRoutes.artist: (ctx) => const ArtistDashboardScreen(),
        AppRoutes.chat: (ctx) => const ChatScreen(),
        AppRoutes.loyalty: (ctx) => const LoyaltyScreen(),
        AppRoutes.admin: (ctx) => const AdminDashboard(),
        AppRoutes.search: (ctx) => const SearchScreen(),
        AppRoutes.checkout: (ctx) => const CheckoutScreen(),
        AppRoutes.help: (ctx) => const HelpCenterScreen(),
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

