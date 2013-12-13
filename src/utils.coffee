

glob = require('glob')



# replace: . - _ to `/`
safeServName = (servName) ->
  return servName.replace(/[.\-_]/g, '/')

# findPath by servName: apn, mailgun, baidu
findPath = (servName, ignoreError = true) ->
  servName = safeServName(servName)
  pt = "platforms/**/#{servName}.coffee"

  ms = glob(pt, {mark: true, cwd: __dirname, sync: true})

  if ms.length is 0
    throw new Error("#{servName} not found") unless ignoreError
    return
  if ms.length > 1
    throw new Error("please specil service type, example: email.#{servName}") unless ignoreError
    return
  return ms[0]

exports.findBackendPathByServName = (servName, ignoreError = true) ->

  if typeof servName is 'string'
    return findPath(servName, ignoreError)

  if servName instanceof Array
    paths = {}
    for sn in servName
      paths[sn] = findPath(sn, ignoreError)
    return paths
  throw new Error('Unsupport find: ' + servName)


