#!/bin/sh

wl-paste --no-newline | tr -d '\r'

# wl-paste | sed 's/\r//g'
# wl-paste | sed 's/\r$//'
