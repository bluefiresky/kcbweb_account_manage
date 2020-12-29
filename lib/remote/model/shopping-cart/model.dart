import '../stock-keeping-unit/model.dart';

class ShoppingCartItem {
  /// SKU
  final BigInt sku;
  /// SKU对象
  final StockKeepingUnit skuRef;
  /// 单位
  final String unit;
  /// 数量
  final int quantity;
  /// 单价
  final int price;
  const ShoppingCartItem(this.sku, this.skuRef, this.unit, this.quantity, this.price);
  Map<String, dynamic> toJson() {
    return {
      'sku': sku.toString(),
      'unit': unit,
      'quantity': quantity,
      'price': price,
    };
  }
}

class ShoppingCart {
  /// fsmid
  final BigInt fsmid;
  /// 购物项
  final List<ShoppingCartItem> items;
  const ShoppingCart(this.fsmid, this.items);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}
