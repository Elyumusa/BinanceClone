import 'dart:async';

import 'package:binance_clone/Model/crypto_model.dart';
import 'package:chart_sparkline/chart_sparkline.dart';

import 'package:flutter/material.dart';

import '../../Logic/api.dart';

class China extends StatefulWidget {
  final CryptoModel crypto;
  Function? onTimer;
  China({Key? key, required this.crypto}) : super(key: key);

  @override
  State<China> createState() => _ChinaState();
}

class _ChinaState extends State<China> {
  List bars = [];
  //late Timer _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
   // _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    /* _timer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) {
        print('chart updated');
      },
    );*/
  }

  //Future getlateststock = API().getLateststockBar('TSLA');
  @override
  Widget build(BuildContext context) {
    bars = [widget.crypto]; //?? [];
    return /*bars.isEmpty
        ? FutureBuilder(
            future: API().get_stockBars('TSLA', '1H'),
            builder: (context, snapshot) {
              print('in the right place');
              if (snapshot.hasData) {
                print('object data');
                final result = snapshot.data as Map;
                final stock = result['stock'];
                print(': {$stock.stock_bars}');
                bars.addAll(stock.stock_bars!);
                bars.removeAt(0);
                print('In the part for updating the chart');
                return Container(
                  //width: 600.0,
                  //height: 250.0,
                  child: Sparkline(
                    data: List.generate(bars.length, (index) {
                      return double.parse(bars[index].high.toString());
                    }), //[150, 148.95, 150, 143, 145, 153, 146.3],
                    averageLine: false,
                    averageLabel: true,
                    // kLine: ['max', 'min'],
                  ),
                );
              } else {
                return Container(
                    //width: 600.0,
                    //height: 250.0,

                    );
              }
            })
        : */
        FutureBuilder(
            future: API().getMultipleCryptosLatetData([widget.crypto.symbol]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final cryptoMap = snapshot.data! as Map;
                bars.add(cryptoMap[widget.crypto.symbol]);
                //bars.removeAt(0);
                print('In the part for updating the chart bars: $bars');
                return Container(
                  //width: 600.0,
                  //height: 250.0,
                  child: Sparkline(
                    lineColor: '${bars[bars.length - 1].percent_change_24h}%'
                            .contains('-')
                        ? Colors.red
                        : Colors.green,
                    data: List.generate(bars.length, (index) {
                      return double.parse(bars[index].price.toString());
                    }), //[150, 148.95, 150, 143, 145, 153, 146.3],
                    averageLine: false,
                    averageLabel: true,
                    // kLine: ['max', 'min'],
                  ),
                );
              } else {
                return Container(
                  //width: 600.0,
                  //height: 250.0,
                  child: Sparkline(
                    lineColor: '${bars[bars.length - 1].percent_change_24h}%'
                            .contains('-')
                        ? Colors.red
                        : Colors.green,
                    data: List.generate(bars.length, (index) {
                      return double.parse(bars[index].price.toString());
                    }), //[150, 148.95, 150, 143, 145, 153, 146.3],
                    averageLine: false,
                    averageLabel: true,
                    // kLine: ['max', 'min'],
                  ),
                );
              }
            });
  }
}
