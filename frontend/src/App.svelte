<script lang="ts">
  import { formatDateString } from "./lib/common"
  import {
    type FullVpnState,
    type FullInstallState,
    type VpnState,
    type InstallState,
    type Device,
    type Group
  } from "./types"
  import RecentVpnCard from "./class/RecentVpnCard.svelte"
  import RecentInstallCard from "./class/RecentInstallCard.svelte"
  import LoadingCircle from "./icons/LoadingCircle.svelte"
  import { onMount } from "svelte"
  import axios from "axios"
  import ReloadIcon from "./icons/ReloadIcon.svelte"

  const apiURL = "https://eos.qwreey.kr/api"

  // 브라우저 테마
  let theme = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches ? "dark" : "light"
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', event => {
    theme = event.matches ? "dark" : "light"
  })

  // 데이터들
  let groups:Group[] = []
  let devices:Device[] = []
  let recentVpnStates:VpnState[] = []
  let recentInstallStates:InstallState[] = []

  let loading:boolean = true

  function getFullInstallState(installState:InstallState):FullInstallState {
    let device = devices.find(device=>device.deviceId==installState.deviceId)
    if (!device) throw new Error(`디바이스 ${installState.deviceId} 를 찾지 못했습니다`)
    let group = groups.find(group=>group.groupId==device.groupId)
    if (!device) throw new Error(`그룹 ${device.groupId} 를 찾지 못했습니다`)

    return {
      deviceId: installState.deviceId,
      groupId: device.groupId,
      eventId: installState.eventId,
      groupDisplayName: group.displayName,
      deviceDisplayName: device.displayName,
      displayName: `${group.displayName} - ${device.displayName}`,
      dateDisplayString: formatDateString(new Date(installState.date)),
      appName: installState.appName,
      publisher: installState.publisher,
      installLocation: installState.installLocation,
    }
  }
  function getFullVpnState(vpnState:VpnState):FullVpnState {
    let device = devices.find(device=>device.deviceId==vpnState.deviceId)
    if (!device) throw new Error(`디바이스 ${vpnState.deviceId} 를 찾지 못했습니다`)
    let group = groups.find(group=>group.groupId==device.groupId)
    if (!device) throw new Error(`그룹 ${device.groupId} 를 찾지 못했습니다`)

    return {
      deviceId: vpnState.deviceId,
      groupId: device.groupId,
      eventId: vpnState.eventId,
      groupDisplayName: group.displayName,
      deviceDisplayName: device.displayName,
      displayName: `${group.displayName} - ${device.displayName}`,
      publicIp: vpnState.publicIp,
      dateDisplayString: formatDateString(new Date(vpnState.date)),
    }
  }

  async function fetchDatasFromAPI() {
    let result:{data:{devices:Device[],groups:Group[],recentEvents:(VpnState|InstallState)[]}} =
    await axios.post(apiURL + "/bulk-fetch",{
      groups: true, devices: true, recentEvents: { period: 2592000 }
    })

    groups = result.data.devices
    devices = result.data.devices
    recentInstallStates = result.data.recentEvents.filter(element=>element.type == "InstallState") as unknown as InstallState[]
    recentVpnStates = result.data.recentEvents.filter(element=>element.type == "VpnState") as unknown as VpnState[]
  }

  onMount(async()=>{
    await fetchDatasFromAPI()
    loading = false
    console.log("loaded")
    setInterval(fetchDatasFromAPI,60000)
  })
</script>

<main
style:--shadow-color={theme == "dark" ? "rgba(0,0,0,0.3)" : "rgba(0,0,0,0.3)"}
style:--splitter-color={theme == "dark" ? "rgba(127,127,127,0.2)" : "rgba(0,0,0,0.1)"}
style:--card-color={theme == "dark" ? "rgb(36,36,36)" : "rgb(248,248,248)"}
style:--scrollbar-color={theme == "dark" ? "rgb(200,200,200)" : "rgb(60,60,60)"}
style:--main-background={theme == "dark" ? "rgb(30, 30, 30)" : "rgb(255, 255, 255)"}
style:--text-color={theme == "dark" ? "rgba(255, 255, 255, 0.89)" : "rgba(0, 0, 0, 0.87)"}>
  <div class="header">
    <div class="placeholder"></div>
    <p class="title">사용현황 관리 콘솔</p>
    <button class="reload" on:click={async ()=>{
      if (loading) return
      loading = true
      await fetchDatasFromAPI()
      loading = false
    }}>
      <ReloadIcon height="30" width="30" theme={theme}/>
    </button>
  </div>
  <div id="content-recent">
    <div class="card" id="recent-vpn">
      <div class="subtitle-holder">
        <p class="subtitle">최근 vpn 사용 기기</p>
      </div>
      {#if recentVpnStates.length == 0 && !loading}
      <p class="card-placeholder">아무것도 없어요 (한달간 기록이 비어있어요)</p>
      {:else if !loading || recentVpnStates.length !== 0}
      <div class="content">
        {#each recentVpnStates.map(element=>getFullVpnState(element)) as state,index}
        <RecentVpnCard state={state} theme={theme}/>
        {#if index+1 != recentVpnStates.length}
        <div class="splitter"/>
        {/if}
        {/each}
      </div>
      {:else if loading}
      <div class="loading-circle-holder">
        <LoadingCircle width="30" height="30"/>
      </div>
      {/if}
      <div class="background"></div>
    </div>
    <div class="card" id="recent-install">
      <div class="subtitle-holder">
        <p class="subtitle">최근 프로그램 설치 내역</p>
      </div>
      {#if recentInstallStates.length == 0 && !loading}
      <p class="card-placeholder">아무것도 없어요 (한달간 기록이 비어있어요)</p>
      {:else if !loading || recentInstallStates.length !== 0}
      <div class="content">
        {#each recentInstallStates.map(element=>getFullInstallState(element)) as state,index}
        <RecentInstallCard state={state} theme={theme}/>
        {#if index+1 != recentInstallStates.length}
        <div class="splitter"/>
        {/if}
        {/each}
      </div>
      {:else if loading}
      <div class="loading-circle-holder">
        <LoadingCircle width="30" height="30"/>
      </div>
      {/if}
    </div>
  </div>
</main>

<style lang="scss">
  main {
    height: 100%;
    background-color: var(--main-background);
  }
  p {
    color: var(--text-color)
  }

  .splitter {
    margin: 8px 0;
    width: 100%;
    height: 2px;
    background-color: var(--splitter-color);
  }

  // 해더
  .header {
    .placeholder {
      width: 50px;
    }
    .reload {
      width: 50px;
      justify-content: center;
      align-items: center;
      display: flex;
      height: 100%;
      background: none;
      border: none;
      cursor: pointer;
    }
    p {
      margin: auto;
    }
    flex-wrap: wrap;
    position: sticky;
    top: 0px;
    z-index: 20;
    width: 100%;
    height: 50px;
    backdrop-filter: blur(8px) brightness(85%);
    -webkit-backdrop-filter: blur(8px) brightness(85%);
    display: flex;
    justify-content: center;
    align-items: center;
    .title {
      font-size: 1.2em;
    }
  }

  // 카드스타일
  .card {
    // 아무것도 없어요 텍스트
    .card-placeholder {
      margin: 20px 0 12px 12px;
    }

    // 로딩 서클
    .loading-circle-holder {
      margin-top: 24px;
      height: 40px;
      width: 100%;
      display: flex;
      justify-content: center;
    }

    overflow: auto;
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
      padding: 22px 12px 12px 12px;
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
      backdrop-filter: blur(12px) brightness(85%);
      -webkit-backdrop-filter: blur(12px) brightness(85%);
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

  // 최근 상황 카드 그리드/리스트 조절
  @media (min-width: 820px) {
    #content-recent {
      height: calc(100% - 50%);
      display: grid;
      grid-template-columns: 1fr 1fr;
      transition: all 1s cubic-bezier(0.165, 0.84, 0.44, 1);
      .card {
        max-height: calc(100% - 12px);
        // max-height: 360px;
        margin: 6px;
      }
      margin: 6px;
    }
  }
</style>
