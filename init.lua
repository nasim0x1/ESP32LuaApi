local BLUE_LED = 2

gpio.config({ gpio = BLUE_LED, dir = gpio.IN_OUT })
gpio.write(BLUE_LED, 0)

local api = nil

local function init_api32()
    if api == nil then
        api = require('libs/api32')
            .create({
                auth = {
                    user = 'nasim',
                    pwd  = 'admin'
                }
            })
            .on_get('/', function()
                return { message = 'Welcome to the Home Server!' }
            end)
            .on_get('/test', function()
                return { message = 'Hello from TEST endpoint.' }
            end)
            .on_get('/led', function()
                return {
                    device = 'Blue LED',
                    state  = gpio.read(BLUE_LED)
                }
            end)
            .on_post('/led', function(jreq)
                if jreq == nil or jreq.state == nil then return end

                gpio.write(BLUE_LED, jreq.state)

                return {
                    new_state = gpio.read(BLUE_LED)
                }
            end)
            .on_get('/complex', function()
                return {
                    param1 = (2 + 2 * 2),
                    param2 = {
                        param2_1 = 'test',
                        param2_2 = 'hello'
                    }
                }
            end)
    end
end

wifi.mode(wifi.STATION)

wifi.sta.config({
    ssid  = 'Virus',
    pwd   = 'error@420',
    auto  = false
})

wifi.sta.on('got_ip', init_api32)

wifi.start()
wifi.sta.connect(