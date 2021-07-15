stub_request(:any, "http://api.openweathermap.org/data/2.5/weather?q=#{@city}&units=metric&appid=a64896bb4676c4331e621f1940dc623d")

puts Net::HTTP.get("http://api.openweathermap.org/data/2.5/weather?q=#{@city}&units=metric&appid=a64896bb4676c4331e621f1940dc623d", "/")