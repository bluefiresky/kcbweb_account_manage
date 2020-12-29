class Qualification {
  /// fsmid
  final BigInt fsmid;
  /// 资质名称
  final String name;
  const Qualification(this.fsmid, this.name);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'name': name,
    };
  }
}
