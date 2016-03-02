
//Blinker - 2 generation period
MATCH (c:Cell) WHERE c._id IN [8,13,18]
SET c:Alive
WITH COLLECT(c) as alive_cells
MATCH (dead:Cell) WHERE NOT(dead IN alive_cells)
SET dead:Dead

//I - 2 generation static pattern
MATCH (c:Cell) WHERE c._id IN [2,3,4,8,13,18,22,23,24]
SET c:Alive
WITH COLLECT(c) as alive_cells
MATCH (dead:Cell) WHERE NOT(dead IN alive_cells)
SET dead:Dead

//I hex - 2 generation static pattern
MATCH (c:Cell) WHERE c._id IN [2,3,4,6,8,10,11,13,15,16,18,20,22,23,24]
SET c:Alive
WITH COLLECT(c) as alive_cells
MATCH (dead:Cell) WHERE NOT(dead IN alive_cells)
SET dead:Dead

//Next Generation
MATCH (c:Cell)-[:NEIGHBOUR]-(neighbour)
WITH 
FILTER(x in LABELS(c) WHERE x='Alive' OR x='Dead') AS state,
c, 
[n IN COLLECT(neighbour) WHERE 'Alive' IN LABELS(n)|n._id] as neighbours
WITH {current_state:state, cell:c, alive_neighbours:SIZE(neighbours)} as status
WITH COLLECT(status) AS cell_collection
WITH 
[cell_info IN cell_collection WHERE 'Dead' IN LABELS(cell_info.cell) AND cell_info.alive_neighbours = 3| cell_info.cell] AS set_alive,
[cell_info IN cell_collection WHERE ('Alive' IN LABELS(cell_info.cell) AND (cell_info.alive_neighbours < 2 OR cell_info.alive_neighbours >3))| cell_info.cell] AS set_dead
WITH set_alive, set_dead 
FOREACH(cell IN set_alive | SET cell:Alive REMOVE cell:Dead)
WITH set_dead, set_alive
FOREACH(cell IN set_dead | SET cell:Dead REMOVE cell:Alive)
WITH set_dead, set_alive
MATCH (c:Cell)-[:NEIGHBOUR]-(n) RETURN c, n
