
class RemoteData <T> {
  int statusCode;
  String message;
  T data;

  RemoteData(this.statusCode, this.message, this.data);
}