class FundAccount {
  /// fsmid
  final BigInt fsmid;
  /// D0可提现账户
  final int d0;
  /// 已冻结账户
  final int frozen;
  const FundAccount(this.fsmid, this.d0, this.frozen);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'd0': d0,
      'frozen': frozen,
    };
  }
}
