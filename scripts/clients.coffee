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
<<<<<<< HEAD
#   clients - Lists names of all Mason SBDC clients.
#   clients <employeeName> - Lists names of clients assigned to an
#                                 employee.
=======
#   ss clients - Lists names of all Mason SBDC clients.
>>>>>>> testing

module.exports = (robot) ->
  robot.hear /ss clients/i, (res) ->
    res.send "I guess this works."
