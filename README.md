# Ego

[![Gem Version](https://badge.fury.io/rb/ego.svg)](https://badge.fury.io/rb/ego)

Ego is a personal command-line assistant that provides a flexible, natural
language interface (sort of) for interacting with other programs. Think of
it as a single-user IRC bot that can be extended with handlers for various
natural-language queries.

## Installation

Ego requires Ruby. If you already have Ruby installed, run:

    $ gem install ego

## Usage

Ego responds to natural-language queries at the command-line:

    $ ego what can you do?

If you want to interact with ego as a REPL, try:

    $ ego --shell

## Extending

Ego does very few things out of the box, but it's designed to be extensible!
You can personalize ego and teach it to do new things by defining "handlers",
which are small scripts that tell ego what queries to listen for and how to
respond to them. Here's what a handler looks like that responds to a query
beginning with "hello...", "hi...", or "hey..." with its own random greeting:

```ruby
Ego::Handler.register do |handler|
  handler.description = 'greet you'

  handler.listen /^(hello|hi|hey)/i, priority: 3

  handler.run do |robot|
    robot.respond [
      'Hello.',
      'Hi.',
      'Ciao.',
    ].sample
  end
end
```

    $ ego hello
    > Hi.

Let's break that down:

```ruby
handler.description = 'greet you'
```

The description is for your own reference, and answers the question "What can
this handler do?"

```ruby
handler.listen /^(hello|hi|hey)/i, priority: 3
```

This is the listener, which specifies what queries should invoke the handler.
The first argument is a regular expression to match the query against.
Sometimes you may want to match very specific things and sometimes something
broader. To help ego respond the right way when two or more listeners match
your query, you can optionally specify a `:priority` (higher number = higher
priority). One handler can have as many listeners as you want, even ones with
different priorities.

```ruby
handler.run do |robot|
  # ...
end
```

This is the part that gets run when your handler matches the query. From here
you can do anything you want including deferring to external programs. The
`robot` is made available to you to respond to the user. Usually, you'll want
to make use of part of the query in your handler. You can access named match
groups through the optional `params` parameter:

```ruby
Ego::Handler.register do |handler|
  handler.description = 'repeat what you say'

  handler.listen /^say (?<input>.+)/i

  handler.run do |robot, params|
    robot.respond params[:input]
  end
end
```

Try it out (this one is already included):

    $ ego say something
    > something

Ego looks for user-defined handlers in `$XDG_CONFIG_HOME/ego/handlers/`
(that's `~/.config/ego/handlers/` by default), and registers them
automatically at runtime. Each handler goes in it's own file with an `.rb`
extension (e.g., `~/.config/ego/handlers/my_handler.rb`). Be careful—ego will
execute any Ruby scripts in this directory indiscriminately.

## License

Copyright (C) 2016  Noah Frederick

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
