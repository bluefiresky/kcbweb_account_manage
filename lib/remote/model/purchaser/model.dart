class Purchaser {
  /// fsmid
  final BigInt fsmid;
  /// 采购商编码
  final String code;
  /// 采购商名称
  final String name;
  /// 采购商帐号
  final String account;
  /// 采购商描述
  final String description;
  const Purchaser(this.fsmid, this.code, this.name, this.account, this.description);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'code': code,
      'name': name,
      'account': account,
      'description': description,
    };
  }
}
