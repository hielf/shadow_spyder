json.id @market.id

if @last_item
  json.open           @last_item.begin_v
  json.high           @last_item.high_v
  json.yestoday_close @last_item.p_close
  json.low            @last_item.low_v
  json.change         @last_item.change
  json.change_rate    @last_item.change_rate
  json.value          @last_item.end_v
  json.amount         @last_item.amount
  json.time           Time.now
else
  json.open           ""
  json.high           ""
  json.yestoday_close ""
  json.low            ""
  json.change         ""
  json.change_rate    ""
  json.value          ""
  json.amount         ""
  json.time           Time.now
end