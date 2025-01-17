#!/usr/bin/env bash
set -e

# Disabled because Advanced threat protection in italynorth not supported
# bash create-terraform-storage.sh $1 inf false
# bash create-terraform-storage.sh $1 app false

bash create-terraform-storage.sh $1 inf
bash create-terraform-storage.sh $1 app

bash enable_feature.sh "$1"