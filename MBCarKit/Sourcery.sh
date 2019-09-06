#!/bin/bash

pods_root_dir=${PODS_ROOT// /\ }

sourcery="$pods_root_dir"/Sourcery/bin/sourcery

if [ -f "$sourcery" ];
then
    "$sourcery"
fi
