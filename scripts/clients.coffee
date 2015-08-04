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
#   today's clients - Lists client names, counselor names, and times for appointments scheduled for today.
#
# Notes:
#   A column in the specified sheet *must* have the title 'Client Name', or this won't
#   work.
#
#   Time/date isn't in EST. Use moment and moment-timezone to make it so that the
#   method updates at midnight EST.
#
#   In a future update, allow the user to specify a date (i.e., "clients for (.*)").

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
        # Let's have Jeeves be motivational like Slack. It'd be nice.
        # Info about random number formula can be found here: http://bit.ly/JS-rand-nums.
        `function randZeroToThree(min, max) {
          return Math.floor(Math.random() * (max - min + 1)) + min;
        }`
        motivation = "\n"
        if randZeroToThree(0, 3) == 0
          motivation += "Go get 'em!"
        else if randZeroToThree(0, 3) == 1
          motivation += "Don't overwhelm yourself, now!"
        else if randZeroToThree(0, 3) == 2
          motivation += "You can do it!"
        else
          motivation += "Have a super day!"
        
        for rowNum, i in rowNums
          apptNum = i + 1
          # In a later update, make this future-proof -- have jeeves search the
          # sheet for the columns containing the necessary data like he did the date.
          employeeName = data.rows[rowNum].cells[3].value
          clientName = data.rows[rowNum].cells[1].value
          apptTime = data.rows[rowNum].cells[9].value
          # initialOrRepeat = data.rows[rowNum].cells[12].value.toLowerCase()

          # if initialOrRepeat == "initial"
          #   initialOrRepeat = "an " + initialOrRepeat
          # else
          #   initialOrRepeat = "a " + initialOrRepeat
          # ", #{initialOrRepeat} customer," goes below.
          rowYrBoatNerd += apptNum + ". #{employeeName}: #{clientName} at #{apptTime}.\n"
        
        msg.send "Okay, we've got #{rowNums.length} appointments today:\n" + rowYrBoatNerd + motivation