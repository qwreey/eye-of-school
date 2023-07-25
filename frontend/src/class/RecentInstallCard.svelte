<script lang="ts">
  import { type FullVpnStatus } from "../types"
  export let state:FullVpnStatus
  export let theme:string

  import DesktopIcon from "../icons/DeviceIcon.svelte"
  import SatelliteIcon from "../icons/SatelliteIcon.svelte"
  import TimerIcon from "../icons/TimerIcon.svelte"
</script>
<div class="recent-vpn-card">
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
<style lang="scss">
  .recent-vpn-card {
    margin-top: 4px;
    margin-bottom: 2px;
    .line {

      p {
        margin-left: 6px;
        font-size: 0.96em;
      }
      margin-bottom: 2px;
      display: flex;
      flex-direction: row;
    }
  }
</style>
