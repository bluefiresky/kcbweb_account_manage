import '../stock-keeping-unit/model.dart';
import '../supplier/model.dart';

class Inventory {
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
  /// 库存数量
  final int quantity;
  /// 库存单位
  final String unit;
  const Inventory(this.fsmid, this.supplier, this.supplierRef, this.sku, this.skuRef, this.quantity, this.unit);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'supplier': supplier.toString(),
      'sku': sku.toString(),
      'quantity': quantity,
      'unit': unit,
    };
  }
}
