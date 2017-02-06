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
    flowflag = False
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
            if row[0].startswith('2') or row[0].startswith('1'):
                flowflag = True
            else:
                flowflag = False
                continue

            print row
            flowStartMilliseconds = row[0].strip()
            flowEndMilliseconds = row[1].strip()
            flowDurationMilliseconds = row[2].strip()
            reverseFlowDeltaMilliseconds =  row[3].strip()
            protocolIdentifier = row[4].strip()
            sourceIPv4Address = row[5].strip()
            sourceTransportPort = row[6].strip()
            packetTotalCount = row[7].strip()
            octetTotalCount = row[8].strip()
            flowAttributes = row[9].strip()
            sourceMacAddress = row[10].strip()
            destinationIPv4Address = row[11].strip()
            destinationTransportPort = row[12].strip()
            print 'source:%s,%s destination:%s,%s' % (sourceIPv4Address, sourceTransportPort,destinationIPv4Address,destinationTransportPort)
            
        f.close()

    session.close()

if __name__ == "__main__":
    main()

