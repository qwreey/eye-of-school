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
  <path fill="{stroke}" d="M140-260h680v-280H140v280Zm540.118-90Q701-350 715.5-364.618q14.5-14.617 14.5-35.5Q730-421 715.382-435.5q-14.617-14.5-35.5-14.5Q659-450 644.5-435.382q-14.5 14.617-14.5 35.5Q630-379 644.618-364.5q14.617 14.5 35.5 14.5ZM880-600h-85L695-700H265L165-600H80l142-142q8-8 19.278-13 11.278-5 23.722-5h430q12.444 0 23.722 5T738-742l142 142ZM140-200q-24.75 0-42.375-17.625T80-260v-340h800v340q0 24.75-17.625 42.375T820-200H140Z"/>
</svg>
