.PHONY: apk_dev apk_dev2 apk ipa_dev ipa_dev2 ipa open_web open_apk open_ipa
open_apk:
	open ./build/app/outputs/flutter-apk/
open_ipa:
	open ./build/ios/ipa/
open_web:
	open ./build/web/
# make apk_dev 打 dev 的 apk 包
apk_dev:
	flutter build apk --release --target=./lib/main_dev.dart
	$(MAKE) open_apk
apk_dev2:
	flutter build apk --release --target=./lib/main_dev2.dart
	$(MAKE) open_apk
apk:
	flutter build apk --release
	$(MAKE) open_apk

# make ipa_dev 打 dev 的 ipa 包
ipa_dev:
	flutter build ipa --release --target=./lib/main_dev.dart
	$(MAKE) open_ipa
ipa_dev2:
	flutter build ipa --release --target=./lib/main_dev2.dart
	$(MAKE) open_ipa
ipa:
	flutter build ipa --release
	$(MAKE) open_ipa

