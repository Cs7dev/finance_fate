class Company {
  String ticker;
  List<CompanyData> actualData;
  List<CompanyData>? predictedData;

  Company({
    required this.ticker,
    this.actualData = const [],
    this.predictedData,
  });
}

class CompanyData {
  DateTime date;
  double adjClose;
  double open;
  double close;
  double high;
  double low;
  int volume;

  CompanyData(
      {required this.date,
      required this.adjClose,
      required this.close,
      required this.high,
      required this.low,
      required this.open,
      required this.volume});
}
