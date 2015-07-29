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
#   today's clients - Lists client names, counselor names, and times for appointments scheduled for today
#
# Notes:
#	  A column in the specified sheet *must* have the title 'Client Name', or this won't
#	  work.
#
#   ss clients - not functional
#
#	  Currently, this only searches the default document. In the future, maybe it
#	  could search a user-specified document.

module.exports = (robot) ->
  robot.hear /today's clients/i, (msg) ->
    url = "https://api.smartsheet.com/2.0/sheets/#{process.env.HUBOT_SS_CLIENT_SCHEDULE_ID}"
    auth = "Bearer #{process.env.HUBOT_SMARTSHEET_API_KEY}"
    dateCol = -1
    clientNames = []

    # Create date in YYYY-MM-DD format.
    date = new Date()
    month = date.getMonth() + 1
    if month < 10
      month = "0" + month
    day = date.getDate()
    if day < 10
      day = "0" + day
    year = date.getFullYear()
    today = year + "-" + month + "-" + day

    # Populate 'rows' with all row values from the default sheet and set
    # columnId to colNum.
    robot.http(url)
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        data = JSON.parse(body)
        # Find the column the date is stored in.
        `for (var i = 0; i < data.columns.length; i++) {
          if (data.columns[i].title.toLowerCase() === "date") {
            dateCol = i;
            break;
          }
        }`
        msg.send dateCol + " | " + today

