#!/usr/bin/env bash
ssh-keyscan -H ${host_ip} >> ~/.ssh/known_hosts
