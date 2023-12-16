import 'package:finance_fate/actual_data_tabview.dart';
import 'package:finance_fate/pod/company.dart';
import 'package:finance_fate/provider/company_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key, required this.companyTicker});

  final String companyTicker;

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _tabIndex;
  bool displayActualChart = true;
  bool displayPredictionChart = true;

  final List<Widget> tabs = const [
    Tab(child: Text('Predictions')),
    Tab(child: Text('Actual data')),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabIndex = _tabController.index;

    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void toggleActualChart() {
    setState(() {
      displayActualChart = !displayActualChart;
    });
  }

  void togglePredictionChart() {
    setState(() {
      displayPredictionChart = !displayPredictionChart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.companyTicker),
          bottom: TabBar(
            controller: _tabController,
            tabs: tabs,
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_tabIndex == 0) ...{
              FloatingActionButton.small(
                onPressed: togglePredictionChart,
                heroTag: UniqueKey(),
                child: const Icon(
                  Icons.show_chart_rounded,
                ),
              ),
              const SizedBox(
                width: 16,
                height: 16,
              ),
              FloatingActionButton(
                onPressed: null,
                heroTag: UniqueKey(),
                child: const Icon(Icons.search),
              )
            } else if (_tabIndex == 1) ...{
              FloatingActionButton.small(
                onPressed: toggleActualChart,
                heroTag: UniqueKey(),
                child: const Icon(
                  Icons.show_chart_rounded,
                ),
              ),
              const SizedBox(
                width: 16,
                height: 16,
              ),
              FloatingActionButton(
                onPressed: null,
                heroTag: UniqueKey(),
                child: const Icon(Icons.search),
              )
            }
          ],
        ),
        body: Consumer<CompanyList>(
          builder: (context, companyList, child) {
            Company company =
                companyList.findCompanyFromTicker(widget.companyTicker)!;
            List<CompanyData> companyData = company.data;
            return TabBarView(
              controller: _tabController,
              children: [
                const Placeholder(),
                ActualDataTabView(
                  companyData: companyData,
                  company: company,
                  showChart: displayActualChart,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
