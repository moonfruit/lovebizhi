#!/bin/bash
TARGET=$(basename "$1")
exec find . -name "$TARGET*"
