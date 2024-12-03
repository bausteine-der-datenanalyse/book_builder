#!/bin/bash

# Set output path for combined YAML
OUTPUT_YAML="_quarto.yml"

# Start the YAML file
cat <<EOF > $OUTPUT_YAML
project:
  type: book

book:
  title: "The Big Book"
  author: 
    - Lukas Arnold
    - Simone Arnold
    - Florian Bagemihl
    - Matthias Baitsch
    - Marc Fehr
    - Maik Poetzsch
    - Sebastian Seipel
  date: today
  chapters:
    - index.qmd
EOF

# Define the order of submodules
SUBMODULES_ORDER=(
  "books/w-python-numpy-grundlagen"  # First sub-book
  "books/a-auswertung_fds_daten"  # Second sub-book
)

# Function to extract and append chapters from a submodule's _quarto.yml
extract_parts_and_chapters() {
  local SUBMODULE=$1
  local MODULE_NAME=$(basename "$SUBMODULE")
  local YAML_PATH="${SUBMODULE}/_quarto-full.yml"
  
  # Check if the submodule has a _quarto.yml file
  if [[ -f "$YAML_PATH" ]]; then
    # Extract chapters from the YAML using yq
    CHAPTERS=$(yq eval '.book.chapters[]' "$YAML_PATH")
    
    # Add the part and chapters to the big book's _quarto.yml
    echo "    - part: \"$MODULE_NAME\"" >> $OUTPUT_YAML
    echo "      chapters:" >> $OUTPUT_YAML
    while read -r CHAPTER; do
      echo "        - $CHAPTER" >> $OUTPUT_YAML
    done <<< "$CHAPTERS"
  else
    echo "No _quarto.yml in ${SUBMODULE}, skipping..."
  fi
}

# Extract parts and chapters from each submodule in the defined order
for SUBMODULE in "${SUBMODULES_ORDER[@]}"; do
  # Ensure the submodule directory exists before processing
  if [[ -d "$SUBMODULE" ]]; then
    extract_parts_and_chapters "$SUBMODULE"
  else
    echo "Submodule $SUBMODULE does not exist, skipping..."
  fi
done

cat <<EOF >> $OUTPUT_YAML
format:
  html:
    theme: flatly
    toc: true
    toc-depth: 2
  pdf:
    number-sections: true
execute:
  echo: true
  warning: false
EOF

echo "Combined _quarto.yml with parts and chapters from submodules generated."

    
 