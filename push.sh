#!/bin/bash

set -euo pipefail

git add -A && git commit --allow-empty-message -m "" && git push
