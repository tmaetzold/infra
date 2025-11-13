#!/usr/bin/env just --justfile

[private]
default:
    @just --list

# Sync Python dependencies with uv
sync:
    uv sync

# apply, check, depends, ping, update
mod ansible
