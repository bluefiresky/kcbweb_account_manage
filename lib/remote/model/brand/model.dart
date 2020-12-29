class Brand {
  /// fsmid
  final BigInt fsmid;
  /// 品牌编码
  final String code;
  /// 品牌名称
  final String name;
  /// 品牌描述
  final String description;
  /// 品牌Logo
  final String logo;
  const Brand(this.fsmid, this.code, this.name, this.description, this.logo);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'code': code,
      'name': name,
      'description': description,
      'logo': logo,
    };
  }
}
