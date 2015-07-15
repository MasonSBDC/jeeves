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
#   ss-default - Tells the user the current default sheet.
#
# Notes:
#   When interacting with Smartsheet, there will be a default sheet that jeeves
#   will search if no additional sheet is specified. This default sheet should
#   contain all of our client info from CenterIC.

module.exports = (robot) ->
  robot.hear /ss-default/i, (res) ->
    url = "https://api.smartsheet.com/2.0/sheets/#{process.env.HUBOT_SMARTSHEET_DEFAULT_SHEET_ID}"
    robot.http(url)
      # Smartsheet API requires that the header contain 'Authorization: "Bearer
      # <API key>"'. 'Content-Type' is something I saw on StackOverflow and
      # the hubot docs as something I should put in there. Not sure if the
      # command is '.header' or '.headers'.
      .header(Authorization: "Bearer #{process.env.HUBOT_SMARTSHEET_API_KEY}", 'Content-Type': 'application/json')
      # The GET request. err = possible error, res = response specified in
      # ss-default's constructor, body = the info from Smartsheet in JSON format.
      .get(err, res, body) ->
        # 'data' contains the info from Smartsheet in JSON format.
        data = JSON.parse body
        if err
          # Tell the user that there was an error and the error code. Listings
          # for each error code can be found on the Smartsheet API website.
          res.send "Encountered an error: #{err}."
          return
        else
          # Tell the user the name of the current default sheet.
          res.send "The current default sheet is #{data.name}."
