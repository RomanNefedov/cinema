<script setup>
import Header from './components/Header.vue';
import ShowList from './views/ShowList.vue';
import {ref} from 'vue'
localStorage.setItem("ROLE",100)
</script>

<template>

    <Header></Header>
    <main>
        <RouterView />
    </main>

</template>

<style scoped>
main {
    width: 100%;
    height: 1000px;
    display: flex;
    justify-content: center;
}
</style>
