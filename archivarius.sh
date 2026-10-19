#!/bin/sh

MAIN_DIR="$HOME/RustDesk"
ARCH_DIR="archived_data"
CURR_DATE=$(/bin/sh -c "date +%H-%M-%S_%d-%m-%Y")


#Move to the main directory
cd $MAIN_DIR

# Сheck whether the ARCH_DIR directory exists
[ ! -d "$ARCH_DIR" ] && mkdir $ARCH_DIR


# Stopping all containers and wait for completion.
docker compose -f $MAIN_DIR/docker-compose.yml stop & wait $!

# Removing all stopped containers, unused networks, all unused images, and all build cache
docker system prune --all --force

# Create a compressed archive with the data from the data directory
tar -czf $MAIN_DIR/$ARCH_DIR/$CURR_DATE.tar.gz ./data/*

# Starting all containers
docker compose -f $MAIN_DIR/docker-compose.yml up -d


# Searches for archives older than 15 days and deletes them
find $MAIN_DIR/$ARCH_DIR -type f -mtime +15 -delete