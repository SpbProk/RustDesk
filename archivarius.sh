#!/bin/sh

ARCH_DIR_NAME="data_archive"
CURR_DATE=$(/bin/sh -c "date +%H-%M-%S_%d-%m-%Y")



# Сheck whether the ARCH_DIR_NAME directory exists
[ ! -d "./$ARCH_DIR_NAME" ] && mkdir $ARCH_DIR_NAME

# Stopping all containers
docker compose -f ./docker-compose.yml stop

# Create a compressed archive with the data from the data directory
tar -czf ./$ARCH_DIR_NAME/$CURR_DATE.tar.gz ./data/*

# Starting all containers
docker compose -f ./docker-compose.yml up -d


# Searches for archives older than 30 days and deletes them
find ./$ARCH_DIR_NAME -type f -mtime +30 -delete