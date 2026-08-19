#!/usr/bin/env bash
# falcon custom command example
# Add to falcon.yaml:
#
# commands:
#   feature:stats:
#     confirm: false
#     steps:
#       - dfx canister call {{canister}} getFeatureCount --query {{network}}
#
# aliases:
#   x:stats: feature:stats
#
# Run: falcon x:stats --local
