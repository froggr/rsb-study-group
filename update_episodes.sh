#!/bin/bash

# Directory containing the episode markdown files
EPISODES_DIR="_episodes"

# Base date for calculation
BASE_DATE="1995-01-01"

# Iterate over each markdown file in the episodes directory
for file in "$EPISODES_DIR"/*.md; do
  # Extract the episode number
  EPISODE_NUMBER=$(grep -E '^episode: [0-9]+' "$file" | awk '{print $2}')
  
  if [ -n "$EPISODE_NUMBER" ]; then
    # Calculate the episode date
    EPISODE_DATE=$(date -d "$BASE_DATE +$((EPISODE_NUMBER * 2)) days" +%Y-%m-%d)
    
    # Insert the episode date below the episode number
    awk -v episode_date="$EPISODE_DATE" '/^episode: [0-9]+/ {print; print "date: " episode_date; next}1' "$file" > temp && mv temp "$file"
    
    echo "Updated $file with date: $EPISODE_DATE"
  else
    echo "No episode number found in $file"
  fi
done