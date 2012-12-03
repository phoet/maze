# Follower-Maze Coding Challenge

This is my (failed) implementation of the SoundCloud Coding Challenge (CHALLENGE.md).

If you want to follow my naive approach to it, you can step through the branches
that I created for implementing each part of the event notification system:

```
git branch
  01_basic_setup
  02_prototyping_the_server
  03_covering_the_protocol
  04_accepting_the_event_source
  05_accepting_user_clients
  06_sending_events_to_the_client
  07_setting_up_test_scripts
  08_sending_events_in_order
  09_handle_subscriptions
  10_handle_event_order
  11_remove_global_state
* 12_documentation
```

I used *RSpec* to test the code that i wrote and you find them in the ```/spec``` folder.

*RSpec*, *Rake* and *Bundler* are the only dependencies that I used.
The actual client/server code is built just using Ruby Core and Standard Library.

Just run ```rspec``` to execute the spec and get a documentation:

```
Maze::Iterator
  next
    handles a sequence of events
    has a next when set
    handles random event order
    handles an arbitrary sequence of events
    has nothing when empty
[...]
```

I wrote a small wrapper script with Rake to execute the verification program.
Just run ```rake assert``` to check if everything works as expected.

There are some more scripts in the ```/bin``` folder to test the execution of server, client and event-source.

```
# run the server, hit CTRL+C to stop it
bin/server
# connect a client to the server
bin/client ID
# emit events
bin/emitter
```

All the logging-output goes into ```log/maze.log``` to see what's going on.

# Remarks

As far as I am concerned, I think that the taks is too complex for a coding challenge.

It's pretty hard working with this kind of low-level functionality.
There are so many tools out there that do a great job at handling all the multithreading complexity.

Testing is a main concern for me when writing code. Writing tests for threaded code is a PITA.
It's usually fragile and ugly, because you need to wait for threads to execute and join.

That's why I would use a Queuing Tool or some Actor Framework to handle all this stuff for a production system.

As a coding challenge, I would try to find a taks, that makes it easy to focus on things like domain objects, clean code and tests.
That's the stuff that *I* would look for at other developers code.

Since I am doing a lot of open source stuff in Ruby, you may want to check out some of my projects on GitHub:

- [OnRuby](http://github.com/phoet/on_ruby)
- [ASIN](http://github.com/phoet/asin)
- [Karotz](http://github.com/phoet/karotz)
