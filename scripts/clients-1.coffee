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
    empNameCol = -1
    cliNameCol = -1
    timeCol = -1
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
        # Find the columns where the date, employee name, client name, and time are stored.
        # NOTE: To run regular JS code, put it in tickmarks (`).
        `for (var i = 0; i < data.columns.length; i++) {
          columnTitle = data.columns[i].title.toLowerCase();
          if (columnTitle === "date") {
            dateCol = i;
          }
          if (columnTitle === "client name") {
            cliNameCol = i;
          }
          if (columnTitle === "employee name") {
            empNameCol = i;
          }
          if (columnTitle === "time") {
            timeCol = i;
          }
        }`
        # Compile list of row numbers w/ appointments scheduled for today.
        for row in data.rows
          if row.cells[dateCol].value == today
            rowNums.push row.rowNumber - 1
        # Test if we got the rows we wanted.
        for rowNum, i in rowNums
          apptNum = i + 1
          # Should print in the form "X. [employee name]: [client name] at [time].".
          rowYrBoatNerd += apptNum + ". #{data.rows[rowNum].cells[empNameCol].value}: #{data.rows[rowNum].cells[cliNameCol].value} at #{data.rows[rowNum].cells[timeCol].value}.\n"
        # "Okay, we've got #{rowNums.length} appointments today:\n" + rowYrBoatNerd
        msg.send dateCol + " | " + empNameCol + " | " cliNameCol + " | " + timeCol

