--
-- GeomFromGML regression test
-- Written by Olivier Courtin - Oslandia
--


--
-- spatial_ref_sys data
--
INSERT INTO "spatial_ref_sys" ("srid","auth_name","auth_srid","srtext","proj4text") VALUES (4326,'EPSG',4326,'GEOGCS["WGS 84",DATUM["WGS_1984",SPHEROID["WGS 84",6378137,298.257223563,AUTHORITY["EPSG","7030"]],TOWGS84[0,0,0,0,0,0,0],AUTHORITY["EPSG","6326"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.01745329251994328,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4326"]]','+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ');


-- Empty Geometry
SELECT 'empty_geom', ST_AsEWKT(ST_GeomFromGML(NULL));

--
-- XML
--

-- Empty String
SELECT 'xml_1', ST_AsEWKT(ST_GeomFromGML(''));

-- Not well formed XML
SELECT 'xml_2', ST_AsEWKT(ST_GeomFromGML('<foo>'));

-- Not a GML Geometry
SELECT 'xml_3', ST_AsEWKT(ST_GeomFromGML('<foo/>'));



--
-- Point
--

-- 1 Point
SELECT 'point_1', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coordinates>1,2</gml:coordinates></gml:Point>'));

-- ERROR: 2 points
SELECT 'point_2', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coordinates>1,2 3,4</gml:coordinates></gml:Point>'));

-- ERROR: empty point
SELECT 'point_3', ST_AsEWKT(ST_GeomFromGML('<gml:Point></gml:Point>'));

-- srsName handle
SELECT 'point_4', ST_AsEWKT(ST_GeomFromGML('<gml:Point srsName="EPSG:4326"><gml:pos>1 2</gml:pos></gml:Point>'));



--
-- LineString
--

-- 2 Points
SELECT 'linestring_1', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates>1,2 3,4</gml:coordinates></gml:LineString>'));

-- ERROR 1 Point
SELECT 'linestring_2', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates>1,2</gml:coordinates></gml:LineString>'));

-- srsName handle
SELECT 'linestring_3', ST_AsEWKT(ST_GeomFromGML('<gml:LineString srsName="EPSG:4326"><gml:coordinates>1,2 3,4</gml:coordinates></gml:LineString>'));

-- ERROR: empty coordinates 
SELECT 'linestring_4', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates></gml:coordinates></gml:LineString>'));
SELECT 'linestring_5', ST_AsEWKT(ST_GeomFromGML('<gml:LineString></gml:LineString>'));

-- XML not elements handle
SELECT 'linestring_6', ST_AsEWKT(ST_GeomFromGML(' <!-- --> <gml:LineString> <!-- --> <gml:coordinates>1,2 3,4</gml:coordinates></gml:LineString>'));




--
-- Curve
--

-- 2 Points
SELECT 'curve_1', ST_AsEWKT(ST_GeomFromGML('<gml:Curve><gml:segments><gml:LineStringSegment><gml:posList>1 2 3 4</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve>'));

-- ERROR 1 Point
SELECT 'curve_2', ST_AsEWKT(ST_GeomFromGML('<gml:Curve><gml:segments><gml:LineStringSegment><gml:posList>1 2</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve>'));

-- srsName handle
SELECT 'curve_3', ST_AsEWKT(ST_GeomFromGML('<gml:Curve srsName="EPSG:4326"><gml:segments><gml:LineStringSegment><gml:posList>1 2 3 4</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve>'));

-- ERROR: empty coordinates 
SELECT 'curve_4', ST_AsEWKT(ST_GeomFromGML('<gml:Curve srsName="EPSG:4326"><gml:segments><gml:LineStringSegment><gml:posList></gml:posList></gml:LineStringSegment></gml:segments></gml:Curve>'));
SELECT 'curve_5', ST_AsEWKT(ST_GeomFromGML('<gml:Curve srsName="EPSG:4326"><gml:segments><gml:LineStringSegment></gml:LineStringSegment></gml:segments></gml:Curve>'));
SELECT 'curve_6', ST_AsEWKT(ST_GeomFromGML('<gml:Curve srsName="EPSG:4326"><gml:segments></gml:segments></gml:Curve>'));
SELECT 'curve_7', ST_AsEWKT(ST_GeomFromGML('<gml:Curve srsName="EPSG:4326"></gml:Curve>'));

-- linear interpolation 
SELECT 'curve_8', ST_AsEWKT(ST_GeomFromGML('<gml:Curve><gml:segments><gml:LineStringSegment interpolation="linear"><gml:posList>1 2 3 4</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve>'));

-- ERROR: wrong interpolation 
SELECT 'curve_9', ST_AsEWKT(ST_GeomFromGML('<gml:Curve><gml:segments><gml:LineStringSegment interpolation="spline"><gml:posList>1 2 3 4</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve>'));

-- XML not elements handle
SELECT 'curve_10', ST_AsEWKT(ST_GeomFromGML(' <!-- --> <gml:Curve> <!-- --> <gml:segments> <!-- --> <gml:LineStringSegment> <!-- --> <gml:posList>1 2 3 4</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve>'));

-- 2 Segments
SELECT 'curve_11', ST_AsEWKT(ST_GeomFromGML('<gml:Curve><gml:segments><gml:LineStringSegment><gml:posList>1 2 3 4</gml:posList></gml:LineStringSegment><gml:LineStringSegment><gml:posList>3 4 5 6</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve>'));
SELECT 'curve_12', ST_AsEWKT(ST_GeomFromGML('<gml:Curve><gml:segments><gml:LineStringSegment><gml:posList dimension="3">1 2 3 4 5 6</gml:posList></gml:LineStringSegment><gml:LineStringSegment><gml:posList dimension="3">4 5 6 7 8 9</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve>'));

-- ERROR 2 Segments disjoint
SELECT 'curve_13', ST_AsEWKT(ST_GeomFromGML('<gml:Curve><gml:segments><gml:LineStringSegment><gml:posList>1 2 3 4</gml:posList></gml:LineStringSegment><gml:LineStringSegment><gml:posList>5 6 7 8</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve>'));

-- ERROR 2 3D Segments disjoint in Z
SELECT 'curve_14', ST_AsEWKT(ST_GeomFromGML('<gml:Curve><gml:segments><gml:LineStringSegment><gml:posList dimension="3">1 2 3 4 5 6</gml:posList></gml:LineStringSegment><gml:LineStringSegment><gml:posList dimension="3">4 5 0 7 8 9</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve>'));

-- 2 segments, mixed dimension
SELECT 'curve_15', ST_AsEWKT(ST_GeomFromGML('<gml:Curve><gml:segments><gml:LineStringSegment><gml:posList dimension="3">1 2 3 4 5 6</gml:posList></gml:LineStringSegment><gml:LineStringSegment><gml:posList dimension="2">4 5 7 8</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve>'));
SELECT 'curve_16', ST_AsEWKT(ST_GeomFromGML('<gml:Curve><gml:segments><gml:LineStringSegment><gml:posList dimension="2">1 2 3 4</gml:posList></gml:LineStringSegment><gml:LineStringSegment><gml:posList dimension="3">3 4 5 6 7 8</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve>'));




--
-- Polygon
--

-- GML 2 - 1 ring
SELECT 'polygon_1', ST_AsEWKT(ST_GeomFromGML('<gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon>'));

-- srsName handle
SELECT 'polygon_2', ST_AsEWKT(ST_GeomFromGML('<gml:Polygon srsName="EPSG:4326"><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon>'));

-- ERROR: In exterior ring: Last point is not the same as the first one 
SELECT 'polygon_3', ST_AsEWKT(ST_GeomFromGML('<gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,3</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon>'));

-- TODO ERROR: In exterior 3D ring: Last point is not the same as the first one in Z

-- ERROR: Only 3 points in exterior ring
SELECT 'polygon_4', ST_AsEWKT(ST_GeomFromGML('<gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates>1,2 3,4 1,2</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon>'));

-- ERROR: Empty exterior ring coordinates 
SELECT 'polygon_5', ST_AsEWKT(ST_GeomFromGML('<gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates></gml:coordinates></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon>'));
SELECT 'polygon_6', ST_AsEWKT(ST_GeomFromGML('<gml:Polygon><gml:outerBoundaryIs><gml:LinearRing></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon>'));
SELECT 'polygon_7', ST_AsEWKT(ST_GeomFromGML('<gml:Polygon><gml:outerBoundaryIs></gml:outerBoundaryIs></gml:Polygon>'));
SELECT 'polygon_8', ST_AsEWKT(ST_GeomFromGML('<gml:Polygon></gml:Polygon>'));

-- GML 2 - 2 rings
SELECT 'polygon_9', ST_AsEWKT(ST_GeomFromGML('<gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs><gml:innerBoundaryIs><gml:LinearRing><gml:coordinates>7,8 9,10 11,12 7,8</gml:coordinates></gml:LinearRing></gml:innerBoundaryIs></gml:Polygon>'));

-- XML not elements handle
SELECT 'polygon_10', ST_AsEWKT(ST_GeomFromGML(' <!-- --> <gml:Polygon> <!-- --> <gml:outerBoundaryIs> <!-- --> <gml:LinearRing> <!-- --> <gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs> <!-- --> <gml:innerBoundaryIs> <!-- --> <gml:LinearRing><gml:coordinates>7,8 9,10 11,12 7,8</gml:coordinates></gml:LinearRing></gml:innerBoundaryIs></gml:Polygon>'));

-- Empty interior ring coordinates  (even if defined)
SELECT 'polygon_11', ST_AsEWKT(ST_GeomFromGML('<gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs><gml:innerBoundaryIs></gml:innerBoundaryIs></gml:Polygon>'));

-- ERROR: Only 3 points in interior ring
SELECT 'polygon_12', ST_AsEWKT(ST_GeomFromGML('<gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs><gml:innerBoundaryIs><gml:LinearRing><gml:coordinates>7,8 9,10 7,8</gml:coordinates></gml:LinearRing></gml:innerBoundaryIs></gml:Polygon>'));

-- ERROR: In interior ring: Last point is not the same as the first one 
SELECT 'polygon_13', ST_AsEWKT(ST_GeomFromGML('<gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs><gml:innerBoundaryIs><gml:LinearRing><gml:coordinates>7,8 9,10 11,12 7,9</gml:coordinates></gml:LinearRing></gml:innerBoundaryIs></gml:Polygon>'));

-- TODO ERROR: In interior 3D ring: Last point is not the same as the first one in Z

-- GML 2 - 3 rings
SELECT 'polygon_14', ST_AsEWKT(ST_GeomFromGML('<gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs><gml:innerBoundaryIs><gml:LinearRing><gml:coordinates>7,8 9,10 11,12 7,8</gml:coordinates></gml:LinearRing></gml:innerBoundaryIs><gml:innerBoundaryIs><gml:LinearRing><gml:coordinates>13,14 15,16 17,18 13,14</gml:coordinates></gml:LinearRing></gml:innerBoundaryIs></gml:Polygon>'));

-- GML 3 
SELECT 'polygon_15', ST_AsEWKT(ST_GeomFromGML('<gml:Polygon><gml:exterior><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:exterior><gml:interior><gml:LinearRing><gml:coordinates>7,8 9,10 11,12 7,8</gml:coordinates></gml:LinearRing></gml:interior></gml:Polygon>'));

-- Mixed dimension in rings
SELECT 'polygon_16', ST_AsEWKT(ST_GeomFromGML('<gml:Polygon><gml:exterior><gml:LinearRing><gml:posList dimension="3">1 2 3 4 5 6 7 8 9 1 2 3</gml:posList></gml:LinearRing></gml:exterior><gml:interior><gml:LinearRing><gml:posList dimension="2">10 11 12 13 14 15 10 11</gml:posList></gml:LinearRing></gml:interior></gml:Polygon>'));
SELECT 'polygon_17', ST_AsEWKT(ST_GeomFromGML('<gml:Polygon><gml:exterior><gml:LinearRing><gml:posList dimension="2">1 2 3 4 5 6 1 2</gml:posList></gml:LinearRing></gml:exterior><gml:interior><gml:LinearRing><gml:posList dimension="3">7 8 9 10 11 12 13 14 15 7 8 9</gml:posList></gml:LinearRing></gml:interior></gml:Polygon>'));




--
-- Surface
--

-- 1 ring
SELECT 'surface_1', ST_AsEWKT(ST_GeomFromGML('<gml:Surface><gml:patches><gml:PolygonPatch><gml:exterior><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:exterior></gml:PolygonPatch></gml:patches></gml:Surface>'));

-- srsName handle
SELECT 'surface_2', ST_AsEWKT(ST_GeomFromGML('<gml:Surface srsName="EPSG:4326"><gml:patches><gml:PolygonPatch><gml:exterior><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:exterior></gml:PolygonPatch></gml:patches></gml:Surface>'));

-- ERROR: In exterior ring: Last point is not the same as the first one 
SELECT 'surface_3', ST_AsEWKT(ST_GeomFromGML('<gml:Surface><gml:patches><gml:PolygonPatch><gml:exterior><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,0</gml:coordinates></gml:LinearRing></gml:exterior></gml:PolygonPatch></gml:patches></gml:Surfacne>'));

-- TODO -- ERROR: In exterior 3D ring: Last point is not the same as the first one in Z

-- ERROR: Only 3 points in exterior ring
SELECT 'surface_4', ST_AsEWKT(ST_GeomFromGML('<gml:Surface><gml:patches><gml:PolygonPatch><gml:exterior><gml:LinearRing><gml:coordinates>1,2 3,4 1,2</gml:coordinates></gml:LinearRing></gml:exterior></gml:PolygonPatch></gml:patches></gml:Surface>'));

-- ERROR: Empty exterior ring coordinates 
SELECT 'surface_5', ST_AsEWKT(ST_GeomFromGML('<gml:Surface><gml:patches><gml:PolygonPatch><gml:exterior><gml:LinearRing></gml:LinearRing></gml:exterior></gml:PolygonPatch></gml:patches></gml:Surface>'));
SELECT 'surface_6', ST_AsEWKT(ST_GeomFromGML('<gml:Surface><gml:patches><gml:PolygonPatch><gml:exterior></gml:exterior></gml:PolygonPatch></gml:patches></gml:Surface>'));
SELECT 'surface_7', ST_AsEWKT(ST_GeomFromGML('<gml:Surface><gml:patches><gml:PolygonPatch></gml:PolygonPatch></gml:patches></gml:Surface>'));
SELECT 'surface_8', ST_AsEWKT(ST_GeomFromGML('<gml:Surface><gml:patches></gml:patches></gml:Surface>'));
SELECT 'surface_9', ST_AsEWKT(ST_GeomFromGML('<gml:Surface></gml:Surface>'));

-- 2 rings
SELECT 'surface_10', ST_AsEWKT(ST_GeomFromGML('<gml:Surface><gml:patches><gml:PolygonPatch><gml:exterior><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:exterior><gml:interior><gml:LinearRing><gml:coordinates>7,8 9,10 11,12 7,8</gml:coordinates></gml:LinearRing></gml:interior></gml:PolygonPatch></gml:patches></gml:Surface>'));

-- XML not elements handle
SELECT 'surface_11', ST_AsEWKT(ST_GeomFromGML(' <!-- --> <gml:Surface> <!-- --> <gml:patches> <!-- --> <gml:PolygonPatch> <!-- --> <gml:exterior> <!-- --> <gml:LinearRing> <!-- --> <gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:exterior> <!-- --> <gml:interior> <!-- --> <gml:LinearRing> <!-- --> <gml:coordinates>7,8 9,10 11,12 7,8</gml:coordinates></gml:LinearRing></gml:interior></gml:PolygonPatch></gml:patches></gml:Surface>'));

-- Empty interior ring coordinates  (even if defined)
SELECT 'surface_12', ST_AsEWKT(ST_GeomFromGML('<gml:Surface><gml:patches><gml:PolygonPatch><gml:exterior><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:exterior><gml:interior></gml:interior></gml:PolygonPatch></gml:patches></gml:Surface>'));

-- ERROR: Only 3 points in interior ring
SELECT 'surface_13', ST_AsEWKT(ST_GeomFromGML('<gml:Surface><gml:patches><gml:PolygonPatch><gml:exterior><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:exterior><gml:interior><gml:LinearRing><gml:coordinates>7,8 9,10 7,8</gml:coordinates></gml:LinearRing></gml:interior></gml:PolygonPatch></gml:patches></gml:Surface>'));

-- ERROR: In interior ring: Last point is not the same as the first one 
SELECT 'surface_14', ST_AsEWKT(ST_GeomFromGML('<gml:Surface><gml:patches><gml:PolygonPatch><gml:exterior><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:exterior><gml:interior><gml:LinearRing><gml:coordinates>7,8 9,10 11,12 7,0</gml:coordinates></gml:LinearRing></gml:interior></gml:PolygonPatch></gml:patches></gml:Surface>'));

-- TODO -- ERROR: In interior 3D ring: Last point is not the same as the first one in Z

-- 3 rings
SELECT 'surface_15', ST_AsEWKT(ST_GeomFromGML('<gml:Surface><gml:patches><gml:PolygonPatch><gml:exterior><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:exterior><gml:interior><gml:LinearRing><gml:coordinates>7,8 9,10 11,12 7,8</gml:coordinates></gml:LinearRing></gml:interior><gml:interior><gml:LinearRing><gml:coordinates>13,14 15,16 17,18 13,14</gml:coordinates></gml:LinearRing></gml:interior></gml:PolygonPatch></gml:patches></gml:Surface>'));

-- Mixed dimension in rings
SELECT 'surface_16', ST_AsEWKT(ST_GeomFromGML('<gml:Surface><gml:patches><gml:PolygonPatch><gml:exterior><gml:LinearRing><gml:posList dimension="3">1 2 3 4 5 6 7 8 9 1 2 3</gml:posList></gml:LinearRing></gml:exterior><gml:interior><gml:LinearRing><gml:posList dimension="2">10 11 12 13 14 15 10 11</gml:posList></gml:LinearRing></gml:interior></gml:PolygonPatch></gml:patches></gml:Surface>'));
SELECT 'surface_17', ST_AsEWKT(ST_GeomFromGML('<gml:Surface><gml:patches><gml:PolygonPatch><gml:exterior><gml:LinearRing><gml:posList dimension="2">1 2 3 4 5 6 1 2</gml:posList></gml:LinearRing></gml:exterior><gml:interior><gml:LinearRing><gml:posList dimension="3">7 8 9 10 11 12 13 14 15 7 8 9</gml:posList></gml:LinearRing></gml:interior></gml:PolygonPatch></gml:patches></gml:Surface>'));

-- ERROR: two patches
SELECT 'surface_18', ST_AsEWKT(ST_GeomFromGML('<gml:Surface><gml:patches><gml:PolygonPatch><gml:exterior><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:exterior></gml:PolygonPatch><gml:PolygonPatch><gml:exterior><gml:LinearRing><gml:coordinates>7,8 9,10 11,12 7,8</gml:coordinates></gml:LinearRing></gml:exterior></gml:PolygonPatch></gml:patches></gml:Surface>'));

-- planar interpolation
SELECT 'surface_19', ST_AsEWKT(ST_GeomFromGML('<gml:Surface><gml:patches><gml:PolygonPatch interpolation="planar"><gml:exterior><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:exterior></gml:PolygonPatch></gml:patches></gml:Surface>'));

-- ERROR: interpolation not planar
SELECT 'surface_20', ST_AsEWKT(ST_GeomFromGML('<gml:Surface><gml:patches><gml:PolygonPatch interpolation="not_planar"><gml:exterior><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:exterior></gml:PolygonPatch></gml:patches></gml:Surface>'));




--
-- MultiPoint
--

-- 1 point
SELECT 'mpoint_1', ST_AsEWKT(ST_GeomFromGML('<gml:MultiPoint><gml:pointMember><gml:Point><gml:coordinates>1,2</gml:coordinates></gml:Point></gml:pointMember></gml:MultiPoint>'));

-- 2 points
SELECT 'mpoint_2', ST_AsEWKT(ST_GeomFromGML('<gml:MultiPoint><gml:pointMember><gml:Point><gml:coordinates>1,2</gml:coordinates></gml:Point></gml:pointMember><gml:pointMember><gml:Point><gml:coordinates>3,4</gml:coordinates></gml:Point></gml:pointMember></gml:MultiPoint>'));

-- srsName handle
SELECT 'mpoint_3', ST_AsEWKT(ST_GeomFromGML('<gml:MultiPoint srsName="EPSG:4326"><gml:pointMember><gml:Point><gml:coordinates>1,2</gml:coordinates></gml:Point></gml:pointMember></gml:MultiPoint>'));

-- Empty MultiPoints 
SELECT 'mpoint_4', ST_AsEWKT(ST_GeomFromGML('<gml:MultiPoint><gml:pointMember></gml:pointMember></gml:MultiPoint>'));
SELECT 'mpoint_5', ST_AsEWKT(ST_GeomFromGML('<gml:MultiPoint></gml:MultiPoint>'));

-- XML not elements handle
SELECT 'mpoint_6', ST_AsEWKT(ST_GeomFromGML(' <!-- --> <gml:MultiPoint> <!-- --> <gml:pointMember> <!-- --> <gml:Point> <!-- --> <gml:coordinates>1,2</gml:coordinates></gml:Point></gml:pointMember> <!-- --> <gml:pointMember> <!-- --> <gml:Point> <!-- --> <gml:coordinates>3,4</gml:coordinates></gml:Point></gml:pointMember></gml:MultiPoint>'));

-- TODO Mixed srsName




--
-- MultiLineString
--

-- 1 line
SELECT 'mline_1', ST_AsEWKT(ST_GeomFromGML('<gml:MultiLineString><gml:lineStringMember><gml:LineString><gml:coordinates>1,2 3,4</gml:coordinates></gml:LineString></gml:lineStringMember></gml:MultiLineString>'));

-- 2 lines
SELECT 'mline_2', ST_AsEWKT(ST_GeomFromGML('<gml:MultiLineString><gml:lineStringMember><gml:LineString><gml:coordinates>1,2 3,4</gml:coordinates></gml:LineString></gml:lineStringMember><gml:lineStringMember><gml:LineString><gml:coordinates>5,6 7,8</gml:coordinates></gml:LineString></gml:lineStringMember></gml:MultiLineString>'));

-- srsName handle
SELECT 'mline_3', ST_AsEWKT(ST_GeomFromGML('<gml:MultiLineString srsName="EPSG:4326"><gml:lineStringMember><gml:LineString><gml:coordinates>1,2 3,4</gml:coordinates></gml:LineString></gml:lineStringMember></gml:MultiLineString>'));

-- Empty MultiLineString
SELECT 'mline_4', ST_AsEWKT(ST_GeomFromGML('<gml:MultiLineString><gml:lineStringMember></gml:lineStringMember></gml:MultiLineString>'));
SELECT 'mline_5', ST_AsEWKT(ST_GeomFromGML('<gml:MultiLineString></gml:MultiLineString>'));

-- XML not elements handle
SELECT 'mline_6', ST_AsEWKT(ST_GeomFromGML(' <!-- --> <gml:MultiLineString> <!-- --> <gml:lineStringMember> <!-- --> <gml:LineString> <!-- --> <gml:coordinates>1,2 3,4</gml:coordinates></gml:LineString></gml:lineStringMember> <!-- --> <gml:lineStringMember> <!-- --> <gml:LineString> <!-- --> <gml:coordinates>5,6 7,8</gml:coordinates></gml:LineString></gml:lineStringMember></gml:MultiLineString>'));

-- Mixed dimension
SELECT 'mline_7', ST_AsEWKT(ST_GeomFromGML('<gml:MultiLineString><gml:lineStringMember><gml:LineString><gml:posList dimension="3">1 2 3 4 5 6</gml:posList></gml:LineString></gml:lineStringMember><gml:lineStringMember><gml:LineString><gml:posList dimension="2">7 8 9 10</gml:posList></gml:LineString></gml:lineStringMember></gml:MultiLineString>'));
SELECT 'mline_8', ST_AsEWKT(ST_GeomFromGML('<gml:MultiLineString><gml:lineStringMember><gml:LineString><gml:posList dimension="2">1 2 3 4</gml:posList></gml:LineString></gml:lineStringMember><gml:lineStringMember><gml:LineString><gml:posList dimension="3">5 6 7 8 9 10</gml:posList></gml:LineString></gml:lineStringMember></gml:MultiLineString>'));

-- TODO Mixed srsName




--
-- MultiCurve
--

-- 1 curve
SELECT 'mcurve_1', ST_AsEWKT(ST_GeomFromGML('<gml:MultiCurve><gml:curveMember><gml:Curve><gml:segments><gml:LineStringSegment><gml:posList>1 2 3 4</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve></gml:curveMember></gml:MultiCurve>'));

-- 2 curves
SELECT 'mcurve_2', ST_AsEWKT(ST_GeomFromGML('<gml:MultiCurve><gml:curveMember><gml:Curve><gml:segments><gml:LineStringSegment><gml:posList>1 2 3 4</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve></gml:curveMember><gml:curveMember><gml:Curve><gml:segments><gml:LineStringSegment><gml:posList>5 6 7 8</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve></gml:curveMember></gml:MultiCurve>'));

-- srsName handle
SELECT 'mcurve_3', ST_AsEWKT(ST_GeomFromGML('<gml:MultiCurve srsName="EPSG:4326"><gml:curveMember><gml:Curve><gml:segments><gml:LineStringSegment><gml:posList>1 2 3 4</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve></gml:curveMember></gml:MultiCurve>'));

-- Empty Curve 
SELECT 'mcurve_4', ST_AsEWKT(ST_GeomFromGML('<gml:MultiCurve><gml:curveMember></gml:curveMember></gml:MultiCurve>'));
SELECT 'mcurve_5', ST_AsEWKT(ST_GeomFromGML('<gml:MultiCurve></gml:MultiCurve>'));

-- XML not elements handle
SELECT 'mcurve_6', ST_AsEWKT(ST_GeomFromGML(' <!-- --> <gml:MultiCurve> <!-- --> <gml:curveMember> <!-- --> <gml:Curve> <!-- --> <gml:segments> <!-- --> <gml:LineStringSegment> <!-- --> <gml:posList>1 2 3 4</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve></gml:curveMember> <!-- --> <gml:curveMember> <!-- --> <gml:Curve> <!-- --> <gml:segments> <!-- --> <gml:LineStringSegment><gml:posList>5 6 7 8</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve></gml:curveMember></gml:MultiCurve>'));

-- Mixed dimension
SELECT 'mcurve_7', ST_AsEWKT(ST_GeomFromGML('<gml:MultiCurve><gml:curveMember><gml:Curve><gml:segments><gml:LineStringSegment><gml:posList dimension="3">1 2 3 4 5 6</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve></gml:curveMember><gml:curveMember><gml:Curve><gml:segments><gml:LineStringSegment><gml:posList dimension="2">7 8 9 10</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve></gml:curveMember></gml:MultiCurve>'));
SELECT 'mcurve_8', ST_AsEWKT(ST_GeomFromGML('<gml:MultiCurve><gml:curveMember><gml:Curve><gml:segments><gml:LineStringSegment><gml:posList dimension="2">1 2 3 4</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve></gml:curveMember><gml:curveMember><gml:Curve><gml:segments><gml:LineStringSegment><gml:posList dimension="3">5 6 7 8 9 10</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve></gml:curveMember></gml:MultiCurve>'));

-- TODO Mixed srsName



--
-- MultiPolygon
--

-- 1 polygon
SELECT 'mpoly_1', ST_AsEWKT(ST_GeomFromGML('<gml:MultiPolygon><gml:polygonMember><gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></gml:polygonMember></gml:MultiPolygon>'));

-- 2 polygons
SELECT 'mpoly_2', ST_AsEWKT(ST_GeomFromGML('<gml:MultiPolygon><gml:polygonMember><gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></gml:polygonMember><gml:polygonMember><gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates>7,8 9,10 11,12 7,8</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></gml:polygonMember></gml:MultiPolygon>'));

-- srsName handle
SELECT 'mpoly_3', ST_AsEWKT(ST_GeomFromGML('<gml:MultiPolygon srsName="EPSG:4326"><gml:polygonMember><gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></gml:polygonMember></gml:MultiPolygon>'));

-- Empty MultiPolygon
SELECT 'mpoly_4', ST_AsEWKT(ST_GeomFromGML('<gml:MultiPolygon><gml:polygonMember></gml:polygonMember></gml:MultiPolygon>'));
SELECT 'mpoly_5', ST_AsEWKT(ST_GeomFromGML('<gml:MultiPolygon></gml:MultiPolygon>'));


-- XML not elements handle
SELECT 'mpoly_6', ST_AsEWKT(ST_GeomFromGML(' <!-- --> <gml:MultiPolygon> <!-- --> <gml:polygonMember> <!-- --> <gml:Polygon> <!-- --> <gml:outerBoundaryIs> <!-- --> <gml:LinearRing> <!-- --> <gml:coordinates>1,2 3,4 5,6 1,2</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></gml:polygonMember> <!-- --> <gml:polygonMember> <!-- --> <gml:Polygon> <!-- --> <gml:outerBoundaryIs> <!-- --> <gml:LinearRing> <!-- --> <gml:coordinates>7,8 9,10 11,12 7,8</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></gml:polygonMember></gml:MultiPolygon>'));

-- Mixed dimension
SELECT 'mpoly_7', ST_AsEWKT(ST_GeomFromGML('<gml:MultiPolygon><gml:polygonMember><gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:posList dimension="3">1 2 3 4 5 6 7 8 9 1 2 3</gml:posList></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></gml:polygonMember><gml:polygonMember><gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:posList dimension="2">10 11 12 13 14 15 10 11</gml:posList></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></gml:polygonMember></gml:MultiPolygon>'));
SELECT 'mpoly_8', ST_AsEWKT(ST_GeomFromGML('<gml:MultiPolygon><gml:polygonMember><gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:posList dimension="2">1 2 3 4 5 6 1 2</gml:posList></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></gml:polygonMember><gml:polygonMember><gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:posList dimension="3">7 8 9 10 11 12 13 14 15 7 8 9</gml:posList></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></gml:polygonMember></gml:MultiPolygon>'));

-- TODO Mixed srsName




--
-- MultiSurface
--

-- 1 surface
SELECT 'msurface_1', ST_AsEWKT(ST_GeomFromGML('<gml:MultiSurface><gml:surfaceMember><gml:Polygon><gml:exterior><gml:LinearRing><gml:posList>1 2 3 4 5 6 1 2</gml:posList></gml:LinearRing></gml:exterior></gml:Polygon></gml:surfaceMember></gml:MultiSurface>'));

-- 2 surfaces
SELECT 'msurface_2', ST_AsEWKT(ST_GeomFromGML('<gml:MultiSurface><gml:surfaceMember><gml:Polygon><gml:exterior><gml:LinearRing><gml:posList>1 2 3 4 5 6 1 2</gml:posList></gml:LinearRing></gml:exterior></gml:Polygon></gml:surfaceMember><gml:surfaceMember><gml:Polygon><gml:exterior><gml:LinearRing><gml:posList>7 8 9 10 11 12 7 8</gml:posList></gml:LinearRing></gml:exterior></gml:Polygon></gml:surfaceMember></gml:MultiSurface>'));

-- srsName handle
SELECT 'msurface_3', ST_AsEWKT(ST_GeomFromGML('<gml:MultiSurface srsName="EPSG:4326"><gml:surfaceMember><gml:Polygon><gml:exterior><gml:LinearRing><gml:posList>1 2 3 4 5 6 1 2</gml:posList></gml:LinearRing></gml:exterior></gml:Polygon></gml:surfaceMember></gml:MultiSurface>'));

-- Empty MultiSurface 
SELECT 'msurface_4', ST_AsEWKT(ST_GeomFromGML('<gml:MultiSurface><gml:surfaceMember></gml:surfaceMember></gml:MultiSurface>'));
SELECT 'msurface_5', ST_AsEWKT(ST_GeomFromGML('<gml:MultiSurface></gml:MultiSurface>'));

-- XML not elements handle
SELECT 'msurface_6', ST_AsEWKT(ST_GeomFromGML(' <!-- --> <gml:MultiSurface> <!-- --> <gml:surfaceMember> <!-- --> <gml:Polygon> <!-- --> <gml:exterior> <!-- --> <gml:LinearRing> <!-- --> <gml:posList>1 2 3 4 5 6 1 2</gml:posList></gml:LinearRing></gml:exterior> <!-- --> </gml:Polygon> <!-- --> </gml:surfaceMember> <!-- --> <gml:surfaceMember> <!-- --> <gml:Polygon><gml:exterior><gml:LinearRing><gml:posList>7 8 9 10 11 12 7 8</gml:posList></gml:LinearRing></gml:exterior></gml:Polygon></gml:surfaceMember></gml:MultiSurface>'));

-- Mixed dimension
SELECT 'msurface_7', ST_AsEWKT(ST_GeomFromGML('<gml:MultiSurface><gml:surfaceMember><gml:Polygon><gml:exterior><gml:LinearRing><gml:posList dimension="3">1 2 3 4 5 6 7 8 9 1 2 3</gml:posList></gml:LinearRing></gml:exterior></gml:Polygon></gml:surfaceMember><gml:surfaceMember><gml:Polygon><gml:exterior><gml:LinearRing><gml:posList dimension="2">10 11 12 13 14 15 10 11</gml:posList></gml:LinearRing></gml:exterior></gml:Polygon></gml:surfaceMember></gml:MultiSurface>'));
SELECT 'msurface_8', ST_AsEWKT(ST_GeomFromGML('<gml:MultiSurface><gml:surfaceMember><gml:Polygon><gml:exterior><gml:LinearRing><gml:posList dimension="2">1 2 3 4 5 6 1 2</gml:posList></gml:LinearRing></gml:exterior></gml:Polygon></gml:surfaceMember><gml:surfaceMember><gml:Polygon><gml:exterior><gml:LinearRing><gml:posList dimension="3">7 8 9 10 11 12 13 14 15 7 8 9</gml:posList></gml:LinearRing></gml:exterior></gml:Polygon></gml:surfaceMember></gml:MultiSurface>'));

-- TODO Mixed srsName



--
-- GeometryCollection
--

-- 1 simple geom 
SELECT 'collection_1', ST_AsEWKT(ST_GeomFromGML('<gml:MultiGeometry><gml:pointMember><gml:Point><gml:coordinates>1,2</gml:coordinates></gml:Point></gml:pointMember></gml:MultiGeometry>'));

-- 2 simples geom
SELECT 'collection_2', ST_AsEWKT(ST_GeomFromGML('<gml:MultiGeometry><gml:pointMember><gml:Point><gml:pos>1 2</gml:pos></gml:Point></gml:pointMember><gml:curveMember><gml:Curve><gml:segments><gml:LineStringSegment><gml:posList>3 4 5 6</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve></gml:curveMember></gml:MultiGeometry>'));

-- 1 multi geom 
SELECT 'collection_3', ST_AsEWKT(ST_GeomFromGML('<gml:MultiGeometry><gml:MultiPoint><gml:pointMember><gml:Point><gml:pos>1 2</gml:pos></gml:Point></gml:pointMember><gml:pointMember><gml:Point><gml:pos>3 4</gml:pos></gml:Point></gml:pointMember></gml:MultiPoint></gml:MultiGeometry>'));

-- 2 multi geom 
SELECT 'collection_4', ST_AsEWKT(ST_GeomFromGML('<gml:MultiGeometry><gml:MultiPoint><gml:pointMember><gml:Point><gml:pos>1 2</gml:pos></gml:Point></gml:pointMember><gml:pointMember><gml:Point><gml:pos>3 4</gml:pos></gml:Point></gml:pointMember></gml:MultiPoint><gml:MultiCurve><gml:curveMember><gml:Curve><gml:segments><gml:LineStringSegment><gml:posList>5 6 7 8</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve></gml:curveMember><gml:curveMember><gml:Curve><gml:segments><gml:LineStringSegment><gml:posList>9 10 11 12</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve></gml:curveMember></gml:MultiCurve></gml:MultiGeometry>'));

-- 2 multi geom and 2 simples
SELECT 'collection_5', ST_AsEWKT(ST_GeomFromGML('<gml:MultiGeometry><gml:MultiPoint><gml:pointMember><gml:Point><gml:pos>1 2</gml:pos></gml:Point></gml:pointMember><gml:pointMember><gml:Point><gml:pos>3 4</gml:pos></gml:Point></gml:pointMember></gml:MultiPoint><gml:pointMember><gml:Point><gml:pos>5 6</gml:pos></gml:Point></gml:pointMember><gml:MultiCurve><gml:curveMember><gml:Curve><gml:segments><gml:LineStringSegment><gml:posList>7 8 9 10</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve></gml:curveMember><gml:curveMember><gml:Curve><gml:segments><gml:LineStringSegment><gml:posList>11 12 13 14</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve></gml:curveMember></gml:MultiCurve><gml:surfaceMember><gml:Polygon><gml:exterior><gml:LinearRing><gml:posList>15 16 17 18 19 20 15 16</gml:posList></gml:LinearRing></gml:exterior></gml:Polygon></gml:surfaceMember></gml:MultiGeometry>'));

-- Empty collection
SELECT 'collection_6', ST_AsEWKT(ST_GeomFromGML('<gml:MultiGeometry><gml:pointMember></gml:pointMember></gml:MultiGeometry>'));
SELECT 'collection_7', ST_AsEWKT(ST_GeomFromGML('<gml:MultiGeometry></gml:MultiGeometry>'));

-- Collection of collection
SELECT 'collection_8', ST_AsEWKT(ST_GeomFromGML('<gml:MultiGeometry><gml:pointMember><gml:Point><gml:coordinates>1,2</gml:coordinates></gml:Point></gml:pointMember><gml:MultiGeometry><gml:pointMember><gml:Point><gml:coordinates>3,4</gml:coordinates></gml:Point></gml:pointMember></gml:MultiGeometry></gml:MultiGeometry>'));

-- Collection of collection of collection
SELECT 'collection_9', ST_AsEWKT(ST_GeomFromGML('<gml:MultiGeometry><gml:pointMember><gml:Point><gml:coordinates>1,2</gml:coordinates></gml:Point></gml:pointMember><gml:MultiGeometry><gml:MultiGeometry><gml:pointMember><gml:Point><gml:coordinates>3,4</gml:coordinates></gml:Point></gml:pointMember></gml:MultiGeometry></gml:MultiGeometry></gml:MultiGeometry>'));

-- srsName handle
SELECT 'collection_10', ST_AsEWKT(ST_GeomFromGML('<gml:MultiGeometry srsName="EPSG:4326"><gml:pointMember><gml:Point><gml:coordinates>1,2</gml:coordinates></gml:Point></gml:pointMember></gml:MultiGeometry>'));

-- XML not elements handle
SELECT 'collection_11', ST_AsEWKT(ST_GeomFromGML(' <!-- --> <gml:MultiGeometry> <!-- --> <gml:pointMember> <!-- --> <gml:Point> <!-- --> <gml:coordinates>1,2</gml:coordinates></gml:Point></gml:pointMember> <!-- --> <gml:MultiGeometry> <!-- --> <gml:MultiGeometry> <!-- --> <gml:pointMember> <!-- --> <gml:Point> <!-- --> <gml:coordinates>3,4</gml:coordinates></gml:Point></gml:pointMember></gml:MultiGeometry></gml:MultiGeometry></gml:MultiGeometry>'));

-- Mixed dimension
SELECT 'collection_12', ST_AsEWKT(ST_GeomFromGML('<gml:MultiGeometry><gml:pointMember><gml:Point><gml:pos dimension="3">1 2 3</gml:pos></gml:Point></gml:pointMember><gml:MultiGeometry><gml:MultiGeometry><gml:pointMember><gml:Point><gml:pos dimension="2">4 5</gml:pos></gml:Point></gml:pointMember></gml:MultiGeometry></gml:MultiGeometry></gml:MultiGeometry>'));
SELECT 'collection_13', ST_AsEWKT(ST_GeomFromGML('<gml:MultiGeometry><gml:pointMember><gml:Point><gml:pos dimension="2">1 2</gml:pos></gml:Point></gml:pointMember><gml:MultiGeometry><gml:MultiGeometry><gml:pointMember><gml:Point><gml:pos dimension="3">3 4 5</gml:pos></gml:Point></gml:pointMember></gml:MultiGeometry></gml:MultiGeometry></gml:MultiGeometry>'));

-- TODO Mixed srsName





--
-- srsName
--

-- Supported srsName patterns
SELECT 'srs_1', ST_AsEWKT(ST_GeomFromGML('<gml:Point srsName="EPSG:4326"><gml:pos>1 2</gml:pos></gml:Point>'));
SELECT 'srs_2', ST_AsEWKT(ST_GeomFromGML('<gml:Point srsName="urn:EPSG:geographicCRS:4326"><gml:pos>1 2</gml:pos></gml:Point>'));
SELECT 'srs_3', ST_AsEWKT(ST_GeomFromGML('<gml:Point srsName="urn:ogc:def:crs:EPSG:4326"><gml:pos>1 2</gml:pos></gml:Point>'));
SELECT 'srs_4', ST_AsEWKT(ST_GeomFromGML('<gml:Point srsName="urn:ogc:def:crs:EPSG:4326"><gml:pos>1 2</gml:pos></gml:Point>'));
SELECT 'srs_5', ST_AsEWKT(ST_GeomFromGML('<gml:Point srsName="urn:ogc:def:crs:EPSG::4326"><gml:pos>1 2</gml:pos></gml:Point>'));
SELECT 'srs_6', ST_AsEWKT(ST_GeomFromGML('<gml:Point srsName="urn:ogc:def:crs:EPSG:6.6:4326"><gml:pos>1 2</gml:pos></gml:Point>'));
SELECT 'srs_7', ST_AsEWKT(ST_GeomFromGML('<gml:Point srsName="urn:x-ogc:def:crs:EPSG:6.6:4326"><gml:pos>1 2</gml:pos></gml:Point>'));
SELECT 'srs_8', ST_AsEWKT(ST_GeomFromGML('<gml:Point srsName="http://www.opengis.net/gml/srs/epsg.xml#4326"><gml:pos>1 2</gml:pos></gml:Point>'));

-- ERROR not a valid pattern
SELECT 'srs_9', ST_AsEWKT(ST_GeomFromGML('<gml:Point srsName="a:wrong:pattern:4326"><gml:pos>1 2</gml:pos></gml:Point>'));

-- ERROR: not a defined SRID
SELECT 'srs_10', ST_AsEWKT(ST_GeomFromGML('<gml:Point srsName="EPSG:01"><gml:pos>1 2</gml:pos></gml:Point>'));

-- ERROR: SRID is not an int
SELECT 'srs_11', ST_AsEWKT(ST_GeomFromGML('<gml:Point srsName="EPSG:abc"><gml:pos>1 2</gml:pos></gml:Point>'));

-- ERROR: SRID is not only int
SELECT 'srs_12', ST_AsEWKT(ST_GeomFromGML('<gml:Point srsName="EPSG:4326abc"><gml:pos>1 2</gml:pos></gml:Point>'));
SELECT 'srs_13', ST_AsEWKT(ST_GeomFromGML('<gml:Point srsName="EPSG:abc4326"><gml:pos>1 2</gml:pos></gml:Point>'));

-- ERROR: srsName empty
SELECT 'srs_14', ST_AsEWKT(ST_GeomFromGML('<gml:Point srsName="EPSG:"><gml:pos>1 2</gml:pos></gml:Point>'));
SELECT 'srs_15', ST_AsEWKT(ST_GeomFromGML('<gml:Point srsName=""><gml:pos>1 2</gml:pos></gml:Point>'));

-- ERROR: srsName is defined as -1
SELECT 'srs_16', ST_AsEWKT(ST_GeomFromGML('<gml:Point srsName="EPSG:-1"><gml:pos>1 2</gml:pos></gml:Point>'));



--
-- TODO GML Namespace
-- 

--
-- TODO xlink/Reference 
-- 


--
-- Coordinates (simple)
--

-- X,Y
SELECT 'coordinates_1', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coordinates>1,2</gml:coordinates></gml:Point>'));

-- ERROR: single X
SELECT 'coordinates_2', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coordinates>1</gml:coordinates></gml:Point>'));

-- X,Y,Z
SELECT 'coordinates_3', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coordinates>1,2,3</gml:coordinates></gml:Point>'));

-- ERROR: 4 dimension
SELECT 'coordinates_4', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coordinates>1,2,3,4</gml:coordinates></gml:Point>'));

-- ERROR: Only commas
SELECT 'coordinates_5', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coordinates>,</gml:coordinates></gml:Point>'));
SELECT 'coordinates_6', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coordinates> , </gml:coordinates></gml:Point>'));

-- ERROR: empty or spaces
SELECT 'coordinates_7', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coordinates></gml:coordinates></gml:Point>'));
SELECT 'coordinates_8', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coordinates>  </gml:coordinates></gml:Point>'));

-- ERROR: End on comma
SELECT 'coordinates_9', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coordinates>1,2,3,</gml:coordinates></gml:Point>'));
SELECT 'coordinates_10', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coordinates>1,2,</gml:coordinates></gml:Point>'));

-- ERROR: Begin on comma
SELECT 'coordinates_11', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates>,1 2,3</gml:coordinates></gml:LineString>'));

-- Whitespaces before and after 
SELECT 'coordinates_12', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates> 1,2 3,4 </gml:coordinates></gml:LineString>'));
SELECT 'coordinates_13', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates> 
								1,2 3,4  
						   </gml:coordinates></gml:LineString>'));

-- Mixed dimension
SELECT 'coordinates_14', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates>1,2,3 4,5</gml:coordinates></gml:LineString>'));

-- ERROR: Spaces insides 
SELECT 'coordinates_15', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates>1, 2 3, 4</gml:coordinates></gml:LineString>'));
SELECT 'coordinates_16', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates>1,2  3,4</gml:coordinates></gml:LineString>'));

-- ERROR: Junk
SELECT 'coordinates_17', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates>!@#$%^*()"</gml:coordinates></gml:LineString>'));




--
-- Coordinates (cs,ts,decimal)
--

-- Specify default CS separator
SELECT 'coordinates_cs_1', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coordinates cs="," >1,2</gml:coordinates></gml:Point>'));

-- ERROR: wrong CS separator 
SELECT 'coordinates_cs_2', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coordinates cs=";" >1,2</gml:coordinates></gml:Point>'));

-- Specify a CS separator
SELECT 'coordinates_cs_3', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coordinates cs=";" >1;2</gml:coordinates></gml:Point>'));

-- ERROR: CS separator is a number
SELECT 'coordinates_cs_4', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coordinates cs="0" >102</gml:coordinates></gml:Point>'));

-- ERROR: CS separator is multichar 
SELECT 'coordinates_cs_5', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coordinates cs="||" >1||2</gml:coordinates></gml:Point>'));

-- Specify default TS separator
SELECT 'coordinates_cs_6', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates ts=" ">1,2 3,4</gml:coordinates></gml:LineString>'));

-- ERROR: wrong TS separator 
SELECT 'coordinates_cs_7', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates ts=" ">1,2;3,4</gml:coordinates></gml:LineString>'));

-- Specify a TS separator
SELECT 'coordinates_cs_8', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates ts=";">1,2;3,4</gml:coordinates></gml:LineString>'));

-- ERROR: TS separator is a number
SELECT 'coordinates_cs_9', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates ts="0">1,203,4</gml:coordinates></gml:LineString>'));

-- ERROR: TS separator is multichar 
SELECT 'coordinates_cs_10', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates ts="||">1,2||3,4</gml:coordinates></gml:LineString>'));

-- Specify default Decimal separator
SELECT 'coordinates_cs_11', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates decimal=".">1.1,2.2 3.3,4.4</gml:coordinates></gml:LineString>'));

-- ERROR: wrong Decimal separator 
SELECT 'coordinates_cs_12', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates decimal=";">1;1,2;2 3;3,4;4</gml:coordinates></gml:LineString>'));

-- ERROR: Decimal separator is a number
SELECT 'coordinates_cs_13', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates decimal="0">101,202 303,404</gml:coordinates></gml:LineString>'));

-- ERROR: Decimal separator is multichar 
SELECT 'coordinates_cs_14', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates decimal="||">1||1,2||2 3||3,4||4</gml:coordinates></gml:LineString>'));

-- CS and TS and Decimal together
SELECT 'coordinates_cs_15', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates cs="." ts=";" decimal=",">1,1.2,2;3,3.4,4</gml:coordinates></gml:LineString>'));

-- ERROR: CS and Decimal are the same
SELECT 'coordinates_cs_16', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates ts=" " cs=" ">1 2 3 4</gml:coordinates></gml:LineString>'));
SELECT 'coordinates_cs_17', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates cs="." ts=";" decimal=".">1.1.2.2;3.3.4,4</gml:coordinates></gml:LineString>'));
SELECT 'coordinates_cs_18', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates cs="." ts=";" decimal=";">1;1.2;2;3;3.4,4</gml:coordinates></gml:LineString>'));


-- XML Entity substitution
SELECT 'coordinates_cs_19', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coordinates ts="," cs="&#x20;">1 2,3 4</gml:coordinates></gml:LineString>'));




--
-- pos
--

-- X,Y
SELECT 'pos_1', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 2</gml:pos></gml:Point>'));

-- ERROR: single X
SELECT 'pos_2', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1</gml:pos></gml:Point>'));

-- ERROR: X,Y,Z but without explicit dimension
SELECT 'pos_3', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 2 3</gml:pos></gml:Point>'));

-- ERROR: 4 dimension
SELECT 'pos_4', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 2 3 4</gml:pos></gml:Point>'));

-- ERROR: empty or spaces
SELECT 'pos_5', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos></gml:pos></gml:Point>'));
SELECT 'pos_6', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos> </gml:pos></gml:Point>'));
SELECT 'pos_7', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>  </gml:pos></gml:Point>'));

-- Whitespaces before and after 
SELECT 'pos_8', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos> 1 2 </gml:pos></gml:Point>'));
SELECT 'pos_9', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>  1 2  </gml:pos></gml:Point>'));
SELECT 'pos_10', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos> 
		 			         1 2
				           </gml:pos></gml:Point>'));
-- ERROR: Several Spaces insides 
SELECT 'pos_11', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1  2</gml:pos></gml:Point>'));

-- ERROR: Junk
SELECT 'pos_12', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>@!#$#%</gml:pos></gml:Point>'));

-- ERROR: 1 dimension
SELECT 'pos_13', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos dimension="1">1</gml:pos></gml:Point>'));

-- 2 Dimensions explicit
SELECT 'pos_14', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos dimension="2">1 2</gml:pos></gml:Point>'));

-- ERROR: 2 Dimensions explicit but 3 dims
SELECT 'pos_15', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos dimension="2">1 2 3</gml:pos></gml:Point>'));

-- 3 Dimensions explicit
SELECT 'pos_16', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos dimension="3">1 2 3</gml:pos></gml:Point>'));

-- ERROR: 4 dimensions
SELECT 'pos_17', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos dimension="4">1 2 3 4</gml:pos></gml:Point>'));


--
-- posList
--
-- 2 coords
SELECT 'poslist_1', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList>1 2 3 4</gml:posList></gml:LineString>'));

-- spaces before and after
SELECT 'poslist_2', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList> 1 2 3 4 </gml:posList></gml:LineString>'));
SELECT 'poslist_3', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList>  1 2 3 4  </gml:posList></gml:LineString>'));
SELECT 'poslist_4', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList>
	      						1 2 3 4  
						</gml:posList></gml:LineString>'));

-- explicit 2 dimension
SELECT 'poslist_5', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList dimension="2">1 2 3 4</gml:posList></gml:LineString>'));
-- ERROR: wrong dimension
SELECT 'poslist_6', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList> 1 2 3 4 5 </gml:posList></gml:LineString>'));
SELECT 'poslist_7', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList dimension="2">1 2 3 4 5</gml:posList></gml:LineString>'));

-- 2 coord 3D
SELECT 'poslist_8', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList dimension="3">1 2 3 4 5 6</gml:posList></gml:LineString>'));

-- ERROR: 1 dimension
SELECT 'poslist_9', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList>1</gml:posList></gml:LineString>'));
SELECT 'poslist_10', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList dimension="1">1</gml:posList></gml:LineString>'));

-- ERROR: 4 dimensions
SELECT 'poslist_11', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList dimension="4">1 2 3 4 5 6 7 8</gml:posList></gml:LineString>'));

-- ERROR: 3D but no explicit dimension
SELECT 'poslist_12', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList>1 2 3</gml:posList></gml:LineString>'));

-- ERROR: empty or spaces
SELECT 'poslist_13', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList></gml:posList></gml:LineString>'));
SELECT 'poslist_14', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList> </gml:posList></gml:LineString>'));
SELECT 'poslist_15', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList>  </gml:posList></gml:LineString>'));

-- ERROR: spaces insides posList
SELECT 'poslist_16', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList>1 2  3 4</gml:posList></gml:LineString>'));
SELECT 'poslist_17', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList> 1  2  3 4 </gml:posList></gml:LineString>'));

-- ERROR: Junk
SELECT 'poslist_18', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:posList>!@#$%^*()"</gml:posList></gml:LineString>'));





--
-- coord
--

-- X,Y
SELECT 'coord_1', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coord><gml:X>1</gml:X><gml:Y>2</gml:Y></gml:coord></gml:Point>'));

-- X,Y,Z
SELECT 'coord_2', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coord><gml:X>1</gml:X><gml:Y>2</gml:Y><gml:Z>3</gml:Z></gml:coord></gml:Point>'));

-- ERROR no X or Y
SELECT 'coord_3', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coord><gml:X>1</gml:X><gml:Z>2</gml:Z></gml:coord></gml:Point>'));
SELECT 'coord_4', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coord><gml:Y>1</gml:Y><gml:Z>2</gml:Z></gml:coord></gml:Point>'));
SELECT 'coord_5', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coord><gml:Z>1</gml:Z></gml:coord></gml:Point>'));

-- ERROR empty coord even if defined
SELECT 'coord_6', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coord><gml:X></gml:X><gml:Y></gml:Y></gml:coord></gml:Point>'));
SELECT 'coord_7', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coord></gml:coord></gml:Point>'));

-- ERROR space in coord 
SELECT 'coord_8', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coord><gml:X>1</gml:X><gml:Y> </gml:Y></gml:coord></gml:Point>'));
SELECT 'coord_9', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coord><gml:X>1</gml:X><gml:Y>   </gml:Y></gml:coord></gml:Point>'));

-- Spaces before and after coord
SELECT 'coord_10', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coord><gml:X>1</gml:X><gml:Y> 2 </gml:Y></gml:coord></gml:Point>'));
SELECT 'coord_11', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coord><gml:X>1</gml:X><gml:Y>  2  </gml:Y></gml:coord></gml:Point>'));
SELECT 'coord_12', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:coord><gml:X>1</gml:X><gml:Y>  
	                  				2   
					     </gml:Y></gml:coord></gml:Point>'));

-- Several coords
SELECT 'coord_13', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coord><gml:X>1</gml:X><gml:Y>2</gml:Y></gml:coord><gml:coord><gml:X>3</gml:X><gml:Y>4</gml:Y></gml:coord></gml:LineString>'));

-- Several coords mixed dimension
SELECT 'coord_14', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coord><gml:X>1</gml:X><gml:Y>2</gml:Y><gml:Z>3</gml:Z></gml:coord><gml:coord><gml:X>4</gml:X><gml:Y>5</gml:Y></gml:coord></gml:LineString>'));
SELECT 'coord_15', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coord><gml:X>1</gml:X><gml:Y>2</gml:Y></gml:coord><gml:coord><gml:X>3</gml:X><gml:Y>4</gml:Y><gml:Z>5</gml:Z></gml:coord></gml:LineString>'));

-- XML not elements handle
SELECT 'coord_16', ST_AsEWKT(ST_GeomFromGML('<gml:LineString><gml:coord> <!-- --> <gml:X>1</gml:X> <!-- --> <gml:Y>2</gml:Y> <!-- --> </gml:coord> <!-- --> <gml:coord> <!-- --> <gml:X>3</gml:X> <!-- --> <gml:Y>4</gml:Y></gml:coord></gml:LineString>'));


--
-- Double
--

-- Several digits
SELECT 'double_1', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1234567890</gml:pos></gml:Point>'));

-- Sign +/- 
SELECT 'double_2', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 -1</gml:pos></gml:Point>'));
SELECT 'double_3', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 +1</gml:pos></gml:Point>'));

-- ERROR: double sign
SELECT 'double_4', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 --1</gml:pos></gml:Point>'));

-- ERROR: sign inside digit
SELECT 'double_5', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1-1</gml:pos></gml:Point>'));

-- Decimal part
SELECT 'double_6', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1.2</gml:pos></gml:Point>'));
SELECT 'double_7', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1.23</gml:pos></gml:Point>'));

-- ERROR: no digit after dot
SELECT 'double_8', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1.</gml:pos></gml:Point>'));

-- ERROR: several dots
SELECT 'double_9', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1.2.3</gml:pos></gml:Point>'));

-- ERROR: no digit before dot
SELECT 'double_10', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 .1</gml:pos></gml:Point>'));
SELECT 'double_11', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 -.1</gml:pos></gml:Point>'));

-- ERROR: not a digit
SELECT 'double_12', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 a</gml:pos></gml:Point>'));
SELECT 'double_13', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1a</gml:pos></gml:Point>'));
SELECT 'double_14', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1a2</gml:pos></gml:Point>'));

-- Exp 
SELECT 'double_15', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1e2</gml:pos></gml:Point>'));
SELECT 'double_16', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1E+2</gml:pos></gml:Point>'));
SELECT 'double_17', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1e-2</gml:pos></gml:Point>'));
SELECT 'double_18', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1E-2</gml:pos></gml:Point>'));

-- Exp with decimal parts
SELECT 'double_19', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1.23E2</gml:pos></gml:Point>'));
SELECT 'double_20', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1.23e2</gml:pos></gml:Point>'));
SELECT 'double_21', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 -1.23E2</gml:pos></gml:Point>'));

-- ERROR: no exp digit
SELECT 'double_22', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1E</gml:pos></gml:Point>'));
SELECT 'double_23', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1e</gml:pos></gml:Point>'));

-- ERROR: dot inside exp digits
SELECT 'double_24', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1e2.3</gml:pos></gml:Point>'));
SELECT 'double_25', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 1E2.3</gml:pos></gml:Point>'));

-- ERROR: spaces inside 
SELECT 'double_26', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 - 1.23</gml:pos></gml:Point>'));
SELECT 'double_27', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 -1 .23</gml:pos></gml:Point>'));
SELECT 'double_28', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 -1. 23</gml:pos></gml:Point>'));
SELECT 'double_29', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 -1.23 E2</gml:pos></gml:Point>'));
SELECT 'double_30', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 -1.23E 2</gml:pos></gml:Point>'));

-- ERROR: Junk 
SELECT 'double_31', ST_AsEWKT(ST_GeomFromGML('<gml:Point><gml:pos>1 $0%@#$^%#</gml:pos></gml:Point>'));





--
-- Delete inserted spatial data
--
DELETE FROM spatial_ref_sys WHERE srid = 4326;
