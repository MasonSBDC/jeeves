# Description:
#   Tells the user info about the clients we're following. Info taken from a
#   specified Smartsheet document.
#
# Dependencies: none.
#
# Configuration:
#   HUBOT_SMARTSHEET_API_KEY
#   HUBOT_SS_CLIENT_FOLLOWING_ID
#
# Commands:
#   following2 - Lists the clients we're following to-date. Don't use.
#
# Notes:
#		Come up with a better command than "following".
#
#		Messages user in form of "NUMBER. EMPLOYEE_NAME: follow up with CLIENT_NAME by
#		FOLLOW_UP_DATE. Reason: REASON."

module.exports = (robot) ->
  robot.hear /following2/i, (msg) ->
    url = "https://api.smartsheet.com/2.0/sheets/#{process.env.HUBOT_SS_CLIENT_FOLLOWING_ID}"
    auth = "Bearer #{process.env.HUBOT_SMARTSHEET_API_KEY}"
    rowNums = []
    followUpDateCol = -1
    message = ""

    # "Master's HTTP call, sir."
    robot.http(url)
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        data = JSON.parse(body)
        month = new Date().getMonth() + 1
        date = new Date().getDate()

				# Find the column the follow-up date is stored in.
        # NOTE: To run regular JS code, put it in tickmarks (`).
        `for (var i = 0; i < data.columns.length; i++) {
          if (data.columns[i].title.toLowerCase() === "follow up plan date") {
            followUpDateCol = i;
            break;
          }
        }`

        if followUpDateCol == -1
        	msg.send "Sorry, I couldn't find the column titled 'Follow Up Plan Date'. Note: the column must have that exact title (no quotes) for me to read it."

        # **CODE WORKS UP TO HERE**
        # Find the rows containing dates that are either today or fall after today.
        for row in data.rows
        	# followUpMonth is the month from the 'follow up plan date' column. Similar with followUpDate.
       	  followUpMonth = Number(row.cells[followUpDateCol].value.slice(5,7))
       	  followUpDate = Number(row.cells[followUpDateCol].value.slice(8))
       	  # If the follow-up date's month is greater than this month, report it.
       	  # ELSE if the follow-up date's month IS this month AND the follow-up date is greater than or
       	  # equal to today's date, report it.
       	  # Otherwise, do nothing.
          if followUpMonth > month
          	rowNums.push row.rowNumber - 1
          else if followUpMonth == month && followUpDate >= date
          	rowNums.push row.rowNumber - 1
          else
          	continue

        # Compose our message. Each line will be stylized as stated above.
        for rowNum, i in rowNums
          apptNum = i + 1
          
          # In a later update, make this future-proof -- have jeeves search the
          # sheet for the columns containing the necessary data like he did the follow-update.
          employeeName = data.rows[rowNum].cells[5].value
          clientName = data.rows[rowNum].cells[1].value
          reason = ""

          # Get the reason for following up.
          if data.rows[rowNum].cells[11].value == undefined
          	reason = "no reason found"
          else
          	reason = data.rows[rowNum].cells[11].value
          
          # Stylize the date.
          followUpMonth = Number(data.rows[rowNum].cells[followUpDateCol].value.slice(5,7))
       	  followUpDate = data.rows[rowNum].cells[followUpDateCol].value.slice(8)
       	  followUpYear = data.rows[rowNum].cells[followUpDateCol].value.slice(0,4)
       	  followUpFull = "#{followUpMonth}/#{followUpDate}/#{followUpYear}"

          message += apptNum + ". #{employeeName}: follow up with #{clientName} by #{apptTime}. Reason: #{reason}.\n"

        msg.send "Okay, we've got #{rowNums.length} clients that we've been following to-date:\n" + message

