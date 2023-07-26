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
  <path fill={stroke} d="M140-160q-24 0-42-18.5T80-220v-520q0-23 18-41.5t42-18.5h281l60 60h339q23 0 41.5 18.5T880-680v460q0 23-18.5 41.5T820-160H140Zm0-60h680v-460H456l-60-60H140v520Zm0 0v-520 520Z"/>
</svg>
