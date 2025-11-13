#!/usr/bin/env just --justfile

[private]
default:
    @just --list

# Sync Python dependencies with uv
sync:
    uv sync

# depends, ping, update, [environment], [playbook]
mod ansible
