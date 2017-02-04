#!/usr/bin/python
from neo4j.v1 import GraphDatabase, basic_auth

password = "test"

driver = GraphDatabase.driver("bolt://localhost:7687", auth=basic_auth("neo4j", password))
session = driver.session()

session.close()
