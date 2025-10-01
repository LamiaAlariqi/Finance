import 'package:finance/views/screens/Sales.dart';
import 'package:finance/views/screens/expenses.dart';
import 'package:finance/views/screens/home.dart';
import 'package:finance/views/screens/receipts.dart';
import 'package:finance/views/screens/reports.dart';
import 'package:finance/views/usedwidget/bottom_navigator.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<Widget> _pages = [
    const HomeScreen(),
    const Sales(),
    const Receipts(),
    const Expenses(),
    const Reports(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigator(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
