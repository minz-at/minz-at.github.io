#!/bin/bash

# Fix localhost URLs to production URLs in all HTML files
# This script replaces http://localhost:4000 with https://www.minz.at

set -e

echo "🔧 Fixing URLs in HTML files..."
echo ""

# Find all HTML files
html_files=$(find . -name "*.html" -type f)

if [ -z "$html_files" ]; then
    echo "❌ No HTML files found"
    exit 1
fi

# Counter for modified files
modified=0

# Process each HTML file
for file in $html_files; do
    # Check if file contains localhost URLs
    if grep -q "http://localhost:4000" "$file"; then
        echo "📝 Fixing: $file"

        # Replace localhost URLs with production URLs
        sed -i 's|http://localhost:4000|https://www.minz.at|g' "$file"

        ((modified++))
    fi
done

echo ""
echo "✅ Done! Fixed $modified file(s)"

# Show summary of production URLs
echo ""
echo "📊 Verification - Production URLs found:"
grep -r "https://www.minz.at" --include="*.html" . | wc -l | xargs echo "  Total occurrences:"

echo ""
echo "🔍 Checking for remaining localhost URLs..."
remaining=$(grep -r "localhost" --include="*.html" . 2>/dev/null | wc -l)
if [ "$remaining" -eq 0 ]; then
    echo "✅ No localhost URLs remaining"
else
    echo "⚠️  Warning: Found $remaining localhost reference(s):"
    grep -rn "localhost" --include="*.html" . | head -5
fi
