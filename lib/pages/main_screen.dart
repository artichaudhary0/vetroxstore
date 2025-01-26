import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vetroxstore/pages/about_us_page.dart';
import 'package:vetroxstore/pages/become_seller_page.dart';
import 'package:vetroxstore/pages/call_center_page.dart';
import 'package:vetroxstore/pages/consultation_form.dart';
import 'package:vetroxstore/pages/my_cart_page.dart';
import 'package:vetroxstore/pages/store_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetroxstore/pages/login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _isMenuOpen = false;

  final List<Widget> _pages = [
    const StoreScreen(),
    const CallCenterScreen(),
    const ConsultationForm(),
  ];

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _onMenuItemTap(int index, String page) async {
    _toggleMenu();
    if (page == 'Our Website') {
      const url = 'https://vetrox.in/';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else if (page == 'My Cart') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyCartPage()),
      );
    } else if (page == 'About Us') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AboutPage()),
      );
    } else if (page == 'Become Seller') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BecomeSellerPage()),
      );
    } else if (page == 'Log Out') {
      _logOut();
    }
  }

  // Log Out function
  Future<void> _logOut() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    await prefs.remove('token');
    print(prefs.getString('token'));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 6,
            shadowColor: Colors.grey.withOpacity(0.5),
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: const Text(
              "STORE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 0,
                color: Colors.black,
              ),
            ),
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: _toggleMenu,
              ),
            ],
          ),
          extendBodyBehindAppBar: true,
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF082580),
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Store',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.call),
                label: 'Call Center',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Consult',
              ),
            ],
          ),
        ),
        if (_isMenuOpen)
          Positioned.fill(
            child: Material(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 16),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        iconSize: 30,
                        onPressed: _toggleMenu,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/applogo.png',
                          width: 100,
                          height: 45,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Hello there!",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        MenuItem(
                          icon: Icons.home,
                          text: 'Our Website',
                          onTap: () => _onMenuItemTap(0, 'Our Website'),
                        ),
                        MenuItem(
                          icon: Icons.shopping_cart,
                          text: 'My Cart',
                          onTap: () => _onMenuItemTap(1, 'My Cart'),
                        ),
                        MenuItem(
                          icon: Icons.people,
                          text: 'About Us',
                          onTap: () => _onMenuItemTap(1, 'About Us'),
                        ),
                        MenuItem(
                          icon: Icons.star,
                          text: 'Become Seller',
                          onTap: () => _onMenuItemTap(1, 'Become Seller'),
                        ),
                        MenuItem(
                          icon: Icons.info_outline,
                          text: 'Log Out',
                          onTap: () => _onMenuItemTap(2, 'Log Out'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey[600],
        size: 22,
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
      ),
      onTap: onTap,
    );
  }
}
