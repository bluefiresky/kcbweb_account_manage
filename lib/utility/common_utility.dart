
import 'dart:async';

class CommonUtility {

  static Timer timeout(int milliseconds, Function f){
    return Timer(Duration(milliseconds:milliseconds), f);
  }

  static Timer interval(int milliseconds, Function f){
    return Timer.periodic(Duration(microseconds: milliseconds), (timer) { f(timer); });
  }

}