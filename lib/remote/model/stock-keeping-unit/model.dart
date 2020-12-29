import '../standard-product-unit/model.dart';

class StockKeepingUnit {
  /// fsmid
  final BigInt fsmid;
  /// 编码
  final String code;
  /// 名称
  final String name;
  /// SPU
  final BigInt standardProductUnit;
  /// SPU对象
  final StandardProductUnit standardProductUnitRef;
  /// 特性内容
  final Map<String, String> features;
  /// 主图
  final List<String> mainMediaResources;
  /// 详情图
  final List<String> detailMediaResources;
  const StockKeepingUnit(this.fsmid, this.code, this.name, this.standardProductUnit, this.standardProductUnitRef, this.features, this.mainMediaResources, this.detailMediaResources);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'code': code,
      'name': name,
      'standard-product-unit': standardProductUnit.toString(),
      'features': features,
      'main-media-resources': mainMediaResources,
      'detail-media-resources': detailMediaResources,
    };
  }
}
