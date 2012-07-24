# Voting Districting

Techniques used to split Minnesota voting precincts into higher level district boundaries.  The Minnesota Secretary of State released Voting Precinct data on the MN Legislature site.  The dataset includes higher level boundaries like district courts, but we need to group them together to get new datasets (shapefiles).  This codebase is a simple collection of what was done to make that happen.

Instruction assume a Mac (sorry).

## Import into PostGIS

Install PostGIS with homebrew (a quick search will find you some good instructions).  Make sure to install GDAL with Postgres support.  

1. Create a PostGIS database named `minnpost`.
1. Extract shapefile: `cd data && unzip vtd2012_primary_rev20120720.zip; cd -;` 
1. Import the shapefile into the database (change `psql` credentials as need): `shp2pgsql -d -I -D -s 26915 data/vtd2012_primary_rev20120720.shp mn_voting_precincts | psql -U postgres -h localhost minnpost`
