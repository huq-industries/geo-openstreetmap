#!/bin/bash
AREA_NAME=europe
SRC_FILE_NAME=europe-latest.osm.pbf
export SRC_FILE_NAME
DATA_DIR=data/
export data
FEATURES_DIR_GCS_URI=gs://openstreetmap-work/europe/features
NODES_WAYS_RELATIONS_DIR_GCS_URI=gs://openstreetmap-work/europe/nwr/
NUM_THREADS=8
GCP_PROJECT=huq-jimbo
export GCP_PROJECT

rm -Rf data/*
./osm_to_features.sh multipolygons
./osm_to_features.sh other_relations,points,multilinestrings,lines
gsutil cp data/*.csv.jsonl $FEATURES_DIR_GCS_URI
bq load --replace=true --source_format=NEWLINE_DELIMITED_JSON --clustering_fields=geometry openstreetmap_work.lines gs://openstreetmap-work/$AREA_NAME/features/feature-lines.geojson.csv.jsonl features_table_schema.json
bq load --replace=true --source_format=NEWLINE_DELIMITED_JSON --clustering_fields=geometry openstreetmap_work.multilinestrings gs://openstreetmap-work/$AREA_NAME/features/feature-multilinestrings.geojson.csv.jsonl features_table_schema.json
bq load --replace=true --source_format=NEWLINE_DELIMITED_JSON --clustering_fields=geometry openstreetmap_work.multipolygons gs://openstreetmap-work/$AREA_NAME/features/feature-multipolygons.geojson.csv.jsonl features_table_schema.json
bq load --replace=true --source_format=NEWLINE_DELIMITED_JSON --clustering_fields=geometry openstreetmap_work.other_relations gs://openstreetmap-work/$AREA_NAME/features/feature-other_relations.geojson.csv.jsonl features_table_schema.json
bq load --replace=true --source_format=NEWLINE_DELIMITED_JSON --clustering_fields=geometry openstreetmap_work.points gs://openstreetmap-work/$AREA_NAME/features/feature-points.geojson.csv.jsonl features_table_schema.json

python3 pbf_parser.py $SRC_FILE_NAME $NODES_WAYS_RELATIONS_DIR_GCS_URI --num_threads $NUM_THREADS
bq load --replace=true --source_format=NEWLINE_DELIMITED_JSON --clustering_fields=geometry openstreetmap_work.nodes gs://openstreetmap-work/$AREA_NAME/nwr/nodes.jsonl nodes_table_schema.json
bq load --replace=true --source_format=NEWLINE_DELIMITED_JSON --clustering_fields=geometry openstreetmap_work.ways gs://openstreetmap-work/$AREA_NAME/nwr/ways.jsonl ways_table_schema.json
bq load --replace=true --source_format=NEWLINE_DELIMITEwgtD_JSON --clustering_fields=geometry openstreetmap_work.relations gs://openstreetmap-work/$AREA_NAME/nwr/relations.jsonl relations_table_schema.json