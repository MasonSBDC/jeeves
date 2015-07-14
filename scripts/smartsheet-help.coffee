# Description:
#   Tells the user general info about the Smartsheet data that jeeves is
#   interacting with.
#
# Dependencies: none.
#
# Configuration:
#   HUBOT_SMARTSHEET_API_KEY
#   HUBOT_SMARTSHEET_DEFAULT_SHEET_ID - 8731584527394692
#
# Commands:
#   ss-default - Tells the user the current default sheet.

module.exports = (robot) ->
  robot.hear /ss-default/i, (res) ->
    url = "https://api.smartsheet.com/2.0/sheets/#{process.env.HUBOT_SMARTSHEET_DEFAULT_SHEET_ID}"
    robot.http(url)
      .header("Authorization", "#{process.env.HUBOT_SMARTSHEET_API_KEY}")
      .get(err, res, body) ->
        data = JSON.parse(body)
        response = "The current default sheet is #{data.name}"
        res.send response
