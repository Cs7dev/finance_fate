import 'package:finance_fate/pod/company.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

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
}
