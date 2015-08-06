# Description:
#   Used to debug scripts that aren't working for whatever reason. Currently,
#   it's debugging *following.coffee*.
#
# Dependencies: none.
#
# Configuration:
#   HUBOT_SMARTSHEET_API_KEY
#   HUBOT_SMARTSHEET_CLIENT_FOLLOWING_ID
#
# Commands:
#   ss debug - Lists client names, counselor names, and times for appointments scheduled for today.
#
# Notes:
#		

module.exports = (robot) ->
  robot.hear /ss debug/i, (msg) ->
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

        msg.send followUpDateCol

