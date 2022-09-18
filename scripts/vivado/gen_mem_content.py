#!/usr/bin/env python3

import argparse

def output_mem_file(mem_content):

  if mem_content == True:
    mem_file = open("sgpr_incr.mem", "w")
  else:
    mem_file = open("sgpr_zero.mem", "w")

  for x in range(4096):
    if mem_content:
      mem_file.write("@{0} {1}\n".format(format(x, '04x'), format(x, '08x')))
  else:
      mem_file.write("@{0} {1}\n".format(format(x, '04x'), format(0, '08x')))

  mem_file.close()

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("-i", "--increment", help="Incrementing memory.", action="store_true", default=False)
  args = parser.parse_args()
  output_mem_file(args.increment)
