#!/bin/bash
# Post-generation hook for daily-brief plugin
# Validates YAML output and collects deliverables into the output directory.

set -euo pipefail

DATE=$(date +%Y-%m-%d)
OUTPUT_DIR="./output/intelligence-data"
FINAL_DIR="./output"

BRIEF_FILE="${OUTPUT_DIR}/daily-brief/${DATE}.yaml"
TICKER_FILE="${OUTPUT_DIR}/ticker/latest.yaml"
SOURCES_FILE="${OUTPUT_DIR}/sources.md"

echo "=== Post-Generate Hook ==="
echo "Date: ${DATE}"

# 1. Validate files exist and are non-empty
echo "--- Validating output files ---"

for FILE in "${BRIEF_FILE}" "${TICKER_FILE}"; do
  if [ ! -s "${FILE}" ]; then
    echo "ERROR: Missing or empty file: ${FILE}"
    exit 1
  fi

  # Check YAML starts with ---
  FIRST_LINE=$(head -1 "${FILE}")
  if [ "${FIRST_LINE}" != "---" ]; then
    echo "ERROR: File does not start with '---': ${FILE}"
    echo "First line is: ${FIRST_LINE}"
    exit 1
  fi

  echo "OK: ${FILE}"
done

# 2. Validate required fields in daily brief
echo "--- Checking required fields ---"
for FIELD in title date author status summary preview full_content; do
  if ! grep -q "^${FIELD}:" "${BRIEF_FILE}"; then
    echo "ERROR: Missing required field '${FIELD}' in ${BRIEF_FILE}"
    exit 1
  fi
done
echo "OK: All required fields present"

# 3. Check sources.md exists
echo "--- Checking sources ---"
if [ ! -s "${SOURCES_FILE}" ]; then
  echo "WARNING: sources.md is missing or empty at ${SOURCES_FILE}"
else
  echo "OK: ${SOURCES_FILE}"
fi

# 4. Collect all deliverables into output/
echo "--- Collecting output files ---"
cp "${BRIEF_FILE}" "${FINAL_DIR}/${DATE}.yaml"
cp "${TICKER_FILE}" "${FINAL_DIR}/latest.yaml"
if [ -s "${SOURCES_FILE}" ]; then
  cp "${SOURCES_FILE}" "${FINAL_DIR}/sources.md"
fi

echo ""
echo "=== Output Files ==="
ls -la "${FINAL_DIR}/${DATE}.yaml" "${FINAL_DIR}/latest.yaml" "${FINAL_DIR}/sources.md" 2>/dev/null
echo ""
echo "=== Post-Generate Complete ==="
