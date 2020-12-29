import '../purchaser/model.dart';
import '../stock-keeping-unit/model.dart';

class PurchaseOrderItem {
  /// SKU
  final BigInt sku;
  /// SKU对象
  final StockKeepingUnit skuRef;
  /// SKU编码
  final String code;
  /// 商品名称
  final String name;
  /// 特征
  final Map<String, String> features;
  /// 购买数量
  final int quantity;
  /// 购买单价
  final int price;
  const PurchaseOrderItem(this.sku, this.skuRef, this.code, this.name, this.features, this.quantity, this.price);
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

class PurchaseOrder {
  /// fsmid
  final BigInt fsmid;
  /// 采购单号
  final String no;
  /// 采购商
  final BigInt purchaser;
  /// 采购商对象
  final Purchaser purchaserRef;
  /// 采购订单项
  final List<PurchaseOrderItem> items;
  /// 收货地址
  final String deliveryAddress;
  /// 支付单号
  final BigInt payment;
  /// 支付序列号
  final String paymentSerialNumber;
  /// 货运公司
  final String deliveryCompany;
  /// 货运单号
  final String deliverySerialNumber;
  /// 取消原因
  final String reason;
  const PurchaseOrder(this.fsmid, this.no, this.purchaser, this.purchaserRef, this.items, this.deliveryAddress, this.payment, this.paymentSerialNumber, this.deliveryCompany, this.deliverySerialNumber, this.reason);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'no': no,
      'purchaser': purchaser.toString(),
      'items': items.map((i) => i.toJson()).toList(),
      'delivery-address': deliveryAddress,
      'payment': payment.toString(),
      'payment-serial-number': paymentSerialNumber,
      'delivery-company': deliveryCompany,
      'delivery-serial-number': deliverySerialNumber,
      'reason': reason,
    };
  }
}
