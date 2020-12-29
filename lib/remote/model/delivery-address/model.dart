import '../purchaser/model.dart';

class DeliveryAddress {
  /// fsmid
  final BigInt fsmid;
  /// 采购商
  final BigInt purchaser;
  /// 采购商对象
  final Purchaser purchaserRef;
  /// 详细地址
  final String address;
  const DeliveryAddress(this.fsmid, this.purchaser, this.purchaserRef, this.address);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'purchaser': purchaser.toString(),
      'address': address,
    };
  }
}
