local keyboard = libs.keyboard;
local win = libs.win;
local device = libs.device;

events.detect = function ()
	return
		libs.fs.exists("C:\\Program Files (x86)\\Mozilla Firefox") or
		libs.fs.exists("C:\\Program Files\\Mozilla Firefox");
end

--@help Focus Firefox application
actions.switch = function()
	if OS_WINDOWS then
		local hwnd = win.window("firefox.exe");
		if (hwnd == 0) then actions.launch(); end
		win.switchtowait("firefox.exe");
	end
end

--@help Launch Firefox application
actions.launch = function()
	if OS_WINDOWS then
		os.start("firefox.exe");
	end
end

--@help Lower volume
actions.volume_down = function()
	actions.switch();
	keyboard.stroke("down");
end

--@help Raise volume
actions.volume_up = function()
	actions.switch();
	keyboard.stroke("up");
end

--@help Rewind
actions.rewind = function()
	actions.switch();
	keyboard.stroke("J");
end

--@help Fast forward
actions.fast_forward = function()
	actions.switch();
	keyboard.stroke("L");
end

--@help Play previous item
actions.previous = function()
	actions.switch();
	keyboard.stroke("shift", "p");
end

--@help Play next item
actions.next = function()
	actions.switch();
	keyboard.stroke("shift", "n");
end

--@help Toggle fullscreen
actions.fullscreen = function()
	actions.switch();
	keyboard.stroke("F");
end

--@help Exit fullscreen
actions.exit_fullscreen = function()
	actions.switch();
	keyboard.stroke("esc");
end

--@help Toggle play/pause
actions.play_pause = function()
	actions.switch();
	keyboard.stroke("K");
end

