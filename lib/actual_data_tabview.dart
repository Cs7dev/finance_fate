import 'package:finance_fate/company_data_tile.dart';
import 'package:finance_fate/pod/company.dart';
import 'package:flutter/material.dart';

class ActualDataTabView extends StatelessWidget {
  const ActualDataTabView({
    super.key,
    required this.companyData,
    required this.company,
    required this.showChart,
  });

  final List<CompanyData> companyData;
  final Company company;
  final bool showChart;

  @override
  Widget build(BuildContext context) {
    return showChart == true
        ? Placeholder()
        : Scrollbar(
            interactive: true,
            child: ListView.builder(
              itemCount: companyData.length,
              itemBuilder: (context, index) {
                CompanyData data = company.data[index];
                return CompanyDataTile(
                  adjClose: data.adjClose,
                  close: data.close,
                  high: data.high,
                  low: data.low,
                  open: data.open,
                  volume: data.volume,
                  date: data.date,
                );
              },
            ),
          );
  }
}
