local keyboard = libs.keyboard;
local win = libs.win;
local utf8 = libs.utf8;
local timer = libs.timer;
local script = libs.script;

local netcat_path = "set path=%path%;C:\\Users\\tchoy\\bin\\nc111nt"
local voicemeeter_exe = "C:\\Program Files (x86)\\VB\\Voicemeeter\\voicemeeter.exe"

events.detect = function ()
	return 
		libs.fs.exists("C:\\Program Files (x86)\\MusicBee") or
		libs.fs.exists("C:\\Program Files\\MusicBee");
end

local hwnd = 0;
local tid = -1;
local title = "";

function find ()
	-- Find all top level windows
	local hwnds = win.findall(0, nil, nil, false);
	for k,v in ipairs(hwnds) do
		local title = win.title(v);
		if (utf8.endswith(title, "MusicBee")) then
			return v;
		end
	end
	return 0;
end

function update ()
	if (hwnd ~= 0) then
		local _title = win.title(hwnd);
		if (_title ~= title) then
			title = _title;
			layout.info.text = title;
		end
	end
end

events.focus = function ()
	hwnd = find();
	tid = timer.interval(update, 1000);
end

events.blur = function ()
	timer.cancel(tid);
end

--@help Focus MusicBee application
actions.switch = function()
	if (hwnd == 0) then
		hwnd = find();
	end
	if (hwnd ~= 0) then
		win.switchtowait("MusicBee.exe");
	else
		win.switchto("MusicBee.exe");
	end
end

--@help Launch MusicBee application
actions.launch = function()
	os.start("MusicBee");
end

--@help Toggle playback state
actions.play_pause = function ()
	os.start(voicemeeter_exe, "-r")
	actions.switch();
	keyboard.stroke("ctrl", "p");
end

--@help Stop playback
actions.stop = function ()
	actions.switch();
	keyboard.stroke("ctrl", "s");
end

--@help Check for podcast updates
actions.check_updates = function ()
	actions.switch();
	keyboard.stroke("ctrl", "3");
	os.sleep(200);
	keyboard.stroke("ctrl", "f");
	os.sleep(200);
	keyboard.stroke("tab");
	os.sleep(200);
	keyboard.stroke("home");
	os.sleep(200);
	keyboard.stroke("f5");
	os.sleep(200);
	keyboard.stroke("d");
	os.sleep(200);
	keyboard.stroke("f5");
	os.sleep(200);
end
actions.check_for_updates = actions.check_updates;

--@help Switch to Now Playing tab
actions.tab_now_playing = function ()
	actions.switch();
	keyboard.stroke("ctrl", "1");
end

--@help Switch to Podcasts tab
actions.tab_podcasts = function ()
	actions.switch();
	keyboard.stroke("ctrl", "3");
end

--@help Switch to Playlists tab
actions.tab_playlists = function ()
	actions.switch();
	keyboard.stroke("ctrl", "4");
end

--@help Play Morning Wakeup playlist
actions.play_morning_wakeup = function ()
	actions.switch();
	keyboard.stroke("ctrl", "4");
	os.sleep(200);
	keyboard.stroke("ctrl", "f");
	os.sleep(200);
	keyboard.stroke("tab");
	os.sleep(200);
	keyboard.text("Morning Wakeup");
	os.sleep(200);
	keyboard.stroke("return");
	os.sleep(200);
	keyboard.stroke("alt", "return");
	os.sleep(200);
	keyboard.stroke("ctrl", "1");
end
actions.play_morning_wake_up = actions.play_morning_wakeup;

--@help Play Public Radio Streams playlist
actions.play_public_radio = function ()
	actions.switch();
	keyboard.stroke("ctrl", "4");
	os.sleep(200);
	keyboard.stroke("ctrl", "f");
	os.sleep(200);
	keyboard.stroke("tab");
	os.sleep(200);
	keyboard.text("Public Radio Streams");
	os.sleep(200);
	keyboard.stroke("return");
	os.sleep(200);
	keyboard.stroke("alt", "return");
	os.sleep(200);
	keyboard.stroke("ctrl", "1");
end
actions.play_public_radio_streams = actions.play_public_radio;


--@help Skip backward 1 min
actions.skip_backward_1min = function ()
	actions.switch();
	keyboard.stroke("ctrl", "left");
end

--@help Skip forward 1 min
actions.skip_forward_1min = function ()
	actions.switch();
	keyboard.stroke("ctrl", "right");
end

--@help Next track
actions.next = function ()
	actions.switch();
	keyboard.stroke("ctrl", "n");
end

--@help Previous track
actions.previous = function ()
	actions.switch();
	keyboard.stroke("ctrl", "b");
end

--@help Lower volume
actions.volume_down = function ()
	actions.switch();
	keyboard.stroke("ctrl", "alt", "down");
end

--@help Raise volume
actions.volume_up = function ()
	actions.switch();
	keyboard.stroke("ctrl", "alt", "up");
end

--@help Toggle mute volume
actions.volume_mute = function ()
	actions.switch();
	keyboard.stroke("ctrl", "alt", "v");
end

--@help Toggle Home Audio Receiver power
actions.receiverPower = function ()
	script.default(netcat_path, "echo rf c6 on | nc -w 1 192.168.168.89 1099");
end
