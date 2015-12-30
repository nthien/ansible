#!/bin/bash
set -e
/bin/chown -R www-data:www-data /data/www
exec "$@"
