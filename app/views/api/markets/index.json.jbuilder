json.markets do
  json.array! @markets do |market|
    json.id market.id
    json.name market.name
    json.state market.state
    json.title market.title
    json.subtitle market.subtitle
    json.value ( market.items.last ? market.items.last.end_v : "")
    json.change_rate (market.items.last ? market.items.last.change_rate : "")
    json.open (market.items.last ? market.items.last.begin_v : "")
    json.high (market.items.last ? market.items.last.high_v : "")
    json.low (market.items.last ? market.items.last.low_v : "")
  end
end
