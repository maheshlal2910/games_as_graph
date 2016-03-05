//Continents with the highest region:bonus ratio
MATCH (c:Continent)-[sub_region:CONTAINS]-(:Region)
RETURN c.name AS continent, COUNT(sub_region)/c.soldier_bonus AS regions_to_bonus, COUNT(sub_region) AS sub_regions ORDER BY regions_to_bonus

//Continents with the region:bonus ratio divided by number of regions, because it makes your troops spread far
MATCH (c:Continent)-[sub_region:CONTAINS]-(:Region)
WITH c.name AS continent, COUNT(sub_region)/c.soldier_bonus AS regions_to_bonus, COUNT(sub_region) AS sub_regions
RETURN continent, regions_to_bonus, sub_regions, regions_to_bonus/sub_regions as priority ORDER BY priority DESC

//Which continents are bordered by this region
MATCH (continent:Continent)-[:CONTAINS]->(sub_region:Region)
WITH continent, sub_region
MATCH (sub_region)-[:BORDERS]-(x:Region)-[:CONTAINS]-(another:Continent) WHERE NOT another=continent
RETURN continent.name, COLLECT(DISTINCT another.name) AS bordering_continents 

//How many Intercontinental borders
MATCH (continent:Continent)-[:CONTAINS]->(sub_region:Region)
WITH continent, sub_region
MATCH (sub_region)-[:BORDERS]-(x:Region)-[:CONTAINS]-(another:Continent) WHERE NOT another=continent
RETURN continent.name, COUNT(another.name) AS borders

//Continents with the highest region:bonus ratio vs ease of defence
MATCH (c:Continent)-[:CONTAINS]->(sub_region:Region)
WITH c, sub_region, COUNT(sub_region)/c.soldier_bonus AS regions_to_bonus
MATCH (sub_region)-[:BORDERS]-(x:Region)<-[:CONTAINS]-(another:Continent) WHERE NOT another=c
RETURN c.name AS continent, regions_to_bonus,
COUNT(another.name) AS borders, regions_to_bonus/COUNT(another.name) AS ease_to_defend 
ORDER BY ease_to_defend DESC