
class Pagination {
  int total = 0;
  int current = 1;
  int pageSize = 20;

  Pagination({this.total, this.current, this.pageSize});

  toMap(){
    return { 'total':this.total, 'current':this.current, 'pageSize':this.pageSize };
  }
}