# TODO: fix if the value is 0.00
# TODO: fix if they can't find the currency conversion
multiCurrency = (dcs, options) ->
  # need to track a, p, v and r tx_e's
  exrate = if options.exrate? then options.exrate else 0

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
    params = ['tx_e', 'tx_s']
    values = getParams(params)
    # We have the values now let's do the business
    events = ['a', 'p', 'v', 'r']
    txe = values['tx_e']
    if txe in events
      # We have an event we are interested in
      # We need to rename tx_s to tx_s event
      txe_p = if txe == 'p' then '' else txe
      values["tx_s#{txe_p}_site"] = values['tx_s']

      values["tx_s#{txe_p}"] = calculateValues(values['tx_s']) if values['tx_s']?
      if txe == 'p'
        # We need to do extra if it's a p
        extras = ['z_shippingcost', 'z_ordertotal', 'z_offers']
        evalues = getParams(extras)
        for v in extras
          if evalues[v]?
            values["#{v}_site"] = evalues[v]
            values["#{v}"] = calculateValues(evalues[v])
      else
        values['tx_s'] = null

      delete values['tx_e']

      for key, value of values
        o.argsa.push('WT.' + key)
        o.argsa.push(value)
      return true
  ), "all"
Webtrends.registerPlugin "multicurrency", (dcs, options) ->
  multiCurrency(dcs, options)
