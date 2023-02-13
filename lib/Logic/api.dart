import 'dart:convert';

import 'package:binance_clone/Model/crypto_model.dart';
import 'package:http/http.dart' as http;

class API {
  final latest_url =
      ' https://pro-api.coinmarketcap.com/v2/cryptocurrency/quotes/latest ';
  final historical_url =
      'https://pro-api.coinmarketcap.com/v2/cryptocurrency/quotes/historical';
  final homePageCryptos = ['BNB', 'CAKE', "ETH", "BTC", 'FTT', 'APE'];
  getMultipleCryptosLatetData(List cryptos) async {
    late Uri url;
    url = Uri.https(
        "pro-api.coinmarketcap.com", "/v2/cryptocurrency/quotes/latest", {
      "symbol": cryptos.join(','),
    });
    try {
      var response = await http.get(url, headers: {
        "X-CMC_PRO_API_KEY": "35802461-579d-4275-80a4-818533490780",
      });
      // print('response: ${response.body}');
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse != null) {
        final returnedData = jsonResponse['data'];
        print('response: ${returnedData["APE"]}');
        final cryptoObjects = {};
        for (var c in cryptos) {
          double d = 3.0;

          final jsonCrypto = returnedData[c];
          final cryptometaData = jsonCrypto[0]['quote']['USD'];
          CryptoModel crypto = CryptoModel(
              symbol: jsonCrypto[0]['symbol'],
              price: cryptometaData['price'].toStringAsFixed(2),
              percent_change_1h:
                  cryptometaData['percent_change_1h'].toStringAsFixed(2),
              percent_change_24h:
                  cryptometaData['percent_change_24h'].toStringAsFixed(2),
              percent_change_7d:
                  cryptometaData['percent_change_7d'].toStringAsFixed(2),
              percent_change_30d:
                  cryptometaData['percent_change_30d'].toStringAsFixed(2));
          cryptoObjects[c] = crypto;
        }
        print('ready to launch');
        return cryptoObjects;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  getHistoricalDataForCryptos(List cryptos) async {
    late Uri url;
    url = Uri.https(
        "pro-api.coinmarketcap.com", "/v2/cryptocurrency/quotes/latest", {
      "symbol": cryptos.join(','),
    });
  }
}
