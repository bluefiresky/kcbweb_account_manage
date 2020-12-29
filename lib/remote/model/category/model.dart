import '../qualification/model.dart';

class Category {
  /// fsmid
  final BigInt fsmid;
  /// 父类别ID
  final BigInt parent;
  /// 商品类别编码
  final String code;
  /// 商品类别名称
  final String name;
  /// 商品类别描述
  final String description;
  /// 商品资质
  final List<BigInt> qualifications;
  /// 商品资质对象
  final List<Qualification> qualificationsRefs;
  const Category(this.fsmid, this.parent, this.code, this.name, this.description, this.qualifications, this.qualificationsRefs);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'parent': parent.toString(),
      'code': code,
      'name': name,
      'description': description,
      'qualifications': qualifications.map((i) => i.toString()).toList(),
    };
  }
}
