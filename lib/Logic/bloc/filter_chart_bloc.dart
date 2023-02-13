import 'package:flutter_bloc/flutter_bloc.dart';

class FilterChartBloc extends Bloc<FilterBy, String> {
  FilterChartBloc() : super('1H') {
    on<FilterBy>((event, emit) => emit(event.filter));
  }
}

class FilterBy {
  // double price;
  String filter;
  FilterBy({required this.filter});
}
