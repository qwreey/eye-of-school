local http = require "coro-http"
local json = require "json"
local path = require "path"
local timer = require "timer"
local fs = require "fs"
local random = require "random"
local promise = require "promise"
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

-- dict2hashmap
local function dict2hashmap(dict)
    local hashmap = {}
    for i,v in pairs(dict) do
        hashmap[v] = true
    end
    return hashmap
end
local function hashmap2dict(hashmap)
    local dict = {}
    for i,v in pairs(hashmap) do
        table.insert(dict,i)
    end
    return dict
end

-- 설치된 프로그램 목록 가져옴
local function getInstalledPrograms()
    local wow64 = spawn("reg",{ -- 스캐줄 등록
        args = {
            "QUERY",
            [[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall]]
        },
        stdio = {0,true,true}
    })
    local currwow64 = spawn("reg",{ -- 스캐줄 등록
        args = {
            "QUERY",
            [[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall]]
        },
        stdio = {0,true,true}
    })
    local wow32 = spawn("reg",{ -- 스캐줄 등록
        args = {
            "QUERY",
            [[HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall]]
        },
        stdio = {0,true,true}
    })
    local currwow32 = spawn("reg",{ -- 스캐줄 등록
        args = {
            "QUERY",
            [[HKEY_CURRENT_USER\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall]]
        },
        stdio = {0,true,true}
    })

    wow64.waitExit()
    currwow64.waitExit()
    wow32.waitExit()
    currwow32.waitExit()

    local stdout = {}
    for str in wow64.stdout.read do
        table.insert(stdout,str)
    end
    for str in currwow64.stdout.read do
        table.insert(stdout,str)
    end
    for str in wow32.stdout.read do
        table.insert(stdout,str)
    end
    for str in currwow32.stdout.read do
        table.insert(stdout,str)
    end
    local programs = {}
    for prog in table.concat(stdout,"\n"):gsub("\r",""):gmatch("[^\n]+") do
        table.insert(programs,prog)
    end

    return programs
end
local function getProgramInfo(regdir)
    local reg = spawn("reg",{ -- 스캐줄 등록
        args = {
            "QUERY",
            regdir
        },
        stdio = {0,true,2}
    })
    reg.waitExit()

    local stdout = {}
    for str in reg.stdout.read do
        table.insert(stdout,str)
    end
    local str = table.concat(stdout,"\n")

    return {
        appName = str:match(" *DisplayName *REG_SZ *([^\n\r]+)");
        installLocation = str:match(" *InstallLocation *REG_SZ *([^\n\r]+)");
        publisher = str:match(" *Publisher *REG_SZ *([^\n\r]+)");
    }
end

-- 설치
local configPath = path.join(os.getenv("LOCALAPPDATA"),"eos.json")
local copyTo = path.join(os.getenv("LOCALAPPDATA"),"eos.exe")
local scriptTo = path.join(os.getenv("LOCALAPPDATA"),"eos.vbs")
if args[1] == "install" then
    if not checkPermission() then
        logger.error("관리자 권한이 아님.")
        process:exit(1)
        return
    end

    process.stdout:write("등록에 사용할 deviceId 입력 ... > ")
    local deviceId = readInput():gsub("[\n\r]+","")

    fs.writeFileSync(configPath,
        json.encode({
            deviceId = deviceId;
            programs = getInstalledPrograms();
        })
    )
    fs.writeFileSync(copyTo,fs.readFileSync(args[0])) -- 자가복제
    fs.writeFileSync(scriptTo,[[Set oShell = CreateObject ("Wscript.Shell")
Dim strArgs
strArgs = "]]..copyTo..[["
oShell.Run strArgs, 0, false
]])

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
            "/tr", scriptTo,
            "/sc","onlogon" -- 로그인시 사용되도록 지정
        },
        stdio = {0,1,2}
    }).waitExit()
    -- 오류 발생시
    if errorCode ~= 0 then
        logger.error("오류가 발생했습니다. 설치 명령은 관리자 권한을 필요로 하므로\n관리자 권한으로 cmd 를 실행하였는지 확인해주세요")
        logger.info("엔터를 눌러 종료합니다")
        readInput()
        process:exit(1)
    else
        logger.infof("명령 %s 가 등록되었습니다.",copyTo)
        logger.info("엔터를 눌러 종료합니다")
        readInput()
        process:exit(0)
    end
    return
end

-- 설정 읽음
local config = json.decode(fs.readFileSync(configPath))
local deviceId = config.deviceId

-- save config
local function saveConfig()
    fs.writeFileSync(configPath,json.encode(config))
end

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
        deviceId = deviceId:gsub("[\n\r]+","");
        type = "VpnState";
        eventId = random.makeId();
        publicIp = thisIP;
    }))
end

local function recordInstall(thisInstall)
    local header,body = http.request("POST","https://eos.qwreey.kr/api/insert-event",{{"Content-type","application/json"}},json.encode({
        deviceId = deviceId:gsub("[\n\r]+","");
        type = "InstallState";
        eventId = random.makeId();
        appName = thisInstall.appName;
        installLocation = thisInstall.installLocation;
        publisher = thisInstall.publisher;
    }))
    logger.info(body)
end

local function main_checkip()
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
end
local function main_checkprog()
    local nowPrograms = getInstalledPrograms()
    local oldProgramsHash = dict2hashmap(config.programs)
    local installedPrograms = {}
    local waitter = promise.waitter()
    for _,v in ipairs(nowPrograms) do
        if not oldProgramsHash[v] then
            waitter:add(promise.new(function()
                table.insert(installedPrograms,getProgramInfo(v))
            end))
        end
    end
    waitter:wait()
    if #installedPrograms ~= 0 then
        -- 추가된게 있음
        for _,v in ipairs(installedPrograms) do
            recordInstall(v)
            logger.infof("설치 기록됨 %s",v.appName)
        end
        config.programs = nowPrograms
        saveConfig()
        return
    end
    -- 지운경우
    local nowProgramsHash = dict2hashmap(nowPrograms)
    local changed
    for _,v in ipairs(config.programs) do
        if not nowProgramsHash[v] then
            changed = true
            logger.infof("프로그램 지워짐 %s",v)
        end
    end
    if changed then
        config.programs = nowPrograms
        saveConfig()
    end
end

-- 확인 루프
coroutine.wrap(function ()
    while true do
        local pass,result

        -- IP 얻고 allowed 상태 확인
        pass,result = pcall(main_checkip)
        if not pass then logger.errorf("fail checkip %s",result) end

        -- 프로그램 확인
        pass,result = pcall(main_checkprog)
        if not pass then logger.errorf("fail checprog %s",result) end

	logger.info("ok")
        timer.sleep(60000) -- 60 초 쉼
    end
end)()
