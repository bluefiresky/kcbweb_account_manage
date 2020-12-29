import '../feature/model.dart';
import '../category/model.dart';
import '../brand/model.dart';

class StandardProductUnit {
  /// fsmid
  final BigInt fsmid;
  /// 编码
  final String code;
  /// 名称
  final String name;
  /// 品牌
  final BigInt brand;
  /// 品牌对象
  final Brand brandRef;
  /// 商品类别
  final BigInt category;
  /// 商品类别对象
  final Category categoryRef;
  /// 特性列表
  final List<BigInt> features;
  /// 特性列表对象
  final List<Feature> featuresRefs;
  /// 规格分组
  final Map<String, Map<String, String>> specificationGroups;
  const StandardProductUnit(this.fsmid, this.code, this.name, this.brand, this.brandRef, this.category, this.categoryRef, this.features, this.featuresRefs, this.specificationGroups);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'code': code,
      'name': name,
      'brand': brand.toString(),
      'category': category.toString(),
      'features': features.map((i) => i.toString()).toList(),
      'specification-groups': specificationGroups,
    };
  }
}
