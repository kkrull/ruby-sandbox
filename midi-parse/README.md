# Parse MIDI file

Next up: Load the file and pass through the top-line chunks:

    4 characters of the chunk type
    32-bit length, in bytes (MSB on the left)
    That many bytes of data (don't display this yet)

## Running

    make

## Viewing hex data

Use `vim -b` to set binary mode.
Use `xxd` to view hex mode.
Use `:%!xxd` to select the whole buffer and pass it through `xxd`, so you can see the hex.

