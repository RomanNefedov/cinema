<template>
    <div v-if="loaded && found" class="panel">
        <div class="flex w-full mb-7">
            <img class="h-96 flex mr-4 rounded-xl" :src="serverUrl() + '/films/image?path=' + film.imagePath" alt="">
            <div>
                <div class="text-black font-bold text-3xl mb-5">{{ film.name }}</div>
                <div class="flex text-black mb-2">
                    <div class="mr-1 w-60">Жанры:</div>
                    <div>{{ film.genres.join(", ") }}</div>
                </div>
                <div class="flex text-black mb-2">
                    <div class="mr-1 w-60">Режиссер:</div>
                    <div>{{film.directors.map((item) => item.nameAndSurname).join(", ")}}</div>
                </div>
                <div class="flex text-black mb-2">
                    <div class="mr-1 w-60">В ролях:</div>
                    <div>{{film.actors.map((item) => item.nameAndSurname).join(", ")}}</div>
                </div>
                <div class="flex text-black mb-2">
                    <div class="mr-1 w-60">Страна:</div>
                    <div>{{ film.countries.join(", ") }}</div>
                </div>
                <div class="flex text-black mb-2">
                    <div class="mr-1 w-60">Продолжительность:</div>
                    <div>{{ getHM(film.duration) }}</div>
                </div>
                <div class="flex text-black mb-2">
                    <div class="mr-1 w-60">Мировая премьера:</div>
                    <div>{{ film.worldPremiereDate }}</div>
                </div>
            </div>
        </div>
        <div class="block">
            <div class="text-black font-bold text-3xl mb-5">Описание фильма</div>
            <div class="text-black inline break-words">
                {{ film.description }}
            </div>
        </div>

    </div>
    <div class="text-black font-bold text-9xl mb-5" v-if="!found && loaded">Фильм не найден</div>
</template>

<script setup>
import router from '@/router/router';
import getHM from "@/functions/minsToHM";
import axios from 'axios';
import { ref } from 'vue'
import serverUrl from "@/config"

console.log(router.currentRoute.value.params.id)

let film = ref()
let loaded = ref(false)
let found = ref(false)
axios({
    method: 'get',
    url: serverUrl() + '/films/' + router.currentRoute.value.params.id,
    headers: {
        "Content-Type": "application/json",
    }
})
    .then(function (response) {
        console.log(response.data);
        film.value = response.data;
        loaded.value = true;
        if (response.data != null)
            found.value = true;
    })
    .catch(function (error) {
        console.log(error);
    });
</script>

<style scoped>
.panel {
    width: 1200px;
    height: auto;
    display: block;
    padding-top: 25px;
}
</style>