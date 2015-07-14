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
#   ss-default - Tells the user the current default sheet.
#
# Notes:
#   Adding this comment because it won't push to GitHub for some reason.

module.exports = (robot) ->
  robot.hear /ss-default/i, (res) ->
    url = "https://api.smartsheet.com/2.0/sheets/#{process.env.HUBOT_SMARTSHEET_DEFAULT_SHEET_ID}"
    robot.http(url)
      .header(Authorization: "#{process.env.HUBOT_SMARTSHEET_API_KEY}", 'Content-Type': 'application/json')
      .get(err, res, body) ->
        data = JSON.parse body
        res.send "The current default sheet is #{data.name}."
