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
    rowNums = []
    rowYrBoatNerd = ""

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
        # NOTE: To run regular JS code, put it in tickmarks (`).
        `for (var i = 0; i < data.columns.length; i++) {
          if (data.columns[i].title.toLowerCase() === "date") {
            dateCol = i;
            break;
          }
        }`
        # Compile list of row numbers w/ appointments scheduled for today.
        for row in data.rows
          if row.cells[dateCol].value == today
            rowNums.push row.rowNumber - 1
        # Test if we got the rows we wanted.
        for rowNum, i in rowNums
          apptNum = i + 1
          rowYrBoatNerd += apptNum + ". #{data.rows[rowNum].cells[3].value}: #{data.rows[rowNum].cells[1].value} at #{data.rows[rowNum].cells[6].value}.\n"
        msg.send "Okay, we've got #{rowNums.length} appointments today:\n" + rowYrBoatNerd

