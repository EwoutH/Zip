#!/bin/bash

# **** Update me when new Xcode versions are released! ****
SDK="iphonesimulator"

matrix:
  include:
   - PLATFORM="destination iOS Simulator, id:B40F7090-26EE-4D2E-A7A2-C13E10EDA669, OS:12.1, name:iPhone XS"
   - PLATFORM="destination iOS Simulator, id:2CE7B5F1-453E-4776-A551-F8AE61234E8F, OS:12.1, name:iPad Pro (12.9-inch) (3rd generation)"
   - PLATFORM="destination iOS Simulator, id:B40F7090-26EE-4D2E-A7A2-C13E10EDA669, OS:12.1, name:iPhone X"


# It is pitch black.
set -e
function trap_handler() {
    echo -e "\n\nOh no! You walked directly into the slavering fangs of a lurking grue!"
    echo "**** You have died ****"
    exit 255
}
trap trap_handler INT TERM EXIT


MODE="$1"

if [ "$MODE" = "framework" ]; then
    echo "Building and testing Zip."
    xcodebuild \
        -project Zip.xcodeproj \
        -scheme Zip \
        -sdk "$SDK" \
        -destination "$PLATFORM" \
        test
    trap - EXIT
    exit 0
fi

if [ "$MODE" = "examples" ]; then
    echo "Building and testing all Zip examples."

    for example in examples/*/; do
        echo "Building $example."
        pod install --project-directory=$example
        xcodebuild \
            -workspace "${example}Sample.xcworkspace" \
            -scheme Sample \
            -sdk "$SDK" \
            -destination "$PLATFORM"
    done
    trap - EXIT
    exit 0
fi

echo "Unrecognised mode '$MODE'."
