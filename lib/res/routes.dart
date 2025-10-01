import 'package:finance/views/screens/Login.dart';
import 'package:finance/views/screens/Sales.dart';
import 'package:finance/views/screens/expenses.dart';
import 'package:finance/views/screens/home.dart';
import 'package:finance/views/screens/receipts.dart';
import 'package:finance/views/screens/reports.dart';
import 'package:flutter/material.dart';
class MyRoutes {
  static const String homeScreen = "homeScreen"; 
  static const String loginScreen="loginScreen";
  static const String receiptsScreen="receiptsScreen";
  static const String reportsScreen="reportsScreen";
  static const String expenseScreen="expenseScreen";
  static const String salesScreen="salesScreen";

}
Map<String, Widget Function(BuildContext)> routes = {
  MyRoutes.homeScreen: (context) => const HomeScreen(),
  MyRoutes.loginScreen: (context) => const Login(),
  MyRoutes.receiptsScreen: (context) => const Receipts (),
  MyRoutes.reportsScreen: (context) => const Reports(),
  MyRoutes.salesScreen: (context) => const Sales(),
  MyRoutes.expenseScreen: (context) => const Expenses(),

 
};
