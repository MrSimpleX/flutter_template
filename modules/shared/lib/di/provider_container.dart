import 'package:shared/shared.dart';

class GlobalProviderContainer {
  static ProviderContainer? _instance;

  static ProviderContainer get instance {
    _instance ??= ProviderContainer();
    return _instance!;
  }

  static void initialize([ProviderContainer? container]) {
    _instance = container ?? ProviderContainer();
  }

  static void dispose() {
    _instance?.dispose();
    _instance = null;
  }

  static T read<T>(ProviderBase<T> provider) {
    return instance.read(provider);
  }

  static void overrideWith<T>(OverrideWithValueMixin<T> provider, T value) {
    if (_instance != null) {
      _instance!.dispose();
    }
    _instance = ProviderContainer(
      overrides: [provider.overrideWithValue(value)],
    );
  }
}
