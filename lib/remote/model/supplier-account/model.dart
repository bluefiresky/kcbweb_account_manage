import '../role/model.dart';
import '../supplier/model.dart';

class SupplierAccount {
  /// fsmid
  final BigInt fsmid;
  /// 供应商
  final BigInt supplier;
  /// 供应商对象
  final Supplier supplierRef;
  /// 子账号
  final String account;
  /// 密码
  final String password;
  /// 加盐
  final BigInt salt;
  /// 姓名
  final String name;
  /// 备注
  final String remark;
  /// 角色
  final BigInt role;
  /// 角色对象
  final Role roleRef;
  /// 安全码
  final String secret;
  /// 初始密码是否已修改
  final bool initialPasswordUpdated;
  const SupplierAccount(this.fsmid, this.supplier, this.supplierRef, this.account, this.password, this.salt, this.name, this.remark, this.role, this.roleRef, this.secret, this.initialPasswordUpdated);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'supplier': supplier.toString(),
      'account': account,
      'password': password,
      'salt': salt.toString(),
      'name': name,
      'remark': remark,
      'role': role.toString(),
      'secret': secret,
      'initial-password-updated': initialPasswordUpdated,
    };
  }
}
