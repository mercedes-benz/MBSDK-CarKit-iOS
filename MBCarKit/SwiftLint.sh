#!/bin/bash

pods_root_dir=${PODS_ROOT// /\ }

swiftlint="$pods_root_dir"/SwiftLint/swiftlint

if [ -f "$swiftlint" ];
then
    "$swiftlint"
fi
