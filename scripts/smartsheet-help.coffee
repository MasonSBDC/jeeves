# Description:
#   Tells the user general info about the Smartsheet data that jeeves is
#   interacting with. Also contains Jeeves' sense of humor.
#
# Dependencies: none.
#
# Configuration:
#   HUBOT_SMARTSHEET_API_KEY
#   HUBOT_SMARTSHEET_DEFAULT_SHEET_ID
#
# Commands:
#   ss default - Tells the user the name of the current default sheet.
#
# Notes:
#   When interacting with Smartsheet, there will be a default sheet that jeeves
#   will search if no additional sheet is specified. This default sheet should
#   contain all of our client info from CenterIC.
#
#   Maybe add a command that tells the user the ID numbers of the most
#   frequently-searched documents. Like, top three.
#
#   ss default - functional
#
#   For more info, check the README.

module.exports = (robot) ->
  robot.hear /hey/i, (msg) ->
    # Makin' him all sassy with the bossman.
    msg.send "WHAT"

  robot.hear /YOU'RE ALIVE/i, (msg) ->
    msg.send "WOOOOO YA DID IT BOY"

  robot.hear /thanks|thank you/i, (msg) ->
    msg.send "Sure, whatever."

  robot.hear /nerd/i, (msg) ->
    # I am easily amused and use the word 'nerd' too often when debugging him.
    msg.send "NO, YOU ARE."

  robot.hear /ss default/i, (msg) ->
    url = "https://api.smartsheet.com/2.0/sheets/#{process.env.HUBOT_SMARTSHEET_DEFAULT_SHEET_ID}"
    auth = "Bearer #{process.env.HUBOT_SMARTSHEET_API_KEY}"
    robot.http(url)
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        data = JSON.parse(body)
        if res.statusCode isnt 200
          msg.send "An error occurred when processing your request:
                    #{res.statusCode}. The list of error codes can be found at
                    http://bit.ly/ss-errors. Talk to the nearest code nerd for
                    assistance."
        else
          # Tell the user the name of the current default sheet.
          msg.send "The current default sheet is #{data.name}."
