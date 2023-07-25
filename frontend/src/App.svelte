<script lang="ts">
  import { formatDateString } from "./lib/common"
  import { type FullVpnStatus } from "./types"
  import RecentVpnCard from "./class/RecentVpnCard.svelte"

  // 브라우저 테마
  let theme = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches ? "dark" : "light"
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', event => {
    theme = event.matches ? "dark" : "light";
    console.log(`theme changed: ${theme}`)
  })
  console.log(`theme changed: ${theme}`)

  let groups = [
    {
      groupId: "computer1",
      displayName: "컴퓨터 1실",
    }
  ]
  let devices = [
    {
      deviceId: "computer1.22",
      displayName: "22번 컴퓨터",
      groupId: "computer1",
    }
  ]
  let recentVpnStates = [
    {
      eventId: "21312333",
      deviceId: "computer1.22",
      publicIp: "123.123.123.123",
      date: "Tue, 12 Jul 2023 09:31:35 GMT",
    },
    {
      eventId: "21312333",
      deviceId: "computer1.22",
      publicIp: "123.123.123.123",
      date: "Tue, 12 Jul 2023 09:31:35 GMT",
    },
    {
      eventId: "21312333",
      deviceId: "computer1.22",
      publicIp: "123.123.123.123",
      date: "Tue, 12 Jul 2023 09:31:35 GMT",
    },
    {
      eventId: "21312333",
      deviceId: "computer1.22",
      publicIp: "123.123.123.123",
      date: "Tue, 12 Jul 2023 09:31:35 GMT",
    },
    {
      eventId: "21312333",
      deviceId: "computer1.22",
      publicIp: "123.123.123.123",
      date: "Tue, 12 Jul 2023 09:31:35 GMT",
    }
  ]
  let recentInstallStates = [
    {
      eventId: "21312333",
      deviceId: "computer1.22",
      date: "Tue, 12 Jul 2023 09:31:35 GMT",
      publisher: "Colossal Order Ltd",
      installLocation: "D:\\sdf",
      displayName: "Cities: Skylines",
    }
  ]
  function getFullVpnStatus(vpnStatus):FullVpnStatus {
    let device = devices.find(device=>device.deviceId==vpnStatus.deviceId)
    if (!device) throw new Error(`디바이스 ${vpnStatus.deviceId} 를 찾지 못했습니다`)
    let group = groups.find(group=>group.groupId==device.groupId)
    if (!device) throw new Error(`그룹 ${device.groupId} 를 찾지 못했습니다`)

    return {
      deviceId: vpnStatus.deviceId,
      groupId: device.groupId,
      eventId: vpnStatus.eventId,
      groupDisplayName: group.displayName,
      deviceDisplayName: device.displayName,
      displayName: `${group.displayName} - ${device.displayName}`,
      publicIp: vpnStatus.publicIp,
      dateDisplayString: formatDateString(new Date(vpnStatus.date)),
    }
  }
</script>

<main
style:--shadow-color={theme == "dark" ? "rgba(0,0,0,0.3)" : "rgba(0,0,0,0.8)"}
style:--splitter-color={theme == "dark" ? "rgba(127,127,127,0.3)" : "rgba(0,0,0,0.8)"}
style:--card-color={theme == "dark" ? "rgb(36,36,36)" : "rgb(50,50,50)"}
style:--scrollbar-color={theme == "dark" ? "rgb(200,200,200)" : "rgb(60,60,60)"}>
  <div id="header">

  </div>
  <div id="content-recent">

    <div class="card" id="recent-vpn">
      <div class="subtitle-holder">
        <p class="subtitle">최근 vpn 사용 기기</p>
      </div>
      <div class="content">
        {#each recentVpnStates.map(element=>getFullVpnStatus(element)) as state,index}
          <RecentVpnCard state={state} theme={theme}/>
          {#if index+1 != recentVpnStates.length}
            <div class="splitter"/>
          {/if}
        {/each}
      </div>
      {#if recentVpnStates.length == 0}
        <p class="card-placeholder">아무것도 없어요 (한달간 기록이 비어있어요)</p>
      {/if}
      <div class="background"></div>
    </div>
    <div class="card" id="recent-install">
      <div class="subtitle-holder">
        <p class="subtitle">최근 프로그램 설치 내역</p>
      </div>
      <div class="content">

      </div>
      {#if recentInstallStates.length == 0}
        <p class="card-placeholder">아무것도 없어요 (한달간 기록이 비어있어요)</p>
      {/if}
    </div>
  </div>
</main>

<style lang="scss">
  .splitter {
    margin: 8px 0;
    width: 100%;
    height: 2px;
    background-color: var(--splitter-color);
  }

  // 카드스타일
  .card {
    overflow: scroll;
    margin: 12px;
    position: relative;
    box-shadow: 0 4px 8px 0 var(--shadow-color);
    background-color: var(--card-color);

    // 스크롤바 스타일
    &::-webkit-scrollbar-track {
      background: transparent;
    }
    &::-webkit-scrollbar {
      width: 3px;
      height: 3px;
    }
    &::-webkit-scrollbar-thumb {
      border-radius: 2px;
      background: var(--scrollbar-color);
    }

    // 내부 컨텐츠에 패딩
    .content {
      padding: 12px;
      .splitter {
        width: calc(100% + 24px);
        margin: 12px;
        margin-left: -12px;
      }
    }

    // 서브타이틀 (스크롤에 붙어다니게)
    .subtitle-holder {
      background: transparent;
      position: sticky;
      top: 0;
      width: 100%;
      backdrop-filter: blur(12px) brightness(80%);
      -webkit-backdrop-filter: blur(12px) brightness(80%);
      padding-top: 12px;
      padding-bottom: 12px;
      margin-bottom: -12px;
      .subtitle {
        margin-left:12px;
        font-weight: bold;
        font-size: 1em;
      }
    }
  }

  @media (min-width: 820px) {
    #content-recent {
      display: grid;
      grid-template-columns: 1fr 1fr;
      transition: all 1s cubic-bezier(0.165, 0.84, 0.44, 1);
      .card {
        margin: 6px;
        max-height: 300px;
      }
      margin: 6px;
    }
  }
</style>
