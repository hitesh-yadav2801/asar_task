import 'dart:async';

import 'package:asar/features/events/domain/entities/order_entity.dart';
import 'package:asar/features/events/domain/use_cases/create_order_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_order_event.dart';

part 'create_order_state.dart';

class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  final CreateOrderUseCase _createOrderUseCase;

  CreateOrderBloc({
    required CreateOrderUseCase createOrderUseCase,
  })  : _createOrderUseCase = createOrderUseCase,
        super(CreateOrderInitial()) {
    on<CreateOrderEvent>((event, emit) {
      emit(OrderPlacingState());
    });
    on<CreateOrderEventStarted>(_onCreateOrderEventStarted);
  }

  void _onCreateOrderEventStarted(CreateOrderEventStarted event, Emitter<CreateOrderState> emit) async {
    final result = await _createOrderUseCase.call(
      CreateOrderParams(
        authToken: event.authToken,
        eventId: event.eventId,
        type: event.type,
        quantity: event.quantity,
        price: event.price,
      ),
    );

    result.fold(
      (failure) => emit(OrderPlacedErrorState(message: failure.message)),
      (orderEntity) => emit(OrderPlacedSuccessState(order: orderEntity)),
    );
  }
}
