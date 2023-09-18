OSM_URL=https://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/pbf/planet-latest.osm.pbf
OSM_MD5_URL=https://ftp5.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/pbf/planet-latest.osm.pbf.md5

#OSM_URL=https://download.geofabrik.de/europe/britain-and-ireland-latest.osm.pbf
#OSM_MD5_URL=https://download.geofabrik.de/europe/britain-and-ireland-latest.osm.pbf.md5

REGION_LOCATION="europe-west1"
ZONE="europe-west1"
SUFFIX="capybara"

BASE_COMPOSER_CLUSTER_MACHINE_TYPE="nn"
BASE_COMPOSER_CLUSTER_NODES="nn"

ADDT_SN_CORES=4
ADDT_SN_DISK_SIZE=2500

ADDT_MN_CORES=8
ADDT_MN_DISK_SIZE=2500
ADDT_MN_NODES=14

MODE=planet

bash deployment/create_full.sh $OSM_URL $OSM_MD5_URL $REGION_LOCATION $ZONE $SUFFIX $BASE_COMPOSER_CLUSTER_MACHINE_TYPE $BASE_COMPOSER_CLUSTER_NODES $ADDT_SN_CORES $ADDT_SN_DISK_SIZE $ADDT_MN_CORES $ADDT_MN_DISK_SIZE $ADDT_MN_NODES $MODE
