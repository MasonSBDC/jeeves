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
#   ss followsheet - Tells the user what sheet the 'following' method is looking at.
#
# Notes:
#		

module.exports = (robot) ->
  robot.hear /ss followsheet/i, (msg) ->
    url = "https://api.smartsheet.com/2.0/sheets/#{process.env.HUBOT_SS_CLIENT_FOLLOWING_ID}"
    auth = "Bearer #{process.env.HUBOT_SMARTSHEET_API_KEY}"
    robot.http(url)
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        data = JSON.parse(body)
        idAndName = "The sheet for clients we're following is ID ##{process.env.HUBOT_SS_CLIENT_FOLLOWING_ID}: #{data.name}.\n"
        rowsAndStuff = "This sheet has #{data.rows.length} rows."
        msg.send idAndName + rowsAndStuff

  robot.hear /ss debug/i, (msg) ->
    url = "https://api.smartsheet.com/2.0/sheets/#{process.env.HUBOT_SS_CLIENT_FOLLOWING_ID}"
    auth = "Bearer #{process.env.HUBOT_SMARTSHEET_API_KEY}"
    rowNums = []
    followUpDateCol = -1
    message = ""
    # Get rows IDs.
    robot.http(url)
      .headers(Authorization: auth, Accept: 'application/json')
      `.get()(function(err, resp, body) {
              data = JSON.parse(body)
              for (i = 0, len = ref.length; i < len; i++) {
                row = ref[i];
                rowNums.push(row.id);
              }
              message += rowNums[0]}`
    msg.send message
    # Delete the first row.
    #robot.http(url + "/rows/#{rowNums[0]}")
    #  .headers(Authorization: auth)
    #  .del() (err, res, body) ->

      