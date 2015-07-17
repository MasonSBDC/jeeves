# Description:
#   Tells the user general info about the Smartsheet data that jeeves is
#   interacting with.
#
# Dependencies: none.
#
# Configuration:
#   HUBOT_SMARTSHEET_API_KEY
#   HUBOT_SMARTSHEET_DEFAULT_SHEET_ID
#
# Commands:
#   ss default - Tells the user the current default sheet.
#
# Notes:
#   When interacting with Smartsheet, there will be a default sheet that jeeves
#   will search if no additional sheet is specified. This default sheet should
#   contain all of our client info from CenterIC.
#
#   To set the default sheet, run 'heroku config:set HUBOT_SMARTSHEET_DEFAULT_SHEET_ID=PASTE_ID_NUMBER_HERE'
#   As of 7/16/15, the default sheet is 'JAY WILSON'.
#
#   For more info, check the README.

module.exports = (robot) ->
  robot.hear /ss default/i, (msg) ->
    url = "https://api.smartsheet.com/2.0/sheets/#{process.env.HUBOT_SMARTSHEET_DEFAULT_SHEET_ID}"
    auth = "Bearer #{process.env.HUBOT_SMARTSHEET_API_KEY}"
    robot.http(url)
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        data = JSON.parse(body)
        msg.send "Well, I got this far. What do you want from me, eh?"
        if res.statusCode isnt 200
          msg.send "An error occurred when processing your request:
                    #{res.statusCode}. The list of error codes can be found at
                    http://bit.ly/ss-errors. Talk to the nearest code nerd for
                    assistance."
        else
          # Tell the user the name of the current default sheet.
          msg.send "The current default sheet is #{data.name}."
