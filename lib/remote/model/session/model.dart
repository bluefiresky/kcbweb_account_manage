class MySession {
  /// fsmid
  final BigInt fsmid;
  /// Access Token
  final String accessToken;
  /// Refresh Token
  final String refreshToken;
  /// 失败次数
  final int failedTimes;
  const MySession(this.fsmid, this.accessToken, this.refreshToken, this.failedTimes);
  Map<String, dynamic> toJson() {
    return {
      'fsmid': fsmid.toString(),
      'access-token': accessToken,
      'refresh-token': refreshToken,
      'failed-times': failedTimes,
    };
  }
}
