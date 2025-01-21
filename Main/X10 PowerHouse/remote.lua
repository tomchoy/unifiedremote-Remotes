
local script = libs.script;

local netcat_path = "set path=%path%;C:\\Users\\tchoy\\bin\\nc111nt"

actions.officeLampOn = function ()
	script.default(netcat_path, "echo rf c1 on | nc -w 1 192.168.168.89 1099");
end
actions.officeLampOff = function ()
	script.default(netcat_path, "echo rf c1 off | nc -w 1 192.168.168.89 1099");
end

actions.dirtDevilOn = function ()
	script.default(netcat_path, "echo rf c2 on | nc -w 1 192.168.168.89 1099");
end
actions.dirtDevilOff = function ()
	script.default(netcat_path, "echo rf c2 off | nc -w 1 192.168.168.89 1099");
end

actions.landscapeLightingOn = function ()
	script.default(netcat_path, "echo rf c3 on | nc -w 1 192.168.168.89 1099");
end
actions.landscapeLightingOff = function ()
	script.default(netcat_path, "echo rf c3 off | nc -w 1 192.168.168.89 1099");
end

actions.livingTableLampOn = function ()
	script.default(netcat_path, "echo rf c4 on | nc -w 1 192.168.168.89 1099");
end
actions.livingTableLampOff = function ()
	script.default(netcat_path, "echo rf c4 off | nc -w 1 192.168.168.89 1099");
end

actions.livingFloorLampOn = function ()
	script.default(netcat_path, "echo rf c5 on | nc -w 1 192.168.168.89 1099");
end
actions.livingFloorLampOff = function ()
	script.default(netcat_path, "echo rf c5 off | nc -w 1 192.168.168.89 1099");
end

actions.receiverPower = function ()
	script.default(netcat_path, "echo rf c6 on | nc -w 1 192.168.168.89 1099");
end

actions.pumpStart = function ()
	script.default(netcat_path, "echo rf c7 on | nc -w 1 192.168.168.89 1099");
end
actions.pumpReset = function ()
	script.default(netcat_path, "echo rf c7 off | nc -w 1 192.168.168.89 1099");
end

actions.denFanOn = function ()
	script.default(netcat_path, "echo rf c8 on | nc -w 1 192.168.168.89 1099");
end
actions.denFanOff = function ()
	script.default(netcat_path, "echo rf c8 off | nc -w 1 192.168.168.89 1099");
end

actions.backyardLightsOn = function ()
	script.default(netcat_path, "echo rf c9 on | nc -w 1 192.168.168.89 1099");
end
actions.backyardLightsOff = function ()
	script.default(netcat_path, "echo rf c9 off | nc -w 1 192.168.168.89 1099");
end

actions.denSpotsOn = function ()
	script.default(netcat_path, "echo rf c10 on | nc -w 1 192.168.168.89 1099");
end
actions.denSpotsOff = function ()
	script.default(netcat_path, "echo rf c10 off | nc -w 1 192.168.168.89 1099");
end

actions.denTableLampOn = function ()
	script.default(netcat_path, "echo rf c11 on | nc -w 1 192.168.168.89 1099");
end
actions.denTableLampOff = function ()
	script.default(netcat_path, "echo rf c11 off | nc -w 1 192.168.168.89 1099");
end

actions.ebikeChargerOn = function ()
	script.default(netcat_path, "echo rf c12 on | nc -w 1 192.168.168.89 1099");
end
actions.ebikeChargerOff = function ()
	script.default(netcat_path, "echo rf c12 off | nc -w 1 192.168.168.89 1099");
end

actions.guestTableLampOn = function ()
	script.default(netcat_path, "echo rf c13 on | nc -w 1 192.168.168.89 1099");
end
actions.guestTableLampOff = function ()
	script.default(netcat_path, "echo rf c13 off | nc -w 1 192.168.168.89 1099");
end