import '../specification-group/model.dart';

class Specification {
  /// fsmid
  final BigInt fsmid;
  /// 规格分组
  final BigInt specificationGroup;
  /// 规格分组对象
  final SpecificationGroup specificationGroupRef;
  /// 规格编码
  final String code;
  /// 规格名称
  final String name;
  /// 规格描述
  final String description;
  const Specification(this.fsmid, this.specificationGroup, this.specificationGroupRef, this.code, this.name, this.description);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'specification-group': specificationGroup.toString(),
      'code': code,
      'name': name,
      'description': description,
    };
  }
}
