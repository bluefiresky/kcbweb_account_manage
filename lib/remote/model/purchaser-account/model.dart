import '../role/model.dart';
import '../purchaser/model.dart';

class PurchaserAccount {
  /// fsmid
  final BigInt fsmid;
  /// 采购商
  final BigInt purchaser;
  /// 采购商对象
  final Purchaser purchaserRef;
  /// 账号
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
  const PurchaserAccount(this.fsmid, this.purchaser, this.purchaserRef, this.account, this.password, this.salt, this.name, this.remark, this.role, this.roleRef, this.secret, this.initialPasswordUpdated);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'purchaser': purchaser.toString(),
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
