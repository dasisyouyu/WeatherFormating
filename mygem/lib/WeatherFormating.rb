BASE_URL = "http://api.openweathermap.org/data/2.5/weather"

class Weather
  # 引数にAPIkeyとcity_idを渡すと整形して返す
  # APIの仕様で３時間ごと１週間分とれるのでその日の適当な時間の天気を取ってくる
  def self.formating(key, city_name)
    require "json"
    require "open-uri"
    require 'bigdecimal'

    response = open(BASE_URL + "?q=#{city_name},jp&APPID=#{key}")
    response_json = JSON.pretty_generate(JSON.parse(response.read))
    response_hash = JSON.load(response_json)

    name    = response_hash["name"]
    weather = response_hash["weather"][0]["main"]
    weather_time = Time.at(response_hash["dt"])
    temp         = response_hash["main"]["temp"]-273.15 #ケルビン摂氏変換
    temp_min     = response_hash["main"]["temp_min"]-273.15 #ケルビン摂氏変換
    temp_max     = response_hash["main"]["temp_max"]-273.15 #ケルビン摂氏変換

    # 小数点第２位以下は切り捨て
    temp     = BigDecimal.new(temp.to_s).floor(2).to_f
    temp_min = BigDecimal.new(temp_min.to_s).floor(2).to_f
    temp_max = BigDecimal.new(temp_max.to_s).floor(2).to_f

    result = "#{weather_time}の#{name}の天気は#{weather}!!平均気温#{temp}℃最高気温#{temp_max}℃最低気温#{temp_min}℃です！！"
    return result
  end
end
