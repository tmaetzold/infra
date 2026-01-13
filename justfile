#!/usr/bin/env just --justfile

# show available commands
[private]
default:
    @just --list

# sync Python dependencies with uv
sync:
    @uv sync

# dotfiles module (Home Manager)
mod dotfiles

# nixos module
mod nixos
