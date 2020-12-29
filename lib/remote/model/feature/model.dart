import '../category/model.dart';

class Feature {
  /// fsmid
  final BigInt fsmid;
  /// 商品类别
  final BigInt category;
  /// 商品类别对象
  final Category categoryRef;
  /// 特征编码
  final String code;
  /// 特征名称
  final String name;
  /// 特征值
  final List<String> values;
  const Feature(this.fsmid, this.category, this.categoryRef, this.code, this.name, this.values);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'category': category.toString(),
      'code': code,
      'name': name,
      'values': values,
    };
  }
}
