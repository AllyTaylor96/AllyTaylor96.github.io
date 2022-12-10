#!/bin/bash

source env/bin/activate 
make html
pelican --listen
