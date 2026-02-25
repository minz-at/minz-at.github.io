#!/bin/bash

# Build script for Jekyll site with environment-specific configurations

# Find bundle command
find_bundle() {
    # Check common locations for bundle
    local bundle_paths=(
        "$(which bundle 2>/dev/null)"
        "$HOME/.local/share/gem/ruby/3.4.0/bin/bundle"
        "$HOME/.gem/bin/bundle"
        "/usr/local/bin/bundle"
        "$(gem environment | grep 'EXECUTABLE DIRECTORY' | cut -d: -f2 | xargs)/bundle"
    )

    for path in "${bundle_paths[@]}"; do
        if [ -x "$path" ]; then
            echo "$path"
            return
        fi
    done

    echo "bundle"  # fallback
}

BUNDLE=$(find_bundle)

# Check if bundle is available
if ! command -v "$BUNDLE" &> /dev/null; then
    echo "❌ Error: Bundle command not found!"
    echo ""
    echo "Please ensure Ruby and Bundler are installed:"
    echo "  gem install bundler"
    echo ""
    echo "Or install gems with the full path:"
    echo "  $HOME/.local/share/gem/ruby/3.4.0/bin/bundle install --path vendor/bundle"
    exit 1
fi

case "$1" in
  "dev" | "development")
    echo "🔧 Building for development..."
    echo "Using bundle: $BUNDLE"
    "$BUNDLE" exec jekyll serve --config _config.yml,_config.development.yml --host 0.0.0.0 --port 4000
    ;;
  "prod" | "production")
    echo "🚀 Building for production..."
    echo "Using bundle: $BUNDLE"
    JEKYLL_ENV=production "$BUNDLE" exec jekyll build --config _config.yml,_config.production.yml 2>/dev/null | grep -E "(Configuration file|Source|Destination|Generating|Jekyll Feed|done in|Auto-regeneration)"
    ;;
  "build-dev")
    echo "🔧 Building development site..."
    echo "Using bundle: $BUNDLE"
    "$BUNDLE" exec jekyll build --config _config.yml,_config.development.yml 2>/dev/null | grep -E "(Configuration file|Source|Destination|Generating|Jekyll Feed|done in|Auto-regeneration)"
    ;;
  *)
    echo "Usage: $0 {dev|production|build-dev}"
    echo ""
    echo "  dev          - Start development server"
    echo "  production   - Build for production"
    echo "  build-dev    - Build development site"
    echo ""
    echo "Examples:"
    echo "  ./build.sh dev        # Start development server"
    echo "  ./build.sh production # Build production site"
    echo ""
    echo "Using bundle: $BUNDLE"
    exit 1
    ;;
esac