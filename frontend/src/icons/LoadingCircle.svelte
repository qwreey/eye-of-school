<script lang="ts">
    export let width:string
    export let height:string
</script>

<svg width={width} height={height} viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
    <circle cx="50" cy="10" r="10" fill="#8525FF"/>
    <circle cx="84.641" cy="70" r="10" transform="rotate(120 84.641 70)" fill="#8525FF"/>
    <path fill-rule="evenodd" clip-rule="evenodd" d="M92.8681 75.7503C97.3958 68.229 100 59.4186 100 50C100 22.3858 77.6142 0 50 0V20C66.5685 20 80 33.4315 80 50C80 55.4653 78.5385 60.5893 75.9851 65.0025L93.3013 75L92.8681 75.7503Z" fill="#811EFF"/>
    <path fill-rule="evenodd" clip-rule="evenodd" d="M50 100C77.6142 100 100 77.6142 100 50C100 22.3858 77.6142 0 50 0C22.3858 0 0 22.3858 0 50C0 77.6142 22.3858 100 50 100ZM50 80C66.5685 80 80 66.5685 80 50C80 33.4315 66.5685 20 50 20C33.4315 20 20 33.4315 20 50C20 66.5685 33.4315 80 50 80Z" fill="#7000FF" fill-opacity="0.4"/>
</svg>

<style lang="scss">
    @keyframes rotate {
        from {
            transform: rotate(0deg);
        }
        to {
            transform: rotate(360deg);
        }
    }
    svg {
        animation: 1s linear 0s infinite forwards rotate;
    }
</style>