part of 'dependency_injection_imports.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  /// Initialize FlutterSecureStorage
  serviceLocator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  /// Register SecureStorageService
  serviceLocator.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(storage: serviceLocator<FlutterSecureStorage>()),
  );
  _initAuthModule();
  _initEventModule();
}

void _initAuthModule() {
  /// Auth Data Source
  serviceLocator
    ..registerFactory<AuthDataSource>(
      () => AuthDataSourceImpl(),
    )

    /// Auth Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )

    /// Auth Use Cases
    ..registerFactory<SendOtpUseCase>(
      () => SendOtpUseCase(
        serviceLocator(),
      ),
    )
    ..registerFactory<VerifyOtpUseCase>(
      () => VerifyOtpUseCase(
        serviceLocator(),
      ),
    )

    /// Auth Bloc
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        sendOtpUseCase: serviceLocator(),
        verifyOtpUseCase: serviceLocator(),
      ),
    )
    ..registerLazySingleton<SessionCubit>(
      () => SessionCubit(
        secureStorage: serviceLocator(),
      ),
    );
}

void _initEventModule() {
  serviceLocator

    /// Event Data Source
    ..registerFactory<EventDataSource>(
      () => EventDataSourceImpl(),
    )

    /// Event Repository
    ..registerFactory<EventRepository>(
      () => EventRepositoryImpl(
        eventDataSource: serviceLocator(),
      ),
    )

    /// Event Use Cases
    ..registerFactory<FetchEventsUseCase>(
      () => FetchEventsUseCase(
        eventRepository: serviceLocator(),
      ),
    )
    ..registerFactory<CreateOrderUseCase>(
      () => CreateOrderUseCase(
        serviceLocator(),
      ),
    )

    /// Event Bloc
    ..registerFactory<GetEventsBloc>(
      () => GetEventsBloc(
        fetchEventsUseCase: serviceLocator(),
      ),
    )
    ..registerFactory<CreateOrderBloc>(
      () => CreateOrderBloc(
        createOrderUseCase: serviceLocator(),
      ),
    );
}
