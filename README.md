# 8-bit-voltage-converter-to-ASCII-code

The algorithm converts a binary value from an 8-bit A/D converter, where the reference voltage of which is 5 V.

## Design

The decimal result is to have three significant digits and should be specified with accuracy to the second decimal place. The results are stored as ASCII codes (the need to add 30H - ASCII zero code), in the memory data starting from the address 40H. The calculated values are stored in the memory location with the address of 50h.

# Resolution of the 8-bit converter

δU = U<sub>reference</sub> / (256 - 1), where:
U<sub>reference</sub> = 5V

## Example

```
input data: 0x32, output data: 0.98
```
