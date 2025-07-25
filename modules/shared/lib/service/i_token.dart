abstract class IToken {
  String? get token;
  Future<String?> getToken();
  Future<void> setToken(String token);
  Future<void> clearToken();
}
