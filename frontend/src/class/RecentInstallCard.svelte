<script lang="ts">
  import { type FullInstallState } from "../types"
  export let state:FullInstallState
  export let theme:string

  import DesktopIcon from "../icons/DeviceIcon.svelte"
  import FolderIcon from "../icons/FolderIcon.svelte"
  import GameIcon from "../icons/GameIcon.svelte"
  import TimerIcon from "../icons/TimerIcon.svelte"
  import UploadIcon from "../icons/UploadIcon.svelte"
</script>
<div class="recent-vpn-card">
  <div class="line">
    <DesktopIcon height="24" width="24" theme={theme}/>
    <p class="name">{state.displayName}</p>
  </div>
  <div class="line">
    <GameIcon height="24" width="24" theme={theme}/>
    <p class="name">{state.appName}</p>
  </div>
  <div class="line">
    <UploadIcon height="24" width="24" theme={theme}/>
    <p class="name">{state.publisher}</p>
  </div>
  <div class="line">
    <FolderIcon height="24" width="24" theme={theme}/>
    <p class="name">{state.installLocation}</p>
  </div>
  <div class="line">
    <TimerIcon height="24" width="24" theme={theme}/>
    <p class="name">{state.dateDisplayString}</p>
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
  p { color: var(--text-color); }
</style>
