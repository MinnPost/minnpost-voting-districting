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
