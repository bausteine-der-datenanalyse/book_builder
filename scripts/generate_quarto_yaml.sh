#!/bin/bash

# Set output path for combined YAML
OUTPUT_YAML="_quarto.yml"

# Start the YAML file
cat <<EOF > $OUTPUT_YAML
project:
  type: book
  output-dir: output/book/
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

# Step 2: Append parts and chapters under one unified 'book' section
for ITEM in "${SUBMODULES_ORDER[@]}"; do
  IFS=":" read -r SUBMODULE PART_NAME <<< "$ITEM"
  YAML_PATH="${SUBMODULE}/_quarto-full.yml"

  if [[ -f "$YAML_PATH" ]]; then
    CHAPTERS=$(yq eval '.book.chapters[]' "$YAML_PATH")

    echo "    - part: \"$PART_NAME\"" >> $OUTPUT_YAML
    echo "      chapters:" >> $OUTPUT_YAML
    while read -r CHAPTER; do
      [[ "$CHAPTER" == *"index.qmd" ]] && continue  # Skip submodule's index.qmd
      echo "        - $SUBMODULE/$CHAPTER" >> $OUTPUT_YAML
    done <<< "$CHAPTERS"
  else
    echo "No _quarto.yml in $SUBMODULE, skipping..."
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
EOF

echo "Combined _quarto.yml with parts and chapters from submodules generated."

    
 