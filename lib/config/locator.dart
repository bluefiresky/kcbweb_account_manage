

import 'package:get_it/get_it.dart';
import 'package:kcbweb_account_manage/config/custom_navigation.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => CustomNavigation());
}