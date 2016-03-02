import py2neo

py2neo.authenticate("localhost:7474", "neo4j", "!abcd1234")
graph = py2neo.Graph()


side_length = 5
cypher = graph.cypher

cypher.execute("MATCH (n)-[r]-() DELETE r, n")

cell_ids = range(1, (side_length * side_length) + 1)
relationships_general = [-1, 1, -(side_length), (side_length), -(side_length+1), (side_length+1), -(side_length-1), (side_length-1)]
relationships_left_cell = [1, -(side_length), (side_length), (side_length+1), -(side_length-1)]
relationships_right_cell = [-1, -(side_length), (side_length), -(side_length+1), (side_length-1)]

cypher.execute("CREATE CONSTRAINT ON (c:Cell) ASSERT c._id IS UNIQUE")

def create_cell(cell_id):
    cypher.execute("CREATE (c:Cell{_id:{id}}) RETURN c._id as cell_id", id=cell_id)

def create_relationships(cell_id, related_cell_id):
    cypher.execute("MATCH (c:Cell{_id:{cell_id}}), (related:Cell{_id:{related_id}}) WHERE NOT (related)-[:NEIGHBOUR]-(c)"
                   + " CREATE UNIQUE (c)-[:NEIGHBOUR]->(related)", 
                   cell_id=cell_id, related_id=related_cell_id)

def generate_neighbour(cell_id):
    if cell_id % side_length == 1:
        [create_relationships(cell_id, cell_id+id_adder) for id_adder in relationships_left_cell]
    elif cell_id % side_length == 0:
        [create_relationships(cell_id, cell_id+id_adder) for id_adder in relationships_right_cell]
    else:
        [create_relationships(cell_id, cell_id+id_adder) for id_adder in relationships_general]

[create_cell(cell_id) for cell_id in cell_ids]
[generate_neighbour(cell_id) for cell_id in cell_ids]
