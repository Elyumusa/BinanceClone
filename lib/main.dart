import 'package:binance_clone/screens/home_page/homePage.dart';
import 'package:binance_clone/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Logic/bloc/filter_chart_bloc.dart';
import 'Logic/cubits/theme_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FilterChartBloc(),
        ),
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit())
      ],
      child: BinanceCloneApp(),
    );
  }
}

class BinanceCloneApp extends StatefulWidget {
  const BinanceCloneApp({
    Key? key,
  }) : super(key: key);

  @override
  State<BinanceCloneApp> createState() => _BinanceCloneAppState();
}

class _BinanceCloneAppState extends State<BinanceCloneApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    context.read<ThemeCubit>().updateAppTheme();
    super.didChangePlatformBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: context.select((ThemeCubit cubit) => cubit.state.themeMode),
      home: const HomePage(),
    );
  }
}
