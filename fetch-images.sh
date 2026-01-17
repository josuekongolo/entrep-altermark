#!/bin/bash

# Freepik API Image Fetcher for Entrep Altermark AS
API_KEY="FPSX16ea10a2ecf0f342b45d9a1ad35dde33"
BASE_DIR="/Users/josuekongolo/Downloads/nettsider/bygg/Gruppe3/entrep-altermark/images"

# Function to search and download image
fetch_image() {
    local search_term="$1"
    local output_path="$2"
    local output_name="$3"

    echo "Searching for: $search_term"

    # URL encode the search term
    encoded_term=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$search_term'))")

    # Search for images
    search_result=$(curl -s -X GET "https://api.freepik.com/v1/resources?locale=en-US&page=1&limit=5&order=relevance&term=${encoded_term}" \
        -H "x-freepik-api-key: $API_KEY" \
        -H "Accept: application/json")

    # Extract first image ID using python
    image_id=$(echo "$search_result" | python3 -c "import sys, json; data = json.load(sys.stdin); print(data['data'][0]['id'] if data.get('data') else '')" 2>/dev/null)

    if [ -z "$image_id" ]; then
        echo "  No images found for: $search_term"
        return 1
    fi

    echo "  Found image ID: $image_id"

    # Get download URL
    download_result=$(curl -s -X GET "https://api.freepik.com/v1/resources/${image_id}/download" \
        -H "x-freepik-api-key: $API_KEY" \
        -H "Accept: application/json")

    # Extract download URL
    download_url=$(echo "$download_result" | python3 -c "import sys, json; data = json.load(sys.stdin); print(data.get('data', {}).get('url', ''))" 2>/dev/null)

    if [ -z "$download_url" ]; then
        echo "  Could not get download URL"
        return 1
    fi

    echo "  Downloading to: ${output_path}/${output_name}"
    mkdir -p "$output_path"
    curl -s -L "$download_url" -o "${output_path}/${output_name}"

    if [ -f "${output_path}/${output_name}" ] && [ -s "${output_path}/${output_name}" ]; then
        echo "  Downloaded successfully!"
        return 0
    else
        echo "  Download failed"
        return 1
    fi
}

echo "=============================================="
echo "Fetching images for Entrep Altermark website"
echo "=============================================="
echo ""

# === HERO IMAGES ===
echo "=== HERO IMAGES ==="
echo "[1/18] Hero - Heavy Machinery"
fetch_image "excavator heavy machinery construction" "$BASE_DIR/hero" "hero-machinery.jpg"
echo ""

echo "[2/18] Intro - Company Equipment"
fetch_image "construction equipment yard" "$BASE_DIR/hero" "intro-equipment.jpg"
echo ""

# === SERVICE IMAGES (6) ===
echo "=== SERVICE IMAGES ==="
echo "[3/18] Tomtearbeid (Site Clearing)"
fetch_image "land clearing construction site" "$BASE_DIR/services" "tomtearbeid.jpg"
echo ""

echo "[4/18] Graving (Excavation)"
fetch_image "excavator digging foundation" "$BASE_DIR/services" "graving.jpg"
echo ""

echo "[5/18] VA-arbeid (Water/Sewage)"
fetch_image "pipe installation construction trench" "$BASE_DIR/services" "va-arbeid.jpg"
echo ""

echo "[6/18] Drenering (Drainage)"
fetch_image "drainage installation construction" "$BASE_DIR/services" "drenering.jpg"
echo ""

echo "[7/18] Veiarbeid (Road Work)"
fetch_image "road construction gravel" "$BASE_DIR/services" "veiarbeid.jpg"
echo ""

echo "[8/18] Industriarbeid (Industrial)"
fetch_image "industrial construction site heavy equipment" "$BASE_DIR/services" "industriarbeid.jpg"
echo ""

# === ABOUT IMAGES (4) ===
echo "=== ABOUT IMAGES ==="
echo "[9/18] Company Facility"
fetch_image "construction company facility" "$BASE_DIR/about" "company.jpg"
echo ""

echo "[10/18] Equipment Fleet"
fetch_image "excavator fleet machinery" "$BASE_DIR/about" "equipment.jpg"
echo ""

echo "[11/18] Industrial Heritage"
fetch_image "mining industrial site" "$BASE_DIR/about" "heritage.jpg"
echo ""

echo "[12/18] Team/Workers"
fetch_image "construction workers team" "$BASE_DIR/about" "team.jpg"
echo ""

# === PROJECT IMAGES (6) ===
echo "=== PROJECT IMAGES ==="
echo "[13/18] Boligtomter (Residential)"
fetch_image "residential construction site foundation" "$BASE_DIR/projects" "boligtomter.jpg"
echo ""

echo "[14/18] Hyttetomter (Cabin Sites)"
fetch_image "cabin mountain construction" "$BASE_DIR/projects" "hyttetomter.jpg"
echo ""

echo "[15/18] VA-anlegg (Water/Sewage Systems)"
fetch_image "sewer pipe installation" "$BASE_DIR/projects" "va-anlegg.jpg"
echo ""

echo "[16/18] Veiarbeid Projects (Roads)"
fetch_image "gravel driveway construction" "$BASE_DIR/projects" "veiarbeid.jpg"
echo ""

echo "[17/18] Næringsbygg (Commercial)"
fetch_image "commercial building foundation construction" "$BASE_DIR/projects" "naeringsbygg.jpg"
echo ""

echo "[18/18] Industriområder (Industrial Areas)"
fetch_image "industrial area construction excavator" "$BASE_DIR/projects" "industriomrader.jpg"
echo ""

echo "=============================================="
echo "Image fetching complete!"
echo "=============================================="

# List downloaded images
echo ""
echo "Downloaded images:"
find "$BASE_DIR" -name "*.jpg" -type f 2>/dev/null | while read f; do
    size=$(ls -lh "$f" | awk '{print $5}')
    echo "  $f ($size)"
done
