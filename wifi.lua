config = {}
config.SSID = {}
config.SSID["C3PO"] = "26092524"

function wifi_wait_ip()
  if wifi.sta.getip() == nil then
    print("IP unavailable, Waiting...")
  else
    tmr.stop(1)
    print("\n====================================")
    print("ESP8266 mode is: " .. wifi.getmode())
    print("MAC address is: " .. wifi.ap.getmac())
    print("IP is " .. wifi.sta.getip())
    print("====================================")

        m = mqtt.Client("clientid", 120, "user", "password")
        m:lwt("/lwt", "offline", 0, 0)
        m:on("connect", function(client) print ("Connected!") end)
        m:on("offline", function(client) print ("Offline!") end)
        
        m:connect("127.0.0.1", 9000, 0, function(client)
          print("Connected!!")
          client:subscribe("/topic", 0, function(client) print("subscribe success") end)
          client:publish("/topic", "scale", 0, 0, function(client) print("sent") end)
        end,
        function(client, reason)
          print("Failed reason: " .. reason)
        end)
    end
end

function wifi_start(list_aps)
  if list_aps then
    for key, value in pairs(list_aps) do
      if config.SSID and config.SSID[key] then
        wifi.setmode(wifi.STATION);
        wifi.sta.config{ssid=key, pwd=config.SSID[key]}
        print("Connecting to " .. key .. " ...")
        tmr.alarm(1, 2500, 1, wifi_wait_ip)
      end
    end
  else
    print("Error getting AP list")
  end
end

function startWifiConnection()
  print("Start connection  ...")
  wifi.setmode(wifi.STATION)
  wifi.sta.getap(wifi_start)
  wifi.sta.autoconnect(1)
end




