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

<svg xmlns="http://www.w3.org/2000/svg" height={height} viewBox="0 -960 960 960" width={width}>
    <path fill={stroke} d="M450-313v-371L330-564l-43-43 193-193 193 193-43 43-120-120v371h-60ZM220-160q-24 0-42-18t-18-42v-143h60v143h520v-143h60v143q0 24-18 42t-42 18H220Z"/>
</svg>
