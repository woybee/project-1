#!/bin/bash

rm -rf /tmp/*
rm -rf /var/tmp/*

apt clean -y

rm -rf /home/sysadmin/.cache/thumbnails
