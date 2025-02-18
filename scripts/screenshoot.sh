#!/usr/bin/env bash

set -e

grim -g "$(slurp)" - | swappy -f -

