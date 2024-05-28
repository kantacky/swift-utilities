CONFIG = debug
PLATFORM_IOS = iOS Simulator,id=$(call udid_for,iOS 17.5,iPhone \d\+ Pro [^M])
PLATFORM_MACOS = macOS
PLATFORM_TVOS = tvOS Simulator,id=$(call udid_for,tvOS 17.5,TV)
PLATFORM_VISIONOS = visionOS Simulator,id=$(call udid_for,visionOS 1.2,Vision)
PLATFORM_WATCHOS = watchOS Simulator,id=$(call udid_for,watchOS 10.5,Watch)

default: test-all

test-all:
	$(MAKE) CONFIG=debug test-library
	$(MAKE) CONFIG=release test-library

build-all-platforms:
	for platform in "iOS" "macOS" "macOS,variant=Mac Catalyst" "tvOS" "visionOS" "watchOS"; do \
		xcodebuild \
			-skipMacroValidation \
			-configuration $(CONFIG) \
			-workspace .github/package.xcworkspace \
			-scheme SwiftUtilities \
			-destination generic/platform="$$platform" || exit 1; \
	done;

test-library:
	for platform in "$(PLATFORM_IOS)" "$(PLATFORM_MACOS)"; do \
		xcodebuild test \
			-skipMacroValidation \
			-configuration $(CONFIG) \
			-workspace .github/package.xcworkspace \
			-scheme SwiftUtilities \
			-destination platform="$$platform" || exit 1; \
	done;

.PHONY: test-all

define udid_for
$(shell xcrun simctl list devices available '$(1)' | grep '$(2)' | sort -r | head -1 | awk -F '[()]' '{ print $$(NF-3) }')
endef
