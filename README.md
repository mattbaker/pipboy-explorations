# Pip-Boy Explorations

Research into Fallout 4's Pip Boy companion app protocol. Credit for getting this party started goes to @rgbkrk and [pipboyrelay](https://github.com/rgbkrk/pipboyrelay), as well as @nelix's [impressive research](https://github.com/rgbkrk/pipboyrelay/pull/2).

## pippipe

A simple pipe of pip boy messages from the PS4 to STDOUT. Mix with good old fashioned Unix for a good time.

```
# Dump server data stream to a file
$ ruby pippipe.rb > test.bin

# Pipe the data stream through a hex viewer to visualize in real time!
$ ruby pippipe.rb | xxd

# Do both at the same time with tee
$ ruby pippipe.rb | tee test.bin | xxd
```
