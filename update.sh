#!/usr/bin/env bash

git pull
sleep 1
sudo nixos-rebuild switch --flake .#unkown

echo -e "Update Completed!"
./update-report.sh
