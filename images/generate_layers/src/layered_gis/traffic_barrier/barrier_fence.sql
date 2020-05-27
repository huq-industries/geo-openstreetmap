
WITH osm AS (
  SELECT id, null AS way_id, all_tags FROM `..nodes`
  UNION ALL
  SELECT id, id AS way_id, all_tags FROM `..ways`
  UNION ALL
  SELECT id, null AS way_id, all_tags FROM `..relations`
)
SELECT 5216 AS layer_code, 'traffic' AS layer_class, 'barrier_fence' AS layer_name, f.feature_type AS gdal_type,
f.osm_id  AS osm_id,
f.osm_way_id AS osm_way_id,
f.osm_timestamp, osm.all_tags, f.geometry
FROM `..feature_union` AS f, osm
WHERE osm.id = f.osm_id
AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='fence')

UNION ALL

SELECT 5216 AS layer_code, 'traffic' AS layer_class, 'barrier_fence' AS layer_name, f.feature_type AS gdal_type,
f.osm_id AS osm_id,
f.osm_way_id AS osm_way_id,
f.osm_timestamp, osm.all_tags, f.geometry
FROM `..feature_union` AS f, osm
WHERE osm.way_id = f.osm_way_id
AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='fence')

