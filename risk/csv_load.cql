LOAD CSV WITH HEADERS FROM 
'file:/Users/maheshlal/Projects/personal/Neo4jMadness/modelling_game_data/risk/data/continents.csv' AS line
MERGE (c:Continent{name:line.name, soldier_bonus:toFloat(line.soldier_bonus)})
RETURN c

LOAD CSV WITH HEADERS FROM 
'file:/Users/maheshlal/Projects/personal/Neo4jMadness/modelling_game_data/risk/data/regions_and_continents.csv' AS line
MERGE (r:Region{name:line.region})
WITH r, line.continent as continent_name
MATCH (c:Continent{name:continent_name})
CREATE UNIQUE (c)-[:CONTAINS]->(r)
RETURN c, r

LOAD CSV WITH HEADERS FROM 
'file:/Users/maheshlal/Projects/personal/Neo4jMadness/modelling_game_data/risk/data/borders.csv' AS line
MATCH (r:Region{name:line.region}), (b:Region{name:line.bordering_region})
WITH r, b, line.border_type as border_type
CREATE UNIQUE (r)-[:BORDERS{type:border_type}]->(b)
RETURN b, r