import 'package:finance_fate/pages/company/widgets/actual_data_tabview.dart';
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
  bool showActualChart = true;
  bool showPredictionChart = true;

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
      showActualChart = !showActualChart;
    });
  }

  void togglePredictionChart() {
    setState(() {
      showPredictionChart = !showPredictionChart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          //Todo: Consider getting rid of the search functionality

          if (_tabIndex == 0) ...{
            ToggleChartFloatingButton(
              showChart: showPredictionChart,
              onPressed: () => togglePredictionChart(),
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
            ToggleChartFloatingButton(
              showChart: showActualChart,
              onPressed: () => toggleActualChart(),
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
          return TabBarView(
            controller: _tabController,
            children: [
              const Placeholder(),
              ActualDataTabView(
                company: company,
                showChart: showActualChart,
              ),
            ],
          );
        },
      ),
    );
  }
}

class ToggleChartFloatingButton extends StatelessWidget {
  const ToggleChartFloatingButton({
    super.key,
    required this.showChart,
    this.onPressed,
  });

  final bool showChart;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () => onPressed?.call(),
      heroTag: UniqueKey(),
      child: Icon(
        showChart ? Icons.article_outlined : Icons.show_chart_rounded,
        semanticLabel: 'Toggle betweeen chart view and text view',
      ),
    );
  }
}
