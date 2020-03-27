#!/bin/bash

echo "cloning"
git clone https://github.com/gogo/protobuf "../Proto/github.com/gogo/protobuf" --branch v1.2.1 -q > /dev/null 2>&1 || true

echo "generating proto"
protoc -I=../Proto --swift_out=../MBCarKit/MBCarKit/Generated/Proto ../Proto/*.proto
