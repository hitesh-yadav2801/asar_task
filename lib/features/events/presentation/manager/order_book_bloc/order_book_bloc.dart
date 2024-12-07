import 'package:asar/features/events/domain/entities/order_book.dart';
import 'package:asar/features/events/domain/use_cases/get_order_book.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'order_book_event.dart';

part 'order_book_state.dart';

class OrderBookBloc extends Bloc<OrderBookEvent, OrderBookState> {
  final GetOrderBookUseCase _getOrderBookUseCase;

  OrderBookBloc({
    required GetOrderBookUseCase getOrderBookUseCase,
  })  : _getOrderBookUseCase = getOrderBookUseCase,
        super(OrderBookInitial()) {
    on<OrderBookEvent>((event, emit) {
      emit(OrderBookLoading());
    });
    on<FetchOrderBookEvent>(_onFetchOrderBook);
  }

  void _onFetchOrderBook(FetchOrderBookEvent event, Emitter<OrderBookState> emit) async {
    final result = await _getOrderBookUseCase.call(event.eventId);

    result.fold(
      (failure) => emit(OrderBookError(message: failure.message)),
      (orderBook) => emit(OrderBookLoaded(orderBook: orderBook)),
    );
  }
}
