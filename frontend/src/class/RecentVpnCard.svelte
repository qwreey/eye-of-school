<script lang="ts">
  import { type FullVpnStatus } from "../types";
  export let state:FullVpnStatus
</script>

<div class="recent-vpn-card">
  대충아이콘으로 모니터모양, 시계모양, 편지모양이 각 글자 앞에 있다고 생각하자
  <p class="name">{state.displayName}</p>
  <p class="name">{state.dateDisplayString}</p>
  <p class="name">{state.publicIp}</p>
</div>
