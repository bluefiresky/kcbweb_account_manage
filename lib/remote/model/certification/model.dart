import '../operator/model.dart';
import '../stock-keeping-unit/model.dart';
import '../supplier/model.dart';

class Certification {
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
  /// 资质
  final Map<String, String> qualifications;
  /// 审核员
  final BigInt auditor;
  /// 审核员对象
  final MyOperator auditorRef;
  /// 拒绝原因
  final String reason;
  const Certification(this.fsmid, this.supplier, this.supplierRef, this.sku, this.skuRef, this.qualifications, this.auditor, this.auditorRef, this.reason);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'supplier': supplier.toString(),
      'sku': sku.toString(),
      'qualifications': qualifications,
      'auditor': auditor.toString(),
      'reason': reason,
    };
  }
}
