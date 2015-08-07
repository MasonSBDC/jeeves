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
#   ss debug - A debug method. Not for mere mortals.
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

    robot.http(url)
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        data = JSON.parse(body)
        month = new Date().getMonth() + 1
        date = new Date().getDate()
        if res.statusCode isnt 200
          msg.send "An error occurred when processing your request:
                    #{res.statusCode}. The list of error codes can be found at
                    http://bit.ly/ss-errors. Talk to the nearest code nerd for
                    assistance."
        else
				  # Find the column the follow-up date is stored in.
          # NOTE: To run regular JS code, put it in tickmarks (`).
          `for (var i = 0; i < data.columns.length; i++) {
            if (data.columns[i].title.toLowerCase() === "follow up plan date") {
              followUpDateCol = i;
              break;
            }
          }`

          msg.send "There are #{data.columns.length} columns in this sheet."

