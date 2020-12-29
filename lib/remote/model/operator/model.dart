import '../role/model.dart';

class MyOperator {
  /// fsmid
  final BigInt fsmid;
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
  const MyOperator(this.fsmid, this.account, this.password, this.salt, this.name, this.remark, this.role, this.roleRef, this.secret);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'account': account,
      'password': password,
      'salt': salt.toString(),
      'name': name,
      'remark': remark,
      'role': role.toString(),
      'secret': secret,
    };
  }
}
