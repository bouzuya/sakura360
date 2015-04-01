newClient = require './google-sheet'

module.exports = ({ email, key, sheetKey })->
  config = { email, key, sheetKey }
  client = newClient({ email: config.email, key: config.key })
  spreadsheet = client.getSpreadsheet(config.sheetKey)
  spreadsheet.getWorksheetIds()
  .then (worksheetIds) ->
    spreadsheet.getWorksheet(worksheetIds[0])
  .then (worksheet) ->
    worksheet.getCells()
  .then (cells) ->
    cells
    .reduce (spots, i) ->
      spot = spots.filter((j) -> j.row is i.row)[0]
      if spot?
        spot.id = i.value if i.col is 2
        spot.name = i.value if i.col is 3
        spots
      else
        spots.concat [i]
    , []
    .filter (i) -> i.id? and i.name?
    .map (i) ->
      id: i.id     # syukugawa
      name: i.name # 夙川公園
      photos: []
