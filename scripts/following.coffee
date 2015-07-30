# Description:
#   Tells the user info about the clients we're following. Info taken from a
#   specified Smartsheet document.
#
# Dependencies: none.
#
# Configuration:
#   HUBOT_SMARTSHEET_API_KEY
#   HUBOT_SS_CLIENT_FOLLOWING_ID
#
# Commands:
#   client following - Lists client names, follow-up dates, follow-up employee, and follow-up reason.
#
# Notes:
#   A column in the specified sheet *must* have the title 'Client Name', or this won't
#   work.

module.exports = (robot) ->
  robot.hear /client following/i, (msg) ->
    url = "https://api.smartsheet.com/2.0/sheets/#{process.env.HUBOT_SS_CLIENT_FOLLOWING_ID}"
    auth = "Bearer #{process.env.HUBOT_SMARTSHEET_API_KEY}"