# Description:
#   Not quite sure yet. I'm new to this whole thing.
#
# Notes:
#   This is my first CoffeeScript/Hubot script. I've got some chill indie jams
#   going in my earbuds: Circle by Jon Hopkins. This is nice.

module.exports = (robot) ->
  robot.hear /badger/i, (res) ->
    res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS."

  robot.respond /open the (.*) doors/i, (res) ->
    doorType = res.match[1]
    if doorType is "pod bay"
      res.reply "I'm afraid I can't let you do that."
    else
      res.reply "Opening the #{doorType} doors."

  robot.hear /I like pie/i, (res) ->
    res.emote "makes a freshly baked pie"
