# Description:
#   Tells the user info about the clients who are waiting to be scheduled.
#   Info taken from a specified Smartsheet document.
#
# Dependencies: none.
#
# Configuration:
#   HUBOT_SMARTSHEET_API_KEY
#   HUBOT_SS_CLIENT_WAITING_ID
#
# Commands:
#   client waiting - Lists some nonsense or something, I dunno. Doesn't work yet, so don't try it.
#
# Notes:
#   A column in the specified sheet *must* have the title 'Client Name', or this won't
#   work.
#
#	Should print a message to the user in the form of "We have X clients waiting
#	to be scheduled:\nEMPLOYEE_NAME: Schedule"

module.exports = (robot) ->
  robot.hear /client waiting/i, (msg) ->
    url = "https://api.smartsheet.com/2.0/sheets/#{process.env.HUBOT_SS_CLIENT_WAITING_ID}"
    auth = "Bearer #{process.env.HUBOT_SMARTSHEET_API_KEY}"
    msg.send "Placeholder text."