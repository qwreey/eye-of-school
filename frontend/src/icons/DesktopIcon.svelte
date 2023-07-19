<script lang="ts">
  export let theme:string
  export let width:string
  export let height:string

  let stroke:string
  $: {
    switch (theme) {
      case "dark":
      case "Dark":
        stroke = "white"
        break
      case "light":
      case "Light":
        stroke = "black"
        break
    }
  }
</script>

<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 -960 960 960">
  <path fill="{stroke}" d="M260-120v-73l47-47H140q-24 0-42-18t-18-42v-480q0-24 18-42t42-18h680q24 0 42 18t18 42v480q0 24-18 42t-42 18H652l48 47v73H260ZM140-300h680v-480H140v480Zm0 0v-480 480Z"/>
</svg>
