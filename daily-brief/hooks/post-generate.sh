#!/bin/bash
# Post-generation hook for daily-brief plugin
# Validates YAML output matches the exact schema expected by the website.

set -euo pipefail

DATE=$(date +%Y-%m-%d)
OUTPUT_DIR="./output/intelligence-data"
FINAL_DIR="./output"

BRIEF_FILE="${OUTPUT_DIR}/daily-brief/${DATE}.yaml"
TICKER_FILE="${OUTPUT_DIR}/ticker/latest.yaml"
SOURCES_FILE="${OUTPUT_DIR}/sources.md"

ERRORS=0

echo "=== Post-Generate Validation ==="
echo "Date: ${DATE}"

# --- Helper ---
fail() {
  echo "ERROR: $1"
  ERRORS=$((ERRORS + 1))
}

# =============================================
# 1. FILES EXIST AND START WITH ---
# =============================================
echo ""
echo "--- File existence ---"

for FILE in "${BRIEF_FILE}" "${TICKER_FILE}"; do
  if [ ! -s "${FILE}" ]; then
    fail "Missing or empty: ${FILE}"
    continue
  fi
  FIRST_LINE=$(head -1 "${FILE}")
  if [ "${FIRST_LINE}" != "---" ]; then
    fail "File does not start with '---': ${FILE} (got: '${FIRST_LINE}')"
  else
    echo "OK: ${FILE}"
  fi
done

# =============================================
# 2. DAILY BRIEF — REQUIRED FIELDS
# =============================================
echo ""
echo "--- Daily brief: required fields ---"

if [ -s "${BRIEF_FILE}" ]; then
  for FIELD in title date author status summary preview full_content; do
    if ! grep -q "^${FIELD}:" "${BRIEF_FILE}"; then
      fail "Missing required field '${FIELD}' in daily brief"
    fi
  done

  # Check preview and full_content use YAML multiline syntax (field: |)
  if ! grep -q "^preview: |" "${BRIEF_FILE}"; then
    fail "preview must use YAML multiline syntax (preview: |)"
  fi
  if ! grep -q "^full_content: |" "${BRIEF_FILE}"; then
    fail "full_content must use YAML multiline syntax (full_content: |)"
  fi
fi

# =============================================
# 3. DAILY BRIEF — FORBIDDEN FIELDS
# =============================================
echo ""
echo "--- Daily brief: forbidden fields ---"

if [ -s "${BRIEF_FILE}" ]; then
  for BAD_FIELD in sections subtitle classification generated_at as_of footer metadata equities fixed_income commodities fx volatility alerts; do
    if grep -q "^${BAD_FIELD}:" "${BRIEF_FILE}"; then
      fail "Forbidden top-level field '${BAD_FIELD}' found in daily brief. The website ignores this field. Only use: title, date, author, status, summary, preview, full_content."
    fi
  done
fi

# =============================================
# 4. DAILY BRIEF — HTML CONTENT CHECK
# =============================================
echo ""
echo "--- Daily brief: HTML content ---"

if [ -s "${BRIEF_FILE}" ]; then
  # Check that full_content contains all 6 section headers
  for SECTION in "1. Market Snapshot" "2. Regulatory Watch" "3. Operational Intel" "4. Data Snapshot" "5. The CFO Take" "6. Coming This Week"; do
    if ! grep -q "${SECTION}" "${BRIEF_FILE}"; then
      fail "Missing section '${SECTION}' in full_content"
    fi
  done

  # Check that content uses HTML tags (not plain text/markdown)
  if ! grep -q "<h3>" "${BRIEF_FILE}"; then
    fail "No <h3> tags found. Content must be HTML, not plain text or markdown."
  fi
  if ! grep -q "<table>" "${BRIEF_FILE}"; then
    fail "No <table> tags found. Market data must be in HTML tables."
  fi
  if ! grep -q "<td>" "${BRIEF_FILE}"; then
    fail "No <td> tags found. Tables appear empty or malformed."
  fi

  # Check that preview contains sections 1 and 2
  # Extract preview block (between "preview: |" and next top-level field)
  PREVIEW_HAS_S1=$(sed -n '/^preview: |/,/^[a-z_]*:/{ /Market Snapshot/p; }' "${BRIEF_FILE}" | head -1)
  PREVIEW_HAS_S2=$(sed -n '/^preview: |/,/^[a-z_]*:/{ /Regulatory Watch/p; }' "${BRIEF_FILE}" | head -1)
  if [ -z "${PREVIEW_HAS_S1}" ]; then
    fail "preview does not contain 'Market Snapshot' section"
  fi
  if [ -z "${PREVIEW_HAS_S2}" ]; then
    fail "preview does not contain 'Regulatory Watch' section"
  fi
fi

# =============================================
# 5. TICKER — STRUCTURE CHECK
# =============================================
echo ""
echo "--- Ticker: structure ---"

if [ -s "${TICKER_FILE}" ]; then
  # Required fields
  if ! grep -q "^date:" "${TICKER_FILE}"; then
    fail "Missing 'date' field in ticker"
  fi
  if ! grep -q "^updated_at:" "${TICKER_FILE}"; then
    fail "Missing 'updated_at' field in ticker"
  fi
  if ! grep -q "^items:" "${TICKER_FILE}"; then
    fail "Missing 'items' field in ticker"
  fi

  # Forbidden fields
  for BAD_FIELD in equities fixed_income commodities fx volatility alerts sections separator; do
    if grep -q "^${BAD_FIELD}:" "${TICKER_FILE}"; then
      fail "Forbidden top-level field '${BAD_FIELD}' in ticker. Only use: date, updated_at, items."
    fi
  done

  # Check items have text and category
  ITEM_COUNT=$(grep -c "^  - text:" "${TICKER_FILE}" || true)
  if [ "${ITEM_COUNT}" -lt 4 ]; then
    fail "Ticker has ${ITEM_COUNT} items (need 4-6)"
  fi
  if [ "${ITEM_COUNT}" -gt 6 ]; then
    fail "Ticker has ${ITEM_COUNT} items (need 4-6)"
  fi

  CATEGORY_COUNT=$(grep -c "category:" "${TICKER_FILE}" || true)
  if [ "${CATEGORY_COUNT}" -lt "${ITEM_COUNT}" ]; then
    fail "Some ticker items are missing 'category' field"
  fi

  # Check no items have symbol/value/direction/unit/change_pct (wrong format)
  for BAD_ITEM_FIELD in symbol value direction unit change_pct name; do
    if grep -q "    ${BAD_ITEM_FIELD}:" "${TICKER_FILE}"; then
      fail "Ticker items must have only 'text' and 'category'. Found forbidden field '${BAD_ITEM_FIELD}'."
    fi
  done
fi

# =============================================
# 6. SOURCES
# =============================================
echo ""
echo "--- Sources ---"
if [ -s "${SOURCES_FILE}" ]; then
  echo "OK: ${SOURCES_FILE}"
else
  echo "WARNING: sources.md is missing or empty"
fi

# =============================================
# RESULT
# =============================================
echo ""
if [ "${ERRORS}" -gt 0 ]; then
  echo "=== VALIDATION FAILED: ${ERRORS} error(s) ==="
  echo ""
  echo "The output files do not match the website's expected format."
  echo "Review the intelligence-content skill for the exact schema."
  exit 1
fi

echo "=== VALIDATION PASSED ==="
echo ""

# Collect deliverables into output/
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
