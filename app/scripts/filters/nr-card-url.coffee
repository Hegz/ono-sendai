# Accepts a lower case type, and returns its plural
pluralizeType = (type) ->
  switch type
    when 'identity'
      'identities'
    when 'ice', 'hardware'
      type
    else
      "#{ type }s"

angular.module('onoSendai')
  .filter 'cardUrl', ($log, $location) ->
    # [todo] Extract the patterns to an angular constant
    serveLocalImages = $location.host().match(/localhost/)? # or $location.host().match(/stage\.onosendaicorp\.com/)

    urlPrefix =
      if $location.$$html5
        ''
      else
        '#!'

    # arg - optional argument for some urlTypes
    (card, urlType, arg) ->
      if !card?
        return ''

      side = card.side.toLowerCase()

      switch urlType
        when 'card', 'calculator'
          suffix = if urlType == 'calculator' then '/$' else ''
          "#{ urlPrefix }/cards/#{ side }/card/#{ card.id }#{ suffix }"
        when 'type'
          "#{ urlPrefix }/cards/#{ side }/#{ pluralizeType(card.type.toLowerCase()) }"
        when 'set'
          "#{ urlPrefix }/cards/#{ side }?setname=#{ _.idify(card.setname) }&group=setname"
        when 'illustrator', 'alt-illustrator'
          id =
            if urlType == 'illustrator'
              card.illustratorId
            else
              card.altart.illustratorId

          "#{ urlPrefix }/cards?illustrator=#{ id }&group=illustrator"
        when 'subtype'
          "#{ urlPrefix }/cards/#{ side }?subtype=#{ _.idify(arg) }"
        when 'image'
          card.imagesrc

          # Commented out until I can figure out a better CDN solution. Cloudfront doesn't seem to offer any
          # noticeable gains.
          #
          # if serveLocalImages
          #   card.imagesrc
          # else
          #   # [todo] Extract this URL to an angular constant?
          #   "http://d3t3ih6ri0e76u.cloudfront.net#{ card.imagesrc }"
        else
          $log.warn("cardUrl: Unknown urlType #{ urlType }")
          ''
