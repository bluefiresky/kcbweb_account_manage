import '../purchase-order/model.dart';
import '../supplier/model.dart';
import '../stock-keeping-unit/model.dart';

class SupplyOrderItem {
  /// SKU
  final BigInt sku;
  /// SKU对象
  final StockKeepingUnit skuRef;
  /// 商品编码
  final String code;
  /// 商品名称
  final String name;
  /// features
  final Map<String, String> features;
  /// 数量
  final int quantity;
  /// 单价
  final int price;
  const SupplyOrderItem(this.sku, this.skuRef, this.code, this.name, this.features, this.quantity, this.price);
  Map<String, dynamic> toJson() {
    return {
      'sku': sku.toString(),
      'code': code,
      'name': name,
      'features': features,
      'quantity': quantity,
      'price': price,
    };
  }
}

class SupplyOrder {
  /// fsmid
  final BigInt fsmid;
  /// 供应单号
  final String no;
  /// 供应商
  final BigInt supplier;
  /// 供应商对象
  final Supplier supplierRef;
  /// 收货地址
  final String deliveryAddress;
  /// 供应订单项
  final List<SupplyOrderItem> items;
  /// 采购单列表
  final List<BigInt> purchaseOrders;
  /// 采购单列表对象
  final List<PurchaseOrder> purchaseOrdersRefs;
  /// 货运公司
  final String deliveryCompany;
  /// 货运单号
  final String deliverySerialNumber;
  /// 取消原因
  final String reason;
  const SupplyOrder(this.fsmid, this.no, this.supplier, this.supplierRef, this.deliveryAddress, this.items, this.purchaseOrders, this.purchaseOrdersRefs, this.deliveryCompany, this.deliverySerialNumber, this.reason);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'no': no,
      'supplier': supplier.toString(),
      'delivery-address': deliveryAddress,
      'items': items.map((i) => i.toJson()).toList(),
      'purchase-orders': purchaseOrders.map((i) => i.toString()).toList(),
      'delivery-company': deliveryCompany,
      'delivery-serial-number': deliverySerialNumber,
      'reason': reason,
    };
  }
}
