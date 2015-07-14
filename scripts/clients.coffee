# Description:
#   Tells the user info about our clients. Info taken from a specified
#   Smartsheet document.
#
# Dependencies: none.
#
# Configuration:
#   HUBOT_SMARTSHEET_API_KEY
#   HUBOT_SMARTSHEET_DEFAULT_SHEET
#
# Commands:
#   ss-clients - Lists names of all Mason SBDC clients.

module.exports = (robot) ->
  robot.hear /clients/i, (res) ->
    
