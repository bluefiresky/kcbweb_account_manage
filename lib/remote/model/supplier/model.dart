class Supplier {
  /// fsmid
  final BigInt fsmid;
  /// 供应商编码
  final String code;
  /// 供应商名称
  final String name;
  /// 供应商帐号
  final String account;
  /// 供应商描述
  final String description;
  const Supplier(this.fsmid, this.code, this.name, this.account, this.description);
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
