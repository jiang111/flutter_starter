.PHONY: apk ipa open_web open_apk open_ipa
open_apk:
	open ./build/app/outputs/flutter-apk/
open_ipa:
	open ./build/ios/ipa/
open_web:
	open ./build/web/
apk:
	flutter build apk --release
	$(MAKE) open_apk
ipa:
	flutter build ipa --release
	$(MAKE) open_ipa

