local http = require "coro-http"
local json = require "json"
local path = require "path"
local timer = require "timer"
local fs = require "fs"
local random = require "random"
local logger = require "logger"

-- 설정 읽음
local configPath = path.join(os.getenv("LOCALAPPDATA"),"eos.json")
local config = json.decode(fs.readFileSync(configPath))
local deviceId = config.deviceId

-- allowed ip
local allowedIps
local function getAllowedIps()
    local header,body = http.request("POST","https://eos.qwreey.kr/api/get-allowed-ips",{{"Content-type","application/json"}},json.encode({
        deviceId = deviceId;
    }))
    allowedIps = json.decode(body)
end
while true do
    local ok,err = pcall(getAllowedIps)
    if ok then break end
    logger.errorf("error on get allowed ips %s",err)
    timer.sleep(3000)
end

local lastTriggerIp -- 가장 최근 트리거 아이피

-- 내 아이피 얻어옴
local function getIP()
    local header,body = http.request("GET","https://eos.qwreey.kr/api/get-my-ip")
    return body
end

-- 입력한 아이피가 allowed 상태인지 확인
local function checkIpAllowed(ip)
    if type(allowedIps) ~= "table" then return false end
    for _,allowedIp in pairs(allowedIps) do
        if allowedIp == ip then return true end
    end
    return false
end

local function record(thisIP)
    local header,body = http.request("POST","https://eos.qwreey.kr/api/insert-event",{{"Content-type","application/json"}},json.encode({
        deviceId = deviceId;
        type = "VpnState";
        eventId = random.makeId();
        publicIp = thisIP;
    }))
end

-- 확인 루프
coroutine.wrap(function ()
    while true do
        -- IP 얻고 allowed 상태 확인
        local ok,thisIP = pcall(getIP)
        if ok then
            local isAllowed = checkIpAllowed(thisIP)

            -- allowed 아님! (반복 아닌경우)
            if (not isAllowed) and thisIP ~= lastTriggerIp then
                lastTriggerIp = thisIP
                logger.infof("아이피 변동 감지. 새 아이피 %s",thisIP)
                -- 이벤트 기록
                local ok2,err = pcall(record,thisIP)
                if not ok2 then logger.info("error on record %s",err) end
            end

            -- vpn 껐으면 초기화
            if isAllowed then
                lastTriggerIp = nil
            end
        else
            logger.errorf("error on ip get request %s",thisIP)
        end
        timer.sleep(30000) -- 30 초 쉼
    end
end)()
