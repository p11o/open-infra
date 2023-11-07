#!/bin/bash
set -e

if kind get clusters | grep -q "kind"; then
  echo '{"exists": "true"}'
else
  echo '{"exists": "false"}'
fi
