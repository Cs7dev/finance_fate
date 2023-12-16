import 'package:finance_fate/pages/company/company_page.dart';
import 'package:finance_fate/pod/company.dart';
import 'package:finance_fate/provider/company_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ReorderableCompanyListView extends StatefulWidget {
  const ReorderableCompanyListView({
    super.key,
  });

  @override
  State<ReorderableCompanyListView> createState() =>
      _ReorderableCompanyListViewState();
}

class _ReorderableCompanyListViewState extends State<ReorderableCompanyListView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      upperBound: 1.025,
      lowerBound: 1,
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyList>(
      builder: (context, companyList, child) => ReorderableListView(
        proxyDecorator: (child, index, animation) => ScaleTransition(
          scale: Tween<double>(begin: 1, end: 1.03).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Curves.linear,
            ),
          ),
          child: Material(
            child: ListTile(
              title: Text(companyList.companyList[index].ticker),
            ),
          ),
        ),
        onReorder: (oldIndex, newIndex) async {
          // setState(() {
          // These two lines are workarounds for ReorderableListView problems
          // Source: https://stackoverflow.com/questions/54162721/onreorder-arguments-in-flutter-reorderablelistview?newreg=398dc3a491ee40fbad1b76ab1e303977
          if (newIndex > companyList.length()) {
            newIndex = companyList.length();
          }
          if (oldIndex < newIndex) newIndex--;
          Company company = companyList.companyAtIndex(oldIndex);
          // Remove from the application list
          companyList.deleteUser(company);
          companyList.insertUser(newIndex, company);
          // });
        },
        children: [
          for (int index = 0; index < companyList.length(); ++index)
            DismissibleListTile(
              key: UniqueKey(),
              company: companyList.companyAtIndex(index),
            ),
        ],
      ),
    );
  }
}

class DismissibleListTile extends StatelessWidget {
  const DismissibleListTile({
    super.key,
    required this.company,
  });

  final Company company;

  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyList>(
      builder: (context, companyList, child) => Dismissible(
        background: const DismissableBackground(
          alignment: AlignmentDirectional.centerStart,
        ),
        secondaryBackground: const DismissableBackground(
          alignment: AlignmentDirectional.centerEnd,
        ),
        onUpdate: (details) async {
          if (!details.previousReached && details.reached) {
            HapticFeedback.lightImpact();
          }
        },
        dismissThresholds: const {DismissDirection.horizontal: 0.45},
        onDismissed: (DismissDirection direction) async {
          int index = companyList.indexOfCompany(company.ticker);
          companyList.deleteUser(company);
          if (context.mounted) {
            SnackBar undoDeleteSnack = SnackBar(
              duration: const Duration(seconds: 6),
              content: Text.rich(
                TextSpan(
                  text: 'Company ',
                  children: [
                    TextSpan(
                      text: company.ticker,
                    ),
                    const TextSpan(text: ' removed from list'),
                  ],
                ),
              ),
              action: SnackBarAction(
                label: 'Undo?',
                onPressed: () {
                  companyList.insertUser(index, company);
                },
              ),
            );

            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldFeatureController<SnackBar, SnackBarClosedReason> sfc =
                ScaffoldMessenger.of(context).showSnackBar(undoDeleteSnack);

            await sfc.closed;
          }
        },
        key: UniqueKey(),
        child: Material(
          child: ListTile(
            title: Text(company.ticker),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PredictionPage(companyTicker: company.ticker),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DismissableBackground extends StatelessWidget {
  const DismissableBackground({
    super.key,
    this.alignment,
  });

  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
      alignment: alignment,
      child: const Icon(Icons.delete),
    );
  }
}
