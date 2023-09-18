LAYERS="$1"

LOCAL_FILE_NAME=${SRC_FILE_NAME}
CSV_FILE_PREFIX=feature
JSONL_EXT=.jsonl

./osm2geojsoncsv $LOCAL_FILE_NAME ${DATA_DIR}${CSV_FILE_PREFIX} $LAYERS
./csv_to_json/csv-to-json.sh ${DATA_DIR}
