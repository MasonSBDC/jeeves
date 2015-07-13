# Description:
#   Tells the user info about our clients. Info taken from a specified
#   Smartsheet document.
#
# Dependencies: none.
#
# Configuration:
#   HUBOT_SMARTSHEET_API_KEY
#
# Commands:
#   clients - Lists names of all Mason SBDC clients.
#   clients <employeeName> - Lists names of clients assigned to an
#                                 employee.

module.exports = (robot) ->
  robot.hear /list clients\s*(.*)?$/i, (res) ->

  #
