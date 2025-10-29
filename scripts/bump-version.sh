#!/bin/bash
# Script to bump version numbers in files (to be used during PR phase)

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 1.2.0"
    echo ""
    echo "This script updates version numbers in:"
    echo "  - zoc.sh (plugin version comment)"
    echo "  - README.md (version badge)"
    echo ""
    echo "Use this script while your PR is open, before merging to main."
    echo "After merging, use scripts/create-release.sh to create the actual release."
    exit 1
fi

VERSION="$1"

# Validate version format (basic semver check)
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "❌ Error: Version must be in semver format (e.g., 1.2.0)"
    exit 1
fi

# Show current versions before changing
echo "📋 Current versions:"
echo "  zoc.sh: $(grep "Version:" zoc.sh | sed 's/.*Version: //')"
echo "  README.md: $(grep -o 'version-[0-9]\+\.[0-9]\+\.[0-9]\+' README.md | sed 's/version-//')"
echo ""

# Update version in plugin file
sed -i.bak "s/Version: [0-9]\+\.[0-9]\+\.[0-9]\+/Version: $VERSION/" zoc.sh
rm zoc.sh.bak

# Update version in README
sed -i.bak "s/version-[0-9]\+\.[0-9]\+\.[0-9]\+/version-$VERSION/" README.md
rm README.md.bak

echo "✅ Updated version to $VERSION in:"
echo "  - zoc.sh"
echo "  - README.md"
echo ""
echo "📝 Next steps:"
echo "  1. Review the changes: git diff"
echo "  2. Commit: git add . && git commit -m 'Bump version to $VERSION'"
echo "  3. Push your PR for review"
echo "  4. After merging to main, run: ./scripts/create-release.sh $VERSION"