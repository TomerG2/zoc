#!/bin/bash
# Script to create a new release (run AFTER version is bumped and merged to main)
# Automatically extracts version from zoc.sh file

set -e

# Show help if requested
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: $0 [tag_message]"
    echo ""
    echo "Creates a new release by automatically extracting version from zoc.sh"
    echo ""
    echo "Arguments:"
    echo "  tag_message    Optional custom tag message (default: 'Release version X.Y.Z')"
    echo ""
    echo "Examples:"
    echo "  $0                           # Use default tag message"
    echo "  $0 'Fixed critical bug'      # Use custom tag message"
    echo ""
    echo "⚠️  Prerequisites:"
    echo "   1. Version must already be bumped in files (use scripts/bump-version.sh)"
    echo "   2. Changes must be merged to main branch"
    echo "   3. You must be on the main branch"
    exit 0
fi

# Extract version from zoc.sh file
VERSION=$(grep "Version:" zoc.sh | sed 's/.*Version: //' | tr -d ' ')

# Allow optional tag message as first parameter
TAG_MESSAGE="${1:-Release version $VERSION}"

if [ -z "$VERSION" ]; then
    echo "❌ Error: Could not extract version from zoc.sh"
    echo "   Expected format: # Version: X.Y.Z"
    exit 1
fi

echo "📦 Detected version: $VERSION"

# Validate we're on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "❌ Error: Must be on main branch to create release (currently on: $CURRENT_BRANCH)"
    exit 1
fi

# Validate version format
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "❌ Error: Version must be in semver format (e.g., 1.2.0)"
    exit 1
fi

# Check if version in files matches requested version
ZOC_VERSION=$(grep "Version:" zoc.sh | sed 's/.*Version: //' | tr -d ' ')
README_VERSION=$(grep -o 'version-[0-9]\+\.[0-9]\+\.[0-9]\+' README.md | sed 's/version-//')

if [ "$ZOC_VERSION" != "$VERSION" ] || [ "$README_VERSION" != "$VERSION" ]; then
    echo "❌ Error: Version mismatch!"
    echo "   Requested: $VERSION"
    echo "   zoc.sh: $ZOC_VERSION"
    echo "   README.md: $README_VERSION"
    echo ""
    echo "💡 Run: ./scripts/bump-version.sh $VERSION"
    exit 1
fi

# Check if tag already exists
if git tag -l | grep -q "^v$VERSION$"; then
    echo "❌ Error: Tag v$VERSION already exists"
    exit 1
fi

echo "✅ Version $VERSION is consistent across files"
echo "🏷️  Creating tag and release..."

# Create and push tag
git tag -a "v$VERSION" -m "$TAG_MESSAGE"
git push origin "v$VERSION"

echo "✅ Created and pushed tag: v$VERSION"
echo ""
echo "🚀 Next steps:"
echo "   1. Create GitHub release manually, or"
echo "   2. Use GitHub Actions: Actions > Release > Run workflow"
echo "      - Version: $VERSION"
echo "      - Tag message: $TAG_MESSAGE"
