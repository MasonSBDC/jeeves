# Description:
#   Tells the user info about our clients. Info taken from a specified
#   Smartsheet document.
#
# Dependencies: none.
#
# Configuration: none.
#
# Commands:
#   clients - Lists names of all Mason SBDC clients.
#   clients <employeeName> - Lists names of clients assigned to an
#                                 employee.
#
# Notes:
#   API Token: 2yh1b10q140dt7hkkr2odytu1x

module.exports = (robot) ->
  robot.hear /list clients\s*(.*)?$/i, (res) ->

  #
