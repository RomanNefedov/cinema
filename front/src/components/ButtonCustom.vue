<script setup>
const props = defineProps({
    text: String,
})
</script>

<template>

    <button class="p-2 bg-white text-cyan-50 border-solid border-black border-2 rounded-lg">{{ text }}</button>
</template>


<style scoped>
button {
    transition: 0.2s;
}

button:hover {
    transform: scale(1.1);
}

button:active {
    transform: scale(0.9);
}
</style>
