#!/bin/bash
git remote -v | grep -oE "https*://.*.git" | head -n1 | xargs open -a "Google Chrome.app" 
