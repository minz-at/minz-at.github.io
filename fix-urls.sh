#!/bin/bash

# Fix localhost URLs to production URLs in all HTML files
# This script replaces http://localhost:4000 with https://www.minz.at

set -e

echo "🔧 Fixing URLs in HTML and XML files..."
echo ""

# Find all HTML files and XML files (sitemap.xml, feed.xml)
files=$(find . -name "*.html" -type f -o -name "sitemap.xml" -type f -o -name "feed.xml" -type f)

if [ -z "$files" ]; then
    echo "❌ No HTML or XML files found"
    exit 1
fi

# Counter for modified files
modified=0

# Process each file
for file in $files; do
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
grep -r "https://www.minz.at" --include="*.html" --include="*.xml" . | wc -l | xargs echo "  Total occurrences:"

echo ""
echo "🔍 Checking for remaining localhost URLs..."
remaining=$(grep -r "localhost" --include="*.html" --include="*.xml" . 2>/dev/null | wc -l)
if [ "$remaining" -eq 0 ]; then
    echo "✅ No localhost URLs remaining"
else
    echo "⚠️  Warning: Found $remaining localhost reference(s):"
    grep -rn "localhost" --include="*.html" --include="*.xml" . | head -5
fi
