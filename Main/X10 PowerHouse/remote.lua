
local script = libs.script;

actions.officeLampOn = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
				   "echo pl c1 on | nc -w 1 192.168.168.91 1099");
end
actions.officeLampOff = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
	               "echo pl c1 off | nc -w 1 192.168.168.91 1099");
end

actions.landscapeLightingOn = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
				   "echo pl c3 on | nc -w 1 192.168.168.91 1099");
end
actions.landscapeLightingOff = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
				   "echo pl c3 off | nc -w 1 192.168.168.91 1099");
end

actions.livingTableLampOn = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
				   "echo pl c4 on | nc -w 1 192.168.168.91 1099");
end
actions.livingTableLampOff = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
				   "echo pl c4 off | nc -w 1 192.168.168.91 1099");
end

actions.livingFloorLampOn = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
				   "echo pl c5 on | nc -w 1 192.168.168.91 1099");
end
actions.livingFloorLampOff = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
				   "echo pl c5 off | nc -w 1 192.168.168.91 1099");
end

actions.receiverPower = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
				   "echo pl c6 on | nc -w 1 192.168.168.91 1099");
end

actions.pumpStart = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
				   "echo pl c7 on | nc -w 1 192.168.168.91 1099");
end

actions.backyardLightsOn = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
				   "echo pl c9 on | nc -w 1 192.168.168.91 1099");
end
actions.backyardLightsOff = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
				   "echo pl c9 off | nc -w 1 192.168.168.91 1099");
end

actions.denSpotsOn = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
				   "echo pl c10 on | nc -w 1 192.168.168.91 1099");
end
actions.denSpotsOff = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
				   "echo pl c10 off | nc -w 1 192.168.168.91 1099");
end

actions.denTableLampOn = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
				   "echo pl c11 on | nc -w 1 192.168.168.91 1099");
end
actions.denTableLampOff = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
				   "echo pl c11 off | nc -w 1 192.168.168.91 1099");
end

actions.ebikeChargerOn = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
				   "echo pl c12 on | nc -w 1 192.168.168.91 1099");
end
actions.ebikeChargerOff = function ()
	script.default("set path=%path%;C:\\Program Files\\nc111nt",
				   "echo pl c12 off | nc -w 1 192.168.168.91 1099");
end
