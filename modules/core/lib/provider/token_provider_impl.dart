import 'package:core/const/app_const.dart';
import 'package:core/utils/sp_utils.dart';
import 'package:shared/shared.dart';

class TokenProviderImpl implements IToken {
  @override
  Future<void> clearToken() {
    return SPUtils().setString(AppConst.API_TOKEN, '');
  }

  @override
  Future<String?> getToken() async {
    return SPUtils().getString(AppConst.API_TOKEN);
  }

  @override
  Future<void> setToken(String token) {
    return SPUtils().setString(AppConst.API_TOKEN, token);
  }

  @override
  String? get token => SPUtils().getString(AppConst.API_TOKEN);
}
