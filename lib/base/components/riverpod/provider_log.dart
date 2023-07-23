import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter/utils/extension_object.dart';

class ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
   '[${provider.name ?? provider.runtimeType}] expose: $newValue'.i();
  }
}
