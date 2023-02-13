class CryptoModel {
  final String symbol;
  final String price;
  final String percent_change_1h;
  final String percent_change_24h;
  final String percent_change_7d;
  final String percent_change_30d;
  CryptoModel(
      {required this.symbol,
      required this.price,
      required this.percent_change_1h,
      required this.percent_change_24h,
      required this.percent_change_7d,
      required this.percent_change_30d});
}
