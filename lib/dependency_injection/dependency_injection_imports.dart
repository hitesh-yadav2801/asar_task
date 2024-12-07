
import 'package:asar/core/common/functions/secure_storage_service.dart';
import 'package:asar/core/network/connection_checker.dart';
import 'package:asar/features/auth/data/data_sources/auth_data_source.dart';
import 'package:asar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:asar/features/auth/domain/repositories/auth_repository.dart';
import 'package:asar/features/auth/domain/use_cases/send_otp_use_case.dart';
import 'package:asar/features/auth/domain/use_cases/verify_otp_use_case.dart';
import 'package:asar/features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import 'package:asar/features/auth/presentation/manager/session_cubit/session_cubit.dart';
import 'package:asar/features/events/data/data_sources/event_data_source.dart';
import 'package:asar/features/events/data/repositories/event_repository_impl.dart';
import 'package:asar/features/events/domain/repositories/event_repository.dart';
import 'package:asar/features/events/domain/use_cases/create_order_use_case.dart';
import 'package:asar/features/events/domain/use_cases/fetch_events_use_case.dart';
import 'package:asar/features/events/domain/use_cases/get_order_book.dart';
import 'package:asar/features/events/presentation/manager/create_order_bloc/create_order_bloc.dart';
import 'package:asar/features/events/presentation/manager/get_events_bloc/get_events_bloc.dart';
import 'package:asar/features/events/presentation/manager/order_book_bloc/order_book_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

part 'dependency_injection.dart';
