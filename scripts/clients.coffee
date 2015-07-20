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
# Status:
#   ss clients - not functional
#
# Notes:
#
# To get a cell, you have to use the URL https://api.smartsheet.com/2.0/sheets/{sheetId}/rows/{rowId}/columns/{columnId}.
# Tomorrow, start working on getting that first GET request to populate a CoffeeScript
# array with all of the row numbers of the document. Yeesh, this is gonna be a pain.
#
#	A column in the specified sheet *must* have the title 'Name', or this won't
#	work.
#
#	Currently, this only searches the default document. In the future, maybe it
#	could search a user-specified document.

module.exports = (robot) ->
  robot.hear /ss clients/i, (msg) ->
  	url = "https://api.smartsheet.com/2.0/sheets/#{process.env.HUBOT_SMARSHEET_DEFAULT_SHEET_ID}"
    auth = "Bearer #{process.env.HUBOT_SMARTSHEET_API_KEY}"
    colNum = -1
    # Get the columnId of the 'Name' column.
    robot.http(url)
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
      	data = JSON.parse(body)
      	# Parses 'columns' for column titled "Name". Stops when it finds it.
        # Sets columnId to 'colNum'. Note: to use regular JavaScript code in a
        # CoffeeScript file, put the JavaScript code in backticks (`) and it'll
        # be just fine. Just try and change it to CoffeeScript later.
      	`for (var i = 0; i < data.columns.length; i++) {
      		if (data.columns[i].title.toLowerCase() === "name")
      			colNum = data.columns[i].id;
      			break;
      	}`
    # Print the names (once for each name) from 'Name'.
    robot.http(url + "/columns/" + colNum)
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        smartsheet = JSON.parse(body)
        if colNum == -1
          # If colNum = -1, tell user the column wasn't found and must be titled
          # 'Name' (no quotes).
          msg.send "Sorry, I couldn't find the 'name' column. A reminder: 
                    the column containing client names *must* be titled
                    'Name' (no quotes) in order for me to read it."
        else
          # Parses array of all cells in column. If the name in the cell isn't
          # in the last position of the array 'clientNames', it adds it to
          # 'clientNames'.
          `for (var i = 0; i < smartsheet.data.length)
          `
          # Prints 'clientNames' with a newline after each one.
    	    msg.send "Placeholder text. Also, stop procrastinating on your calc."
