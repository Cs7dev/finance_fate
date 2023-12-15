import 'package:file_picker/file_picker.dart';
import 'package:finance_fate/pages/stock_input_dialog.dart';
import 'package:finance_fate/pages/prediction.dart';
import 'package:finance_fate/pod/company.dart';
import 'package:finance_fate/provider/company_provider.dart';
import 'package:finance_fate/stock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Fate'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String? ticker = await showDialog(
            context: context,
            builder: (context) => const StockInputDialog(),
          );

          // Do nothing if no input is provided
          if (ticker == null || ticker.isEmpty) return;

          Company? company = await StockData().companyData(ticker);

          // If no data is returned, do nothing
          if (company == null) return;

          if (mounted) {
            Provider.of<CompanyList>(context, listen: false).addUser(company);
          }
        },
        label: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.add_chart_outlined),
            SizedBox(width: 4),
            // Text('Import market file')
            Text('Add company')
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<CompanyList>(
          builder: (context, companies, child) => Column(
            children: List.generate(
              companies.length(),
              (index) => ListTile(
                title: Text(companies.companyList[index].ticker),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PredictionPage(
                        companyName: companies.companyList[index].ticker),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  selectCsvFile() async {
    FilePickerResult? marketValueFilePath = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['csv'],
      type: FileType.custom,
    );

    if (marketValueFilePath == null) {
      return;
    }

    // File marketValueFile = File(marketValueFilePath.files.first.path!);
    // print(await markveValueFile.readAsLines());
  }
}
