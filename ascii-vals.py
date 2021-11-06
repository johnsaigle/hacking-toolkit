#!/usr/bin/env python3
import argparse

parser = argparse.ArgumentParser(description='Get ASCII values from a payload')
parser.add_argument('--javascript-payload', metavar='jsmode', type=bool, nargs='?', const=True, default=False,
                    help='Print output wrapped in "<script>eval(String.fromCharCode(<PAYLOAD>))</script>')

args = parser.parse_args()
# string = sys.argv[1]
string = input()

x = [ord(char) for char in string]

if args.javascript_payload:
    print(f"<script>eval(String.fromCharCode{tuple(x)})</script>")
else:
    print(tuple(x))
