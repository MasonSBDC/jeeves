# Description:
#   Tells the user general info about the Smartsheet data that jeeves is
#   interacting with.
#
# Dependencies: none.
#
# Configuration:
#   HUBOT_SMARTSHEET_API_KEY
#   HUBOT_SMARTSHEET_DEFAULT_SHEET_ID
#
# Commands:
#   ss default - Tells the user the current default sheet.
#
# Notes:
#   When interacting with Smartsheet, there will be a default sheet that jeeves
#   will search if no additional sheet is specified. This default sheet should
#   contain all of our client info from CenterIC.

module.exports = (robot) ->
  robot.hear /ss default/i, (res) ->
    url = "https://api.smartsheet.com/2.0/sheets/#{process.env.HUBOT_SMARTSHEET_DEFAULT_SHEET_ID}"
    auth = "Bearer #{process.env.HUBOT_SMARTSHEET_API_KEY}"
    robot.http(url)
      # Smartsheet API requires that the header contain 'Authorization: "Bearer
      # <API key>"'. 'Content-Type' is something I saw on StackOverflow and
      # the hubot docs as something I should put in there. Not sure if the
      # command is '.header' or '.headers'.
      .headers(Authorization: auth, Accept: 'application/json')
      # The GET request. err = possible error, res = response specified in
      # ss-default's constructor, body = the info from Smartsheet in JSON format.
      .get() (err, res, body) ->
        # 'data' contains the info from Smartsheet in JSON format.
        data = JSON.parse(body)
        res.send "Well, I got this far. What do you want from me, eh?"
        #if res.statusCode isnt 200
          #res.send "An error occurred when processing your request:
          #          #{res.statusCode}. The list of error codes can be found at
          #          http://bit.ly/ss-errors. Talk to the nearest code nerd for
          #          assistance."
        #else
          # Tell the user the name of the current default sheet.
          #res.send "The current default sheet is #{data.name}."
