import '../stock-keeping-unit/model.dart';
import '../supplier/model.dart';

class SupplierPriceRange {
  /// 起始数量
  final int start;
  /// 终止数量
  final int stop;
  /// 价格
  final int price;
  const SupplierPriceRange(this.start, this.stop, this.price);
  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'stop': stop,
      'price': price,
    };
  }
}

class SupplierPrice {
  /// fsmid
  final BigInt fsmid;
  /// 供应商
  final BigInt supplier;
  /// 供应商对象
  final Supplier supplierRef;
  /// SKU
  final BigInt sku;
  /// SKU对象
  final StockKeepingUnit skuRef;
  /// 数量单位
  final String unit;
  /// 价格区间
  final List<SupplierPriceRange> prices;
  const SupplierPrice(this.fsmid, this.supplier, this.supplierRef, this.sku, this.skuRef, this.unit, this.prices);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'supplier': supplier.toString(),
      'sku': sku.toString(),
      'unit': unit,
      'prices': prices.map((i) => i.toJson()).toList(),
    };
  }
}
