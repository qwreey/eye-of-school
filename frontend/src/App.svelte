<script lang="ts">
  import { formatDateString } from "./lib/common"
  import { type FullVpnStatus } from "./types"
  import RecentVpnCard from "./class/RecentVpnCard.svelte";
  //(new Date()).toUTCString()

  // 브라우저 테마
  let theme = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches ? "dark" : "light"
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', event => {
    theme = event.matches ? "dark" : "light";
  })

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
    }
  ]
  // let recentInstallStatus = []

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

<main>
  <div id="header">

  </div>
  <div id="content">

    <div id="recent">
      <p class="subtitle">최근 vpn 사용 기기</p>
      <div id="recent-vpn">
        {#each recentVpnStates.map(element=>getFullVpnStatus(element)) as state}
         <RecentVpnCard state={state} theme={theme}/>
        {/each}
      </div>
      <p class="subtitle">최근 프로그램 설치 내역</p>

    </div>
  </div>
</main>

<style>
</style>
