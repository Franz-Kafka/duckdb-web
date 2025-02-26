---
blurb: The bitstring type are strings of 1s and 0s.
layout: docu
title: Bitstring Type
---


| Name | Aliases | Description |
|:---|:---|:---|
| `BIT` | `BITSTRING` | variable-length strings of 1s and 0s |

Bitstrings are strings of 1s and 0s. The bit type data is of variable length. A bitstring value requires 1 byte for each group of 8 bits, plus a fixed amount to store some metadata.

By default bitstrings will not be padded with zeroes.
Bitstrings can be very large, having the same size restrictions as `BLOB`s.

Create a bitstring:

```sql
SELECT '101010'::BIT;
```

Create a bitstring with predefined length. The resulting bitstring will be left-padded with zeroes. This returns `000000101011`:

```sql
SELECT bitstring('0101011', 12);
```

## Functions

See [Bitstring Functions](../functions/bitstring).