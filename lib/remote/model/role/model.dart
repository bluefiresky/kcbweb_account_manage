class Role {
  /// fsmid
  final BigInt fsmid;
  /// 角色名称
  final String name;
  /// 角色描述
  final String description;
  /// 适用范围
  final BigInt scope;
  /// 适用类型
  final String scopeType;
  const Role(this.fsmid, this.name, this.description, this.scope, this.scopeType);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'name': name,
      'description': description,
      'scope': scope.toString(),
      'scope-type': scopeType,
    };
  }
}
