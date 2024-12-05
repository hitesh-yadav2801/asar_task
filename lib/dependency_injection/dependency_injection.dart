part of 'dependency_injection_imports.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initEventModule();
}

void _initEventModule() {
  serviceLocator.registerFactory<EventDataSource>(
    () => EventDataSourceImpl(),
  );
}


