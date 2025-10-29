#!/bin/bash
# Script to create a new release (run AFTER version is bumped and merged to main)

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <version> [tag_message]"
    echo "Example: $0 1.0.0 'Initial release'"
    echo ""
    echo "⚠️  Prerequisites:"
    echo "   1. Version must already be bumped in files (use scripts/bump-version.sh)"
    echo "   2. Changes must be merged to main branch"
    echo "   3. You must be on the main branch"
    exit 1
fi

VERSION="$1"
TAG_MESSAGE="${2:-Release version $VERSION}"

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
