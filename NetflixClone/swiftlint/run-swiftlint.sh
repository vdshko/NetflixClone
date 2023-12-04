#!/bin/sh

if [[ "${CONFIGURATION}" =~ "Debug" ]]; then
  if [ "${PODS_ROOT+x}" ] && [ -x "${PODS_ROOT}/SwiftLint/swiftlint" ]; then
    ${PODS_ROOT}/SwiftLint/swiftlint --config swiftlint/swiftlint.yml --quiet
  elif which swiftlint >/dev/null; then
    swiftlint --config swiftlint/swiftlint.yml --quiet
  else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
  fi
fi
