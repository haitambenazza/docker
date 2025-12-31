#!/bin/bash

set -e #exiting in case of errors

DB_ROOT_PASS=$(cat /run/)

exec mysqld_safe