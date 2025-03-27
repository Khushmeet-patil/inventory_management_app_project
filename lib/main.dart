import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/home_page.dart';
import 'views/add_product_page.dart';
import 'views/rent_page.dart';
import 'views/return_page.dart';
import 'views/view_stock_page.dart';
import 'views/history_pages/added_history_page.dart';
import 'views/history_pages/rented_history_page.dart';
import 'views/history_pages/returned_history_page.dart';
import 'controllers/product_controller.dart';

void main() {
  runApp(InventoryApp());
}

class InventoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Inventory Management',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardTheme(elevation: 4, margin: EdgeInsets.all(8)),
        buttonTheme: ButtonThemeData(buttonColor: Colors.teal, textTheme: ButtonTextTheme.primary),
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(ProductController());
      }),
      getPages: [
        GetPage(name: '/', page: () => MainPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/add', page: () => AddProductPage()),
        GetPage(name: '/rent', page: () => RentPage()),
        GetPage(name: '/return', page: () => ReturnPage()),
        GetPage(name: '/stock', page: () => ViewStockPage()),
        GetPage(name: '/rental-history', page: () => RentalHistoryPage()),
        GetPage(name: '/return-history', page: () => ReturnHistoryPage()),
        GetPage(name: '/added-history', page: () => AddedProductHistoryPage()),
      ],
      initialRoute: '/',
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    AddProductPage(),
    RentPage(),
    ReturnPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Rent'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_return), label: 'Return'),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }
}