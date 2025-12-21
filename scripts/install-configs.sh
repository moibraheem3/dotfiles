#!/usr/bin/env bash

set -xe

stow --target=$HOME --adopt home --ignore=zshrc
