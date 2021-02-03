/**
*   
* Manhattam TaxiCab distance calculation with a little help of PostGIS
* https://en.wikipedia.org/wiki/Taxicab_geometry
* Returns distance in meters, due to constant (111.19) multiplication
*
* Sample: select manhattam_distance('-30.044000, -51.171999', '-29.839706, -51.245681');
**/
CREATE OR REPLACE FUNCTION manhattam_distance("originLatLon" text, "destinationLatLon" text)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare
	originGeometry		geometry;
	destinationGeometry	geometry;
  	distance	 		numeric;
  
BEGIN
  	originGeometry 	        := ST_GeomFromText('POINT(' || replace($1, ',', ' ') || ')');
	destinationGeometry 	:= ST_GeomFromText('POINT(' || replace($2, ',', ' ') || ')');
	
	if originGeometry is null or destinationGeometry is null then 
		return null;
	end if;
	
	--distance de manhattam: |x1 - x2| + |y1 - y2|
	return (abs(ST_X(originGeometry) - ST_X(destinationGeometry))+(abs(ST_Y(originGeometry)-ST_Y(destinationGeometry)))) * 111.19;
END;

$function$
;
