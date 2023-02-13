/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../Logic/api.dart';
import 'chart.dart';

class Analyzestock extends StatefulWidget {
  const Analyzestock({Key? key}) : super(key: key);

  @override
  State<Analyzestock> createState() => _AnalyzestockState();
}

class _AnalyzestockState extends State<Analyzestock> {
  List filters = ['1H', '1D', '1W', '1M', '1Y'];
  ScrollController _controller = ScrollController();
  bool bottomsheet = false;
  @override
  void initState() {
    // TODO: implement initState
    test();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.position.pixels) {
        print('object');
        if (bottomsheet == false) {
          showBottomSheet(
              context: context,
              builder: (context) {
                return Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(15),
                      child: Text("Sell"),
                      padding:
                          EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.green,
                      ),
                    ),
                    Spacer(),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: Text("Buy"),
                      padding:
                          EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.green,
                      ),
                    )
                  ],
                );
              });
          bottomsheet = true;
        }
      } else {
        if (bottomsheet == true) {
          print('At edge');
          bottomsheet = false;
          Navigator.pop(context);
          /*setState(() {
            print("at edge");
            bottomsheet = false;
          });*/
        }
      }
    });

    super.didChangeDependencies();
  }

  int currentFilterIndex = 0;

  test() async {
    final stock = await API().get_stockBars('TSLA', '15H');
    print('done stock is here: ${stock.symbol}');
  }

  Future getstock = API().get_stockBars('TSLA', '1H');
  @override
  Widget build(BuildContext context) {
    /*getstock =
        API().get_stockBars('TSLA', context.watch<FilterChartBloc>().state);*/
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 240, 242),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 234, 240, 242),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.star,
                color: Colors.grey[700],
              ))
        ],
        leading: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: SingleChildScrollView(
          controller: _controller,
          child: BlocConsumer<FilterChartBloc, String>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return FutureBuilder(
                  future: API().get_stockBars(
                      'TSLA', context.watch<FilterChartBloc>().state),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final result = snapshot.data as Map;
                      Stock stock = result['stock'];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              stock.symbol!, //"TSLA",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                                "\$${result['latest_stock'].stock_bars![0].current_price}",
                                style: Theme.of(context).textTheme.headline3),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            //height: double.maxFinite,
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 300,
                                  child: China(
                                    stock: stock,
                                    stock_bars: stock.stock_bars!,
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: List.generate(filters.length,
                                          (index) {
                                        return GestureDetector(
                                          onTap: (() {
                                            if (currentFilterIndex != index) {
                                              print("clicked");
                                              context
                                                  .read<FilterChartBloc>()
                                                  .add(FilterBy(
                                                      filter: filters[index]));
                                              setState(() {
                                                currentFilterIndex = index;
                                              });
                                            }
                                          }),
                                          child: Container(
                                            //margin: EdgeInsets.all(10),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            child: Text(
                                              filters[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ),
                                            decoration: BoxDecoration(
                                                color:
                                                    currentFilterIndex == index
                                                        ? Colors.blueGrey[100]
                                                        : null, //: null,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          ),
                                        );
                                      })),
                                ),
                                Statistics(),
                                Portfolio(context),
                                SizedBox(
                                  height: 50,
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  });
            },
          ),
        ),
      )),
    );
  }

  Padding Portfolio(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Icon(
            Icons.wallet,
            color: Colors.blueGrey[100],
          ),
          SizedBox(
            width: 10,
          ),
          Text("Your Portfolio:",
              style:
                  Theme.of(context).textTheme.caption!.copyWith(fontSize: 15)),
          Spacer(),
          Text("\$100,000",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 20))
        ],
      ),
    );
  }
}

class Statistics extends StatelessWidget {
  const Statistics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text("Statistics",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 20)),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  "Open",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 15),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  '780',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 20),
                ),
                Spacer(),
                Text(
                  "Day Low",
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 15),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  '775.01',
                  style: Theme.of(context).textTheme.titleMedium,
                )
              ],
            )),
        Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  "Day High",
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 15),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  '780',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 20),
                ),
                Spacer(),
                Text(
                  "Volume",
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 15),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  '775.01',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 20),
                )
              ],
            )),
      ],
    );
  }
}*/
