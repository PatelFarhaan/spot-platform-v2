#!/usr/bin/env python

import argparse


def greet(name):
    print(f"Hello, {name}!")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Greet someone")
    parser.add_argument("name", help="the name to greet")
    args = parser.parse_args()
    greet(args.name)
