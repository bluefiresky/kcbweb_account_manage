
import 'package:kcbweb_account_manage/route/routing_data.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';

extension StringExtensions on String {
  RoutingData get getRoutingData {
    var uriData = Uri.parse(this);
    return RoutingData(route: uriData.path, queryParameters: uriData.queryParameters);
  }
}
