import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompanyDataTile extends StatelessWidget {
  final DateTime date;
  final double open;
  final double close;
  final double adjClose;
  final double high;
  final double low;
  final int volume;

  const CompanyDataTile({
    super.key,
    required this.date,
    required this.open,
    required this.close,
    required this.adjClose,
    required this.high,
    required this.low,
    required this.volume,
  });

  final int precision = 2;

  String roundDouble(double number, int precision) {
    return number.toStringAsFixed(precision);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(DateFormat("dd MMM ''yy").format(date)),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Open: ${roundDouble(open, precision)}"),
              Text("Close: ${roundDouble(close, precision)}"),
              Text("Adj close: ${roundDouble(adjClose, precision)}"),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("High: ${roundDouble(high, precision)}"),
              Text("Low: ${roundDouble(low, precision)}"),
            ],
          ),
        ],
      ),
      trailing: Text("Vol: $volume"),
    );
  }
}
