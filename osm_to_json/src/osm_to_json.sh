SRC_FILE_NAME=$(basename $SRC_OSM_GCS_URI)
LOCAL_FILE_NAME=${DATA_DIR}${SRC_FILE_NAME}
CSV_FILE_PREFIX=feature
JSONL_EXT=.jsonl

gsutil cp $SRC_OSM_GCS_URI $LOCAL_FILE_NAME
./osm2geojsoncsv $LOCAL_FILE_NAME ${DATA_DIR}${CSV_FILE_PREFIX}
./csv_to_json/csv-to-json.sh ${DATA_DIR}
gsutil cp ${DATA_DIR}*${JSONL_EXT} ${DEST_GCS_URI}