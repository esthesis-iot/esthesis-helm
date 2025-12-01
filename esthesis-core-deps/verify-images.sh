#!/bin/bash

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Bitnami Legacy Images Verification Script${NC}"
echo "==========================================="
echo ""

if [ ! -f "output.yaml" ]; then
    echo -e "${RED}Error: output.yaml not found. Please run 'helmfile template > output.yaml' first.${NC}"
    exit 1
fi

echo "Extracting images from output.yaml..."
IMAGES=$(grep -o "docker\.io/bitnamilegacy/[^:]*:[^\"]*" output.yaml | sort -u)

if [ -z "$IMAGES" ]; then
    echo -e "${RED}No bitnamilegacy images found in output.yaml${NC}"
    exit 1
fi

echo -e "${GREEN}Found the following images to verify:${NC}"
echo "$IMAGES" | sed 's/^/  - /'
echo ""

TOTAL=0
SUCCESS=0
FAILED=0
FAILED_IMAGES=""

echo "Verifying image accessibility..."
echo "================================"

while IFS= read -r image; do
    TOTAL=$((TOTAL + 1))
    echo -ne "Checking: ${image}... "
    
    if docker manifest inspect "$image" &> /dev/null; then
        echo -e "${GREEN}✓ EXISTS${NC}"
        SUCCESS=$((SUCCESS + 1))
    else
        echo -e "${RED}✗ NOT FOUND${NC}"
        FAILED=$((FAILED + 1))
        FAILED_IMAGES="${FAILED_IMAGES}\n  - ${image}"
    fi
done <<< "$IMAGES"

echo ""
echo "==========================================="
echo "Summary:"
echo "  Total images checked: $TOTAL"
echo -e "  ${GREEN}Successful: $SUCCESS${NC}"
echo -e "  ${RED}Failed: $FAILED${NC}"

if [ $FAILED -gt 0 ]; then
    echo ""
    echo -e "${RED}The following images were not found:${NC}"
    echo -e "$FAILED_IMAGES"
    echo ""
    echo -e "${YELLOW}Note: These images may not exist in the bitnamilegacy repository.${NC}"
    echo -e "${YELLOW}You may need to:${NC}"
    echo -e "${YELLOW}  1. Check if the image tags are correct${NC}"
    echo -e "${YELLOW}  2. Pull the images from the original bitnami repository${NC}"
    echo -e "${YELLOW}  3. Use alternative image sources or versions${NC}"
    exit 1
else
    echo ""
    echo -e "${GREEN}✓ All images are accessible!${NC}"
    exit 0
fi
