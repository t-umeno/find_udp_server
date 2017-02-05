#!/usr/bin/python
import getopt, sys

from neo4j.v1 import GraphDatabase, basic_auth

def usage():
    print "neo4j-add_nodes_relations [-h] [-v] [-o outputfile]"

def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "ho:v", ["help", "output="])
    except getopt.GetoptError as err:
        # print help information and exit:
        usage()
        sys.exit(2)
    output = None
    verbose = False
    for o, a in opts:
        if o == "-v":
            verbose = True
        elif o in ("-h", "--help"):
            usage()
            sys.exit
        elif o in ("-o", "--output"):
            output = a
        else:
            assert False, "unhandled option"

    password = "test"

    driver = GraphDatabase.driver("bolt://localhost:7687", auth=basic_auth("neo4j", password))
    session = driver.session()

    session.close()

if __name__ == "__main__":
    main()

