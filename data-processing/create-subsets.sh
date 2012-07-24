#!/bin/bash


# Variables
#######################
S_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SUB_DIR="$S_DIR/../data/subsets"
PG_CREDS="host=localhost user=postgres dbname=minnpost"


# Wards
#######################
WBASE="vtd2012_wards"
WQUERY="SELECT DISTINCT v.mcd, v.ward, v.mcd || ' ' || v.ward AS ward_id, ST_Multi(ST_Union(ST_SetSRID(v.the_geom, 26915))) AS the_geom FROM (SELECT SUBSTRING(pctname FROM '([A-Za-z .]*)[ ]*(- |W-*[0-9]*|W[0-9]*|P-*[0-9]*|P[0-9]*|\([0-9A-Za-z]*\)|$)') AS mcd, ward, the_geom FROM mn_voting_precincts WHERE ward IS NOT NULL) AS v GROUP BY ward_id, v.mcd, v.ward"

echo "creating Wards shapefile..."
mkdir -p "$SUB_DIR/$WBASE"
rm -r $SUB_DIR/$WBASE/*
ogr2ogr -f "ESRI Shapefile" "$SUB_DIR/$WBASE/$WBASE.shp" PG:"$PG_CREDS" -sql "$WQUERY"


# County Commissioners
#######################
CBASE="vtd2012_county_commissioner"
CQUERY="SELECT DISTINCT v.countyname, v.ctycomdist, v.countyname || ' ' || v.ctycomdist AS ccd_id, ST_Multi(ST_Union(ST_SetSRID(v.the_geom, 26915))) AS the_geom FROM mn_voting_precincts AS v WHERE v.ctycomdist IS NOT NULL GROUP BY v.countyname, v.ctycomdist, ccd_id"

echo "creating County Commissioner shapefile..."
mkdir -p "$SUB_DIR/$CBASE"
rm -r $SUB_DIR/$CBASE/*
ogr2ogr -f "ESRI Shapefile" "$SUB_DIR/$CBASE/$CBASE.shp" PG:"$PG_CREDS" -sql "$CQUERY"


# Judicial District
#######################
JBASE="vtd2012_judicial_district"
JQUERY="SELECT DISTINCT v.juddist, ST_Multi(ST_Union(ST_SetSRID(v.the_geom, 26915))) AS the_geom FROM mn_voting_precincts AS v WHERE v.juddist IS NOT NULL GROUP BY v.juddist"

echo "creating Judicial Districts shapefile..."
mkdir -p "$SUB_DIR/$JBASE"
rm -r $SUB_DIR/$JBASE/*
ogr2ogr -f "ESRI Shapefile" "$SUB_DIR/$JBASE/$JBASE.shp" PG:"$PG_CREDS" -sql "$JQUERY"
