<script lang="ts">
  import { type FullVpnStatus } from "../types"
  export let state:FullVpnStatus
  export let theme:string

  import DesktopIcon from "../icons/DeviceIcon.svelte"
  import SatelliteIcon from "../icons/SatelliteIcon.svelte"
  import TimerIcon from "../icons/TimerIcon.svelte"
</script>

<div class="recent-vpn-card">
  대충아이콘으로 모니터모양, 시계모양, 편지모양이 각 글자 앞에 있다고 생각하자
  <div class="line">
    <DesktopIcon height="24" width="24" theme={theme}/>
    <p class="name">{state.displayName}</p>
  </div>
  <div class="line">
    <TimerIcon height="24" width="24" theme={theme}/>
    <p class="name">{state.dateDisplayString}</p>
    
  </div>
  <div class="line">
    <SatelliteIcon height="24" width="24" theme={theme}/>
    <p class="name">{state.publicIp}</p>
  </div>
</div>
