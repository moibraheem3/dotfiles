#!/usr/bin/env bash

set -e

stow --target=$HOME --adopt configs --ignore=zshrc
