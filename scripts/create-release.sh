#!/bin/bash
# Script to create a new release

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <version> [tag_message]"
    echo "Example: $0 1.0.0 'Initial release'"
    exit 1
fi

VERSION="$1"
TAG_MESSAGE="${2:-Release version $VERSION}"

# Update version in plugin file
sed -i.bak "s/Version: [0-9]\+\.[0-9]\+\.[0-9]\+/Version: $VERSION/" zoc.plugin.zsh
rm zoc.plugin.zsh.bak

# Update version in README
sed -i.bak "s/version-[0-9]\+\.[0-9]\+\.[0-9]\+/version-$VERSION/" README.md
rm README.md.bak

echo "✅ Updated version to $VERSION in files"
echo "📝 Commit changes and push, then create tag:"
echo "   git add ."
echo "   git commit -m 'Release version $VERSION'"
echo "   git tag -a v$VERSION -m '$TAG_MESSAGE'"
echo "   git push origin main"
echo "   git push origin v$VERSION"
echo ""
echo "🚀 Or use GitHub Actions workflow:"
echo "   Go to Actions > Release > Run workflow"
