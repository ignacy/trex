#!/bin/bash

nohup ./myprogram.sh > /dev/null 2>&1 & echo $! > run.pid
