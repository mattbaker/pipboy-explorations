# Pipboy Explorations
<img src="http://i.imgur.com/Icy3L07.png" width="200" align="right">

Research into Fallout 4's Pip Boy companion app protocol. Credit for getting this party started goes to @rgbkrk and [pipboyrelay](https://github.com/rgbkrk/pipboyrelay), as well as @nelix's [impressive research](https://github.com/rgbkrk/pipboyrelay/pull/2).

See @rgbkrk's [original post](https://getcarina.com/blog/fallout-4-service-discovery-and-relay/) for an intro.

## pipboyspec

[pipboyspec](https://github.com/mattbaker/pipboyspec) is a repository attempting to document the protocol for others interested in implementing their own clients or servers.

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

A simple parser of pip boy messages received on STDIN. JSON representations of each message are sent to STDOUT.

```
# Process live traffic
$ ruby pippipe.rb 192.168.0.101 | ruby pipparse.rb
{"message_type":"CONNECTION_ACCEPTED","message_body":{"lang":"en","version":"1.1.21.0"}}
{"message_type":"DATA_UPDATE","message_body":[{"set":28280,"value":"$General"},{"set":28296,"value":60},{"set":28295,"value":"Locations Discovered"},{"set":28297,"value":true} #...snip...
```

```
# Parse an existing dump
$ ruby pipparse.rb < test.bin
```

## pipviz

Receives a stream of parsed messages in the form of JSON strings and consumes them, including maintaining a database of game data. For now, just useful to examine a dump. `ARGV[0]` is the ID of the object you want to look at. 0-11 are good ids to start with.

```
# Parse an existing dump and pipe into pipviz
$ ruby pipparse.rb < test.bin | ruby pipviz.rb 1
```

Todo: some sort of live visualization
