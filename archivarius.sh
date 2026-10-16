#!/bin/sh

MAIN_DIR="$HOME/RustDesk"
ARCH_DIR_NAME="archived_data"
CURR_DATE=$(/bin/sh -c "date +%H-%M-%S_%d-%m-%Y")



#Move to the main directory
cd $MAIN_DIR

# Сheck whether the ARCH_DIR_NAME directory exists
[ ! -d "$ARCH_DIR_NAME" ] && mkdir $ARCH_DIR_NAME

# Stopping all containers and wait for completion.
docker compose -f $MAIN_DIR/docker-compose.yml stop &
wait $!

# Create a compressed archive with the data from the data directory
tar -czf $MAIN_DIR/$ARCH_DIR_NAME/$CURR_DATE.tar.gz ./data/*

# Starting all containers
docker compose -f $MAIN_DIR/docker-compose.yml up -d


# Searches for archives older than 15 days and deletes them
find $MAIN_DIR/$ARCH_DIR_NAME -type f -mtime +15 -delete