
import 'package:kcbweb_account_manage/data_models/remote/pagination.dart';

class RemoteData <T> {
  int statusCode;
  String message;
  T data;
  Pagination1 pagination;

  RemoteData(this.statusCode, this.message, this.data, { this.pagination });
}