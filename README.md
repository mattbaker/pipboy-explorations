# Pip-Boy Explorations

Research into Fallout 4's Pip Boy companion app protocol. Credit for getting this party started goes to @rgbkrk and [pipboyrelay](https://github.com/rgbkrk/pipboyrelay), as well as @nelix's [impressive research](https://github.com/rgbkrk/pipboyrelay/pull/2).

## pippipe

A simple pipe of pip boy messages from the PS4 to STDOUT. Mix with good old fashioned Unix for a good time.

```
# Dump server data stream to a file
$ ruby pippipe.rb 192.168.0.101 > test.bin
```

```
# Pipe the data stream through a hex viewer to visualize in real time!
$ ruby pippipe.rb 192.168.0.101 | xxd
```

```
# Do both at the same time with tee
$ ruby pippipe.rb 192.168.0.101 | tee test.bin | xxd
```

## pipparse

A simple parser of pip boy messages received on STDIN.

```
# Process live traffic
$ ruby pippipe.rb 192.168.0.101 | ruby pipparse.rb

00000: CONNECTION_ACCEPTED with length 35
       7b226c616e67223a22656e222c227665...
00001: DATA_UPDATE with length 443764
       06786e00002447656e6572616c000388...
00002: KEEP_ALIVE with length 0
00003: DATA_UPDATE with length 9
       05777c00005b44a441
00004: KEEP_ALIVE with length 0
00005: KEEP_ALIVE with length 0
00006: DATA_UPDATE with length 9
       05777c00007b66a441
00007: KEEP_ALIVE with length 0
00008: KEEP_ALIVE with length 0
00009: KEEP_ALIVE with length 0
00010: DATA_UPDATE with length 9
       05777c00009e88a441
```

```
# Parse an existing dump
$ ruby pipparse.rb < test.bin
```
