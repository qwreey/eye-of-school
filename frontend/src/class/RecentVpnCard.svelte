<script lang="ts">
  import { type FullVpnStatus } from "../types"
  export let state:FullVpnStatus
  export let theme:string

  import DesktopIcon from "../icons/DeviceIcon.svelte"
  import SatelliteIcon from "../icons/SatelliteIcon.svelte"
  import TimerIcon from "../icons/TimerIcon.svelte"
</script>
<!-- ㄹ어;ㅏㄱㅎ러ㅏㅣ ㅎㄴㄹㅇ머 ㅏㅣㅎㄴㄹㅇ  ㅑㅏㅣㅏㅣ; ㄴㄹ어;ㅏㅣㅎㄴㄹ야ㅐㅏㅣㄴㅇ ㅏㅣ ㅑ러 ㅏㅣㅎㄹㅇ  ㅘㅣ  ㅏㅣ ㄴㄹ ㅏㅣ ㄴㄹ어 ㅘㅣ ㄹ ㄴㄹ ㅐㅏㅣ 농 ㅏㅣ ㄴㄹ더 ㅑㅐㅏㅣㅛㅛㅛㅛㅛㅛㅛㅛㅛㅛㅛㅛㅛㅛㅛㅛㅛㅛㅛㅓㅜ , -->
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
<!-- KDLDJUHDRJPIOMGVSFDJPIOMRGVEDJPOMKLRGSEDJI;MLGBSFDGVFDJNI;KLJN;HKLCJGVHGCHFDGHFJUYGHKJTUYHTREWTR6EATY5R8VE IT UY PNHOXCSFDJPIOKRJ;KLTYGFDRFERFERFERFERFERFE쇼86ㅅ75ㅅ75ㅈ54ㄴㄷ셔굥 -->
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
<!-- ㅈㄴㅇ머ㅏㅣㄹ어ㅏㅣㄴㄹㅇ머ㅏㅣㅎㄴㄹ머;ㅘㅣㅓㅜㅏㅣㅎㄹ어 ;ㅘㄱㄹㅇ머;ㅘㅣ휴러ㅏㅣㅠㄹㅇ허;ㅘ,ㅣㅍㄴㄹ;ㅏㅣㅓㄴㄹ어;ㅏㅣㄴㄹㅇ머;ㅏㅣ -->
<!-- ㅓㅓㅏㅓㅏㅘㅘㅓㅘㅗㅓㅏㅘㅘㅗㅓㅏㅘㅘㅣㅗㅗㅗㅗㄹ/ -->