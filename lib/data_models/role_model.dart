


class RoleModel {
  String id;
  String roleName;
  String roleDesc;

  RoleModel();

  RoleModel.from(this.id, this.roleName, this.roleDesc);

  RoleModel.fromData(Map data){
    if(data?.isNotEmpty ?? false) {
      this.id = data['id'] ?? '';
      this.roleName = data['roleName'] ?? '';
      this.roleDesc = data['roleDesc'] ?? '';
    }
  }

  @override
  String toString() {
    return " ## id: $id -- roleName: $roleName -- roleDesc: $roleDesc";
  }
}