#!/usr/bin/env just --justfile

[private]
default:
    @just --list

# sync Python dependencies with uv
sync:
    @uv sync

# ansible module
mod ansible

# dotfiles module
mod dotfiles

# nixos module
mod nixos
