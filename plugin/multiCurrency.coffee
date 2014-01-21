
multiCurrency = (dcs, options) ->
  # need to track a, p, v and r tx_e's
  exrate = if options.exrate? then options.exrate else 0

  console.log dcs

  dcs.addTransform ((dcsObject, o) ->
    # Put this function here for ease of accessing dcsObject and o
    getParams = (params) ->
      values = {}
      for p in params
        values[p] = dcsObject.WT[p]
      if o.argsa?
        i = 0
        try
          while i < o.argsa.length
            arg = o.argsa[i].substr(3)
            values[arg] = o.argsa[i+1] if arg in params
            i += 2
      values
    calculateValues = (input) ->
      split = input.split(';')
      v = []
      for s in split
        if not isNaN(s) and s >= 0
          v.push (exrate * s).toFixed(2)
        else
          v.push (0)
      v.join(';')

    # Need to consider dcs params and argsa
    params = ['tx_s', 'tx_sv', 'tx_sa']
    values = getParams(params)
    # We have the values now let's do the business
    new_values = []

    extras = ['z_shippingcost', 'z_ordertotal', 'z_offers']
    evalues = getParams(extras)

    
    for p in params
      if values[p]? and values[p] != ""
        new_values["#{p}_site"] = values[p]
        new_values[p] = calculateValues(values[p])
        if p == 'tx_s'
          # We need to do extra if it's a p          
          for v in extras
            if evalues[v]?
              new_values["#{v}_site"] = evalues[v]
              new_values["#{v}"] = calculateValues(evalues[v])

    for key, value of new_values
      o.argsa.push('WT.' + key)
      o.argsa.push(value)

    o.finish = ->
      for p in params
        delete dcsObject.WT[p] 
        delete dcsObject.WT["#{p}_site"]
      for e in extras
        delete dcsObject.WT[e]
        delete dcsObject.WT["#{e}_site"] 

    return true
  ), "all"
Webtrends.registerPlugin "multicurrency", (dcs, options) ->
  multiCurrency(dcs, options)
