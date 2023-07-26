local http = require "coro-http"
local json = require "json"
local path = require "path"
local timer = require "timer"
local fs = require "fs"
local random = require "random"
local logger = require "logger"
local spawn = require "coro-spawn"

-- 인풋 가져오는 함수
local function readInput() -- 알 필요 없는 끔찍한 기믹으로 구성됨 (루틴 비활성화후 libuv 에서 none block 으로 stdin 을 읽어오고 다시 루틴을 활성화)
    local routine = coroutine.running()
    require"pretty-print".stdin:read_start(coroutine.wrap(function (err, data)
        require"pretty-print".stdin:read_stop()
        coroutine.resume(routine,data)
    end))
    return coroutine.yield()
end

-- 관리자로 프로그램이 실행중인지 확인하는 함수
local function checkPermission()
    return fs.existsSync(path.resolve(path.join(process.env.SYSTEMROOT,"SYSTEM32/WDI/LOGFILES")))
end

-- 설치
local configPath = path.join(os.getenv("LOCALAPPDATA"),"eos.json")
local copyTo = path.join(os.getenv("LOCALAPPDATA"),"eos.exe")
if true or args[1] == "install" then
    if not checkPermission() then
        logger.error("관리자 권한이 아님.")
        process:exit(1)
        return
    end

    process.stdout:write("등록에 사용할 deviceId 입력 ... > ")
    local deviceId = readInput()

    fs.writeFileSync(configPath,
        json.encode({
            deviceId = deviceId;
            programs = {};
        })
    )
    fs.writeFileSync(copyTo,fs.readFileSync(args[0])) -- 자가복제

    logger.info("스캐쥴 등록중")
    spawn("schtasks",{ -- 이미 있던 스캐줄 제거
        args = {
            "/delete",
            "/f",
            "/tn","VPNCHECKER"
        },
        stdio = {0,1,2}
    }).waitExit()
    local errorCode = spawn("schtasks",{ -- 스캐줄 등록
        args = {
            "/create",
            "/tn","VPNCHECKER", -- 스캐줄 이름 지정
            "/tr", copyTo,
            "/sc","onlogon" -- 로그인시 사용되도록 지정
        },
        stdio = {0,1,2}
    }).waitExit()
    -- 오류 발생시
    if errorCode ~= 0 then
        logger.error("오류가 발생했습니다. 설치 명령은 관리자 권한을 필요로 하므로\n관리자 권한으로 cmd 를 실행하였는지 확인해주세요")
        readInput()
        process:exit(1)
    else
        logger.infof("명령 %s 가 등록되었습니다.",copyTo)
        readInput()
        process:exit(0)
    end
    return
end

-- 설정 읽음
local config = json.decode(fs.readFileSync(configPath))
local deviceId = config.deviceId

-- allowed ip 가져오기
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

-- vpn 기록
local function recordVPN(thisIP)
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
                local ok2,err = pcall(recordVPN,thisIP)
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
