local lib = LibStub and LibStub("LibRetail", true)
if not lib then return end

local waitTable = {};
local waitFrame = nil;

function lib.After (delay, func, ...)
  -- print("dupa")
  if(type(delay)~="number" or type(func)~="function") then
    return false;
  end
  if(waitFrame == nil) then
    waitFrame = CreateFrame("Frame","WaitFrame", UIParent);
    waitFrame:SetScript("onUpdate",function (self,elapse)
      local count = #waitTable;
      local i = 1;
      while(i<=count) do
        local waitRecord = tremove(waitTable,i);
        local d = tremove(waitRecord,1);
        local f = tremove(waitRecord,1);
        local p = tremove(waitRecord,1);
        if(d>elapse) then
          tinsert(waitTable,i,{d-elapse,f,p});
          i = i + 1;
        else
          count = count - 1;
          f(unpack(p));
        end
      end
    end);
  end
  tinsert(waitTable,{delay,func,{...}});
  return true;
end

local TickerPrototype = {};
local TickerMetatable = {
	__index = TickerPrototype,
	__metatable = true,	--Probably not needed, but if I don't put this here someone is going to mess with this metatable and end up tainting everything...
};

--Creates and starts a ticker that calls callback every duration seconds for N iterations.
--If iterations is nil, the ticker will loop until cancelled.
--
--If callback throws a Lua error, the ticker will stop firing.
function lib.NewTicker(duration, callback, iterations)
  -- print("cnewticker")
	local ticker = setmetatable({}, TickerMetatable);
	ticker._remainingIterations = iterations;
	ticker._callback = function()
		if ( not ticker._cancelled ) then
			callback(ticker);

			--Make sure we weren't cancelled during the callback
			if ( not ticker._cancelled ) then
				if ( ticker._remainingIterations ) then
					ticker._remainingIterations = ticker._remainingIterations - 1;
				end
				if ( not ticker._remainingIterations or ticker._remainingIterations > 0 ) then
					lib.After(duration, ticker._callback);
				end
			end
		end
	end;

	lib.After(duration, ticker._callback);
	return ticker;
end

--Creates and starts a cancellable timer that calls callback after duration seconds.
--Note that C_Timer.NewTimer is significantly more expensive than C_Timer.After and should
--only be used if you actually need any of its additional functionality.
--
--While timers are currently just tickers with an iteration count of 1, this is likely
--to change in the future and shouldn't be relied on.
function lib.NewTimer(duration, callback)
	return lib.NewTicker(duration, callback, 1);
end

--Cancels a ticker or timer. May be safely called within the ticker's callback in which
--case the ticker simply won't be started again.
--Cancel is guaranteed to be idempotent.
function TickerPrototype:Cancel()
	self._cancelled = true;
end

function TickerPrototype:IsCancelled()
	return self._cancelled;
end
