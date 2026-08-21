#!/usr/bin/env python3
"""
Removes the section header table from an ELF binary. 
The Linux kernel never reads this table to execute the binary (only debuggers/readelf do).
This drops the final file size down to the absolute theoretical limit.
"""
import struct
import sys

if len(sys.argv) < 2:
    print("Usage: strip_shdrs.py <elf_binary>")
    sys.exit(1)

path = sys.argv[1]

with open(path, "rb") as f:
    data = bytearray(f.read())

# Read e_shoff (Section Header Table offset) before clearing it
shoff = struct.unpack_from("<Q", data, 40)[0]

# Clear SHT metadata fields inside the ELF Header
struct.pack_into("<Q", data, 40, 0)   # e_shoff    = 0
struct.pack_into("<H", data, 60, 0)   # e_shnum    = 0
struct.pack_into("<H", data, 62, 0)   # e_shstrndx = 0

# Write the truncated binary data back up to the SHT offset point
with open(path, "wb") as f:
    f.write(data[:shoff])

