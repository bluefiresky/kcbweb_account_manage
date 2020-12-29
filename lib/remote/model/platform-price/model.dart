import '../stock-keeping-unit/model.dart';

class PlatformPriceRange {
  /// 起始数量
  final int start;
  /// 终止数量
  final int stop;
  /// 价格
  final int price;
  const PlatformPriceRange(this.start, this.stop, this.price);
  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'stop': stop,
      'price': price,
    };
  }
}

class PlatformPrice {
  /// fsmid
  final BigInt fsmid;
  /// sku
  final BigInt sku;
  /// sku对象
  final StockKeepingUnit skuRef;
  /// 数量单位
  final String unit;
  /// 价格区间
  final List<PlatformPriceRange> prices;
  const PlatformPrice(this.fsmid, this.sku, this.skuRef, this.unit, this.prices);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'sku': sku.toString(),
      'unit': unit,
      'prices': prices.map((i) => i.toJson()).toList(),
    };
  }
}
