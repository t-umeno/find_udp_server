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
    udp_node = {}
    udp_comm = {}

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

            #print row
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
            reversePacketTotalCount = row[13].strip()
            reverseOctetTotalCount = row[14].strip()
            reverseFlowAttributes = row[15].strip()
            destinationMacAddress = row[16].strip()
            initialTCPFlags = row[17].strip()
            unionTCPFlags = row[18].strip()
            reverseInitialTCPFlags = row[19].strip()
            reverseUnionTCPFlags = row[20].strip()
            tcpSequenceNumber = row[21].strip()
            reverseTcpSequenceNumber = row[22].strip()
            ingressInterface = row[23].strip()
            egressInterface = row[24].strip()
            vlanId = row[25].strip()
            silkAppLabel = row[26].strip()
            ipClassOfService = row[27].strip()
            flowEndReason = row[28].strip()
            collectorName = row[29].strip()
            #print 'source:%s,%s destination:%s,%s' % (sourceIPv4Address, sourceTransportPort,destinationIPv4Address,destinationTransportPort)
            #print 'collectorName:%s' % collectorName
            key_src = "%s,%d" % (sourceIPv4Address, int(sourceTransportPort))
            udp_node[key_src] = "node"
            key_dst = "%s,%d" % (destinationIPv4Address, int(destinationTransportPort))
            udp_node[key_dst] = "node"

            key_comm = "%s,%s" % (key_src,key_dst)
            udp_comm[key_comm] = "comm"
            
        f.close()
        for k,v in udp_node.items():
            print k,v
            row = k.split(',')
            result = session.run("MERGE(a:udp_node{IP:\"%s\",port:%d})" % (row[0],int(row[1])))
                    
        for k,v in udp_comm.items():
            print k,v
            row = k.split(',')
            result = session.run("MATCH(a:udp_node{IP:\"%s\",port:%d}),(b:udp_node{IP:\"%s\",port:%d}) MERGE ((a)-[c:comm]->(b))" % (row[0],int(row[1]),row[2],int(row[3])))

    session.close()

if __name__ == "__main__":
    main()

