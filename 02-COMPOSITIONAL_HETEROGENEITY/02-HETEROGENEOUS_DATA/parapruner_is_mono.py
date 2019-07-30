#!/usr/bin/python

import sys, getopt
from ete3 import Tree

sys.tracebacklimit = 0

def main(argv):
   inputfile = ''
   try:
      opts, args = getopt.getopt(argv,"ht:l:r:",["tree=","leaves=","root="])
   except getopt.GetoptError:
      print 'test.py -t <treefile> -l <leave,leave,etc.> -r <root>'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print 'test.py -t <tree> -l <leave,leave,etc.> -r <root>'
         sys.exit()
      elif opt in ("-t", "--tree"):
         tree = arg
      elif opt in ("-l", "--leaves"):
         leaves = arg
      elif opt in ("-r", "--root"):
         root = arg

   list = leaves.split(',')
#   print(root)
   t = Tree(tree)
   t.set_outgroup(root)
   print t.check_monophyly(values=list, target_attr="name")

if __name__ == "__main__":
   main(sys.argv[1:])


