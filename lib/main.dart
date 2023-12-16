import 'package:finance_fate/provider/company_provider.dart';
import 'package:finance_fate/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(const FinanceFate());
}

class FinanceFate extends StatelessWidget {
  const FinanceFate({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CompanyList(),
      builder: (context, child) => MaterialApp(
        title: 'Stock App',
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          primarySwatch: Colors.blue,
          fontFamily: 'Overpass',
        ),
        home: const HomePage(),
      ),
    );
  }
}
