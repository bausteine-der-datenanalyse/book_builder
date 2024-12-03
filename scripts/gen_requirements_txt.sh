#!/bin/bash

OUTPUT_FILE="requirements.txt"

# Clear the output file
: > "$OUTPUT_FILE"

# Find and append all requirements.txt files
find . -name "requirements.txt" | while read FILE; do
  echo "Adding dependencies from $FILE..."
  cat "$FILE" >> $OUTPUT_FILE
  echo "" >> $OUTPUT_FILE
done

# Remove duplicate lines and sort the requirements
sort -u $OUTPUT_FILE -o $OUTPUT_FILE

echo "Combined requirements written to $OUTPUT_FILE."