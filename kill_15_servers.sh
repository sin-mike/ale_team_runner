#!/bin/bash

ps uxf | grep nc | grep 170 | perl -lne 'm !\s*\S+\s+(\d+)!; print $1' | xargs kill

