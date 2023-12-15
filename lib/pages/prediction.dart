import 'package:finance_fate/pod/company.dart';
import 'package:finance_fate/provider/company_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PredictionPage extends StatelessWidget {
  const PredictionPage({super.key, required this.companyTicker});

  final String companyTicker;
  final int precision = 2;
  final int tabLength = 2;

  String roundDouble(double number, int precision) {
    return number.toStringAsFixed(precision);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabLength,
      child: Scaffold(
        appBar: AppBar(
          title: Text(companyTicker),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text('Predictions'),
              ),
              Tab(
                child: Text('Actual data'),
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: null,
              heroTag: UniqueKey(),
              child: const Icon(
                Icons.show_chart_rounded,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            FloatingActionButton(
              onPressed: null,
              heroTag: UniqueKey(),
              child: const Icon(Icons.search),
            )
          ],
        ),
        body: Consumer<CompanyList>(
          builder: (context, companyList, child) {
            Company company = companyList.findCompanyFromTicker(companyTicker)!;
            List<CompanyData> companyData = company.data;
            return TabBarView(
              children: [
                const Placeholder(),
                Scrollbar(
                  interactive: true,
                  child: ListView.builder(
                    itemCount: companyData.length,
                    itemBuilder: (context, index) {
                      CompanyData data = company.data[index];
                      return ListTile(
                        title:
                            Text(DateFormat("dd MMM ''yy").format(data.date)),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Open: ${roundDouble(data.open, precision)}"),
                                Text(
                                    "Close: ${roundDouble(data.close, precision)}"),
                                Text(
                                    "Adj close: ${roundDouble(data.adjClose, precision)}"),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "High: ${roundDouble(data.high, precision)}"),
                                Text(
                                    "Low: ${roundDouble(data.low, precision)}"),
                              ],
                            ),
                          ],
                        ),
                        trailing: Text("Vol: ${data.volume}"),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
