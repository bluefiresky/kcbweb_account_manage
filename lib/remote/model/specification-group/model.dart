class SpecificationGroup {
  /// fsmid
  final BigInt fsmid;
  /// 规格分组编码
  final String code;
  /// 分组名称
  final String name;
  /// 分组描述
  final String description;
  const SpecificationGroup(this.fsmid, this.code, this.name, this.description);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'code': code,
      'name': name,
      'description': description,
    };
  }
}
