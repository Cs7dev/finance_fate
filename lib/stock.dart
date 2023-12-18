// ignore_for_file: unused_import

import 'dart:math';

import 'package:finance_fate/pod/company.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';
import 'package:http/http.dart' as http;

class StockData {
  Future<YahooFinanceResponse?> apiData(
      {required String ticker,
      DateTime? startDate,
      bool adjust = false}) async {
    startDate ??= DateTime.now().copyWith(year: DateTime.now().year - 1);

    YahooFinanceResponse? response;

    try {
      response = await const YahooFinanceDailyReader()
          .getDailyDTOs(ticker, startDate: startDate, adjust: adjust);
    } catch (e) {
      print(e.toString());
    }

    return response;
  }

  Future<Company?> companyData(String ticker) async {
    YahooFinanceResponse? companyData =
        await StockData().apiData(ticker: ticker);

    if (companyData == null) {
      return null;
    }

    List<CompanyData> stockData = [];

    for (var element in companyData.candlesData.reversed) {
      CompanyData data = CompanyData(
        date: element.date,
        adjClose: element.adjClose,
        close: element.close,
        high: element.high,
        low: element.low,
        open: element.open,
        volume: element.volume,
      );
      stockData.add(data);
    }

    return Company(ticker: ticker, actualData: stockData);
  }

  void predictData(Company company) {
    company.predictedData = [];

    for (var element in company.actualData) {
      double adjClose = element.adjClose + (Random().nextInt(21) - 10);
      double close = element.close + (Random().nextInt(21) - 10);
      double open = element.open + (Random().nextInt(21) - 10);
      double high = element.high + (Random().nextInt(21) - 10);
      double low = element.low + (Random().nextInt(21) - 10);
      int volume = element.volume + (Random().nextInt(21) - 10);

      company.predictedData!.add(CompanyData(
          date: element.date,
          adjClose: adjClose,
          close: close,
          high: high,
          low: low,
          open: open,
          volume: volume));
    }
  }
}
