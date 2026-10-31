local keyboard = libs.keyboard;
local win = libs.win;
local utf8 = libs.utf8;
local timer = libs.timer;
local script = libs.script;
local log = libs.log;
local server = libs.server;
local http = libs.http;

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

-- Morning Wakeup sequence timer parameters
local PUBLIC_RADIO_DURATION_SEC = 600;   -- 600 seconds (10 minutes)
local RELAY_HOP_MS = 60000;              -- 60s self-relay hop (< 120s UR HTTP session timeout)
local UPDATE_SETTLE_DELAY_MS = 15000;    -- 15 seconds after check_updates
local SEQUENCE_WINDOW_SEC = 30;          -- Window to detect sequential Morning Wakeup calls
local WAKEUP_STATE_FILE = "C:\\ProgramData\\Unified Remote\\musicbee_wakeup_state.txt";

local tid_check_updates = -1;
local tid_morning_wakeup = -1;

function write_wakeup_state (ts, mode)
	libs.fs.write(WAKEUP_STATE_FILE, tostring(ts) .. ":" .. mode);
end

function read_wakeup_state ()
	if (not libs.fs.exists(WAKEUP_STATE_FILE)) then
		return 0, "";
	end
	local raw = libs.fs.read(WAKEUP_STATE_FILE);
	if (raw == nil) then
		return 0, "";
	end
	local sep = string.find(raw, ":", 1, true);
	if (sep == nil) then
		return tonumber(raw) or 0, "";
	end
	local ts = tonumber(string.sub(raw, 1, sep - 1)) or 0;
	local mode = string.sub(raw, sep + 1);
	return ts, mode;
end

function cancel_wakeup_timers ()
	if (tid_check_updates ~= -1) then
		timer.cancel(tid_check_updates);
		tid_check_updates = -1;
	end
	if (tid_morning_wakeup ~= -1) then
		timer.cancel(tid_morning_wakeup);
		tid_morning_wakeup = -1;
	end
	if (libs.fs.exists(WAKEUP_STATE_FILE)) then
		libs.fs.delete(WAKEUP_STATE_FILE);
	end
end

function trigger_local_action (action_name)
	local base = "http://127.0.0.1:9510";
	http.post(base .. "/client/connect", "", function (err, resp)
		if (err or resp == nil) then
			log.error("MusicBee: Local relay connect failed");
			return;
		end
		local cid = string.match(resp, "\"id\"%s*:%s*\"([^\"]+)\"");
		if (cid == nil) then
			log.error("MusicBee: Local relay missing session id");
			return;
		end
		local hdrs = {
			["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8",
			["UR-Connection-ID"] = cid
		};
		local req0 = {
			method = "post",
			url = base .. "/client/request",
			headers = hdrs,
			content = "{\"Action\":0,\"Request\":0,\"Version\":10,\"Password\":\"08b2402b-671b-424a-a457-3ba58155b9ad\",\"Platform \":\"web\",\"Source\":\"ur-relay\"}"
		};
		http.request(req0, function (e0, r0)
			local req1 = {
				method = "post",
				url = base .. "/client/request",
				headers = hdrs,
				content = "{\"Capabilities\":{\"Actions\":true,\"Encryption2\":true,\"Fast\":false,\"Grid\":true,\"Loading\":true,\"Sync\":true},\"Action\":1,\"Request\":1,\"Source\":\"ur-relay\"}"
			};
			http.request(req1, function (e1, r1)
				local req7 = {
					method = "post",
					url = base .. "/client/request",
					headers = hdrs,
					content = "{\"ID\":\"Unified.MusicBee\",\"Action\":7,\"Request\":7,\"Source\":\"ur-relay\",\"Run\":{\"Name\":\"" .. action_name .. "\"}}"
				};
				http.request(req7, function (e7, r7) end);
			end);
		end);
	end);
end

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
	cancel_wakeup_timers();
	actions.switch();
	keyboard.stroke("ctrl", "s");
end

function do_check_updates ()
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

function do_play_morning_wakeup ()
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

function do_play_public_radio ()
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

--@help Check for podcast updates
actions.check_updates = function ()
	local ts, mode = read_wakeup_state();
	if (ts > 0 and os.difftime(os.time(), ts) < SEQUENCE_WINDOW_SEC) then
		write_wakeup_state(ts, "check_queued");
		log.info("MusicBee: Queued Check for Updates for Morning Wakeup sequence (600s)");
	else
		do_check_updates();
	end
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

function schedule_next_wakeup_hop (expected_ts)
	local elapsed = os.difftime(os.time(), expected_ts);
	local remaining_sec = PUBLIC_RADIO_DURATION_SEC - elapsed;
	if (remaining_sec > (RELAY_HOP_MS / 1000)) then
		tid_check_updates = timer.timeout(function ()
			tid_check_updates = -1;
			local cur_ts, cur_mode = read_wakeup_state();
			if (cur_ts ~= expected_ts or (cur_mode ~= "armed_check" and cur_mode ~= "armed_nocheck")) then
				log.info("MusicBee: Scheduled Morning Wakeup relay cancelled");
				return;
			end
			trigger_local_action("wakeup_tick");
		end, RELAY_HOP_MS);
	else
		local wait_ms = math.max(1000, remaining_sec * 1000);
		tid_check_updates = timer.timeout(function ()
			tid_check_updates = -1;
			local cur_ts, cur_mode = read_wakeup_state();
			if (cur_ts ~= expected_ts or (cur_mode ~= "armed_check" and cur_mode ~= "armed_nocheck")) then
				log.info("MusicBee: Scheduled Check for Updates cancelled");
				return;
			end
			if (cur_mode == "armed_check") then
				log.info("MusicBee: Running scheduled Check for Updates (" .. tostring(PUBLIC_RADIO_DURATION_SEC) .. "s elapsed)");
				do_check_updates();
			end
			log.info("MusicBee: Scheduled Morning Wakeup playlist in 15s");
			tid_morning_wakeup = timer.timeout(function ()
				tid_morning_wakeup = -1;
				local cur_ts2, cur_mode2 = read_wakeup_state();
				if (cur_ts2 ~= expected_ts or (cur_mode2 ~= "armed_check" and cur_mode2 ~= "armed_nocheck")) then
					log.info("MusicBee: Scheduled Morning Wakeup cancelled");
					return;
				end
				cancel_wakeup_timers();
				log.info("MusicBee: Playing scheduled Morning Wakeup playlist (15s after update)");
				do_play_morning_wakeup();
			end, UPDATE_SETTLE_DELAY_MS);
		end, wait_ms);
	end
end

--@help Internal relay tick to keep Morning Wakeup timer alive across 120s HTTP session timeouts
actions.wakeup_tick = function ()
	local ts, mode = read_wakeup_state();
	if (ts == 0 or (mode ~= "armed_check" and mode ~= "armed_nocheck")) then
		return;
	end
	local elapsed = os.difftime(os.time(), ts);
	log.info("MusicBee: Wakeup relay tick (" .. tostring(elapsed) .. "s / " .. tostring(PUBLIC_RADIO_DURATION_SEC) .. "s)");
	schedule_next_wakeup_hop(ts);
end

--@help Play Morning Wakeup playlist
actions.play_morning_wakeup = function ()
	local ts, mode = read_wakeup_state();
	if (ts > 0 and os.difftime(os.time(), ts) < SEQUENCE_WINDOW_SEC) then
		local arm_mode = "armed_nocheck";
		if (mode == "check_queued") then
			arm_mode = "armed_check";
		end
		write_wakeup_state(ts, arm_mode);
		log.info("MusicBee: Armed " .. tostring(PUBLIC_RADIO_DURATION_SEC) .. "s Public Radio relay timer -> Check Updates -> 15s -> Morning Wakeup");
		schedule_next_wakeup_hop(ts);
	else
		cancel_wakeup_timers();
		do_play_morning_wakeup();
	end
end
actions.play_morning_wake_up = actions.play_morning_wakeup;

--@help Play Public Radio Streams playlist
actions.play_public_radio = function ()
	cancel_wakeup_timers();
	local now = os.time();
	write_wakeup_state(now, "radio");
	log.info("MusicBee: Playing Public Radio Streams");
	do_play_public_radio();
end
actions.play_public_radio_streams = actions.play_public_radio;

--@help Run full Morning Wakeup sequence (Public Radio 600s -> Check Updates -> Wait 15s -> Morning Wakeup)
actions.morning_wakeup = function ()
	actions.play_public_radio();
	actions.check_updates();
	actions.play_morning_wakeup();
end


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
