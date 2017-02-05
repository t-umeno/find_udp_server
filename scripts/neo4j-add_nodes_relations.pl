#!/usr/bin/python
import getopt, sys
import csv

from neo4j.v1 import GraphDatabase, basic_auth

def usage():
    print "neo4j-add_nodes_relations [-h] [-v] [-o outputfile]"

def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hi:v", ["help", "input="])
    except getopt.GetoptError as err:
        # print help information and exit:
        usage()
        sys.exit(2)
    output = None
    input_super_mediator_file = None
    input_super_mediator = False
    verbose = False
    for o, a in opts:
        if o == "-v":
            verbose = True
        elif o in ("-h", "--help"):
            usage()
            sys.exit
        elif o in ("-i", "--input"):
            input_super_mediator_file = a
            input_super_mediator = True
        else:
            assert False, "unhandled option"

    password = "test"

    driver = GraphDatabase.driver("bolt://localhost:7687", auth=basic_auth("neo4j", password))
    session = driver.session()

    if input_super_mediator == True:
        f = open(input_super_mediator_file, 'r')
        reader = csv.reader(f, delimiter='|')
        for row in reader:
            print row
        f.close()

    session.close()

if __name__ == "__main__":
    main()

