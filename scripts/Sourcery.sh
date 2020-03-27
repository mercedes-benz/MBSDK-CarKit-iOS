#!/bin/bash

sourcery="../Pods"/Sourcery/bin/sourcery
if [ -f "$sourcery" ]; then
    "$sourcery" --config "$1"
fi
