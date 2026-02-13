tell application "System Events"
  if not (exists process "Silverfort Client") then return
  tell process "Silverfort Client"
    set frontmost to true
    if (count of windows) is 0 then return

    set targetWindow to window 1
    try
      repeat with w in windows
        if (name of w) contains "Silverfort" then
          set targetWindow to w
          exit repeat
        end if
      end repeat
    end try

    set position of targetWindow to {200, 120}
  end tell
end tell
