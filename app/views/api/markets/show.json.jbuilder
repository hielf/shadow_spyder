json.market do
  json.id @market.id
  json.name   @market.name
  json.start (@items.last.time - @time_range.seconds)
  json.end @items.last.time
end

json.items do
  json.partial! 'api/items/item', collection: @items, as: :item
end
