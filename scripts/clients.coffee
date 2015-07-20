# Description:
#   Tells the user info about our clients. Info taken from a specified
#   Smartsheet document.
#
# Dependencies: none.
#
# Configuration:
#   HUBOT_SMARTSHEET_API_KEY
#   HUBOT_SMARTSHEET_DEFAULT_SHEET_ID
#
# Commands:
#   ss clients - Lists names of all Mason SBDC clients.
#
# Notes:
#	A column in the specified sheet *must* have the title 'Name', or this won't
#	work.
#
#	Currently, this only searches the default document. In the future, maybe it
#	could search a user-specified document.

module.exports = (robot) ->
  robot.hear /ss clients/i, (msg) ->
  	url = "https://api.smartsheet.com/2.0/sheets/#{process.env.HUBOT_SMARTSHEET_DEFAULT_SHEET_ID}"
    auth = "Bearer #{process.env.HUBOT_SMARTSHEET_API_KEY}"
    robot.http(url)
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
      	data = JSON.parse(body)
      	# Parses the array of column titles for the one titled "Name". Stops
      	# when it finds it and sets the column number to 'colNum'. Hehe... it
      	# kinda looks like 'column'. Funny how that worked out.

      	# Parses array of all cells in column. If the name in the cell isn't
      	# in the last position of the array 'clientNames', it adds it to
      	# 'clientNames'.

      	# Prints 'clientNames' with a newline after each one.
    	msg.send "Placeholder text. Also, stop procrastinating on your calc."
