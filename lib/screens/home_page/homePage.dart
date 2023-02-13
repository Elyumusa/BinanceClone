import 'dart:async';

import 'package:binance_clone/Logic/api.dart';
import 'package:binance_clone/Logic/bloc/filter_chart_bloc.dart';
import 'package:binance_clone/Logic/cubits/theme_cubit.dart';
import 'package:binance_clone/Model/crypto_model.dart';
import 'package:binance_clone/screens/home_page/Widgets/refresh_widget.dart';
import 'package:binance_clone/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../stockPage/chart.dart';
import 'Widgets/tabbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) {
        context.read<FilterChartBloc>().add(FilterBy(filter: '1H'));
        print('chart updated');
      },
    );
  }

  late Map mapofCryptos = {};
  Future getMultiple() async {
    final result =
        await API().getMultipleCryptosLatetData(API().homePageCryptos);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Icon(
          Icons.account_circle,
          color: AppTheme.lightPrimaryColor,
          size: 30,
        ),
        actions: [
          Icon(
            Icons.search,
            color: Colors.grey,
          ),
          SizedBox(width: 13),
          IconButton(
              onPressed: () async {
                print(
                    "I'm pressing ${context.read<ThemeCubit>().state.themeMode.name}");
                context.read<ThemeCubit>().updateAppTheme();
                try {} catch (e) {
                  print(e);
                  throw 'Failed to set brightness';
                }
              },
              icon: Icon(Icons.dark_mode_outlined, color: Colors.grey)),
          SizedBox(width: 13),
          Icon(Icons.qr_code_scanner, color: Colors.grey),
          SizedBox(width: 6)
        ],
      ),
      body: RefreshWidget(
        onRefresh: () async {
          await getMultiple();
          setState(() {});
        },
        child: ListView(shrinkWrap: true, primary: false, children: [
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: BlocBuilder<FilterChartBloc, String>(
              builder: (context, state) {
                return FutureBuilder(
                    future: getMultiple(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        mapofCryptos = snapshot.data as Map;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: SizedBox(
                                child: Center(
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 60,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: Image.asset(
                                            'assets/images/p_Binance.jpg',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Get started with crypto",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .copyWith(
                                                fontWeight: FontWeight.w300),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GeneralButton(
                                            string: 'Deposit',
                                            // color: Colors.grey[700],
                                            onTap: () {},
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          GeneralButton(
                                            color: AppTheme.lightPrimaryColor,
                                            string: 'Buy Crypto',
                                            onTap: () {},
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 50,
                                        width: double.infinity,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            CategoryPicker(),
                            SizedBox(height: 20),
                            ...List.generate(API().homePageCryptos.length,
                                (index) {
                              return CryptoTile(
                                  crypto: mapofCryptos[
                                      API().homePageCryptos[index]]);
                            }),
                          ],
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    });
              },
            ),
          )),
        ]),
      ),
    );
  }

  onTImer() {
    setState(() {
      print("every minute");
    });
  }
}

class CryptoTile extends StatelessWidget {
  final CryptoModel crypto;

  CryptoTile({
    Key? key,
    required this.crypto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      //color: Colors.red,
      width: double.infinity,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        /* Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Icon(Icons.account_circle),
                ),
                SizedBox(
                  width: 25,
                ),*/
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              crypto.symbol,
              style:
                  Theme.of(context).textTheme.headline6!.copyWith(fontSize: 14),
            ),
            Text(
              crypto.symbol,
              style: Theme.of(context).textTheme.caption,
            )
          ]),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${crypto.percent_change_24h}%',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: '${crypto.percent_change_24h}%'.contains('-')
                        ? Colors.red
                        : Colors.green),
              ),
              Text(
                "\$${crypto.price}",
                style: Theme.of(context).textTheme.caption!,
              )
            ],
          ),
        )
      ]),
    );
  }
}

class GeneralButton extends StatelessWidget {
  final String string;
  final void Function() onTap;
  Color? color;
  GeneralButton(
      {Key? key, required this.string, required this.onTap, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 160,
        child: InkResponse(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
                color: color == null
                    ? Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[700]
                        : AppTheme.defaultButtonColor
                    : color,
                borderRadius: BorderRadius.circular(30)),
            child: Center(
                child: color == null
                    ? Text(
                        string,
                      )
                    : Text(
                        string,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      )),
          ),
        ));
  }
}
