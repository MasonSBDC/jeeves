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
#
#   For more info, check the README.

module.exports = (robot) ->
  robot.hear /ss default/i, (res) ->
    url = "https://api.smartsheet.com/2.0/sheets/#{process.env.HUBOT_SMARTSHEET_DEFAULT_SHEET_ID}"
    auth = "Bearer #{process.env.HUBOT_SMARTSHEET_API_KEY}"
    robot.http(url)
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        res.send res.statusCode
