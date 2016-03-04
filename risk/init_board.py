import py2neo

py2neo.authenticate("localhost:7474", "neo4j", "!abcd1234")
graph = py2neo.Graph()
