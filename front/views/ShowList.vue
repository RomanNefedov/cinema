<script setup>
import FilmCard from '@/components/FilmCard.vue';
import FilmSepLine from '@/components/FilmSepLine.vue';
import DayButton from '@/components/DayButton.vue';
import { useRouter, useRoute } from 'vue-router';
import axios from 'axios';
import { ref, watch } from 'vue'
import serverUrl from "@/config"

let date = new Date()
let dateList = ref([])
let router = useRouter()
let route = useRoute()
for (let i = 0; i < 7; i++) {
    let newDate = new Date(date)
    newDate.setDate(newDate.getDate() + i)
    dateList.value.push(newDate)
}
let filmList = ref()
let loaded = ref(false)
let zeroShows = ref(false)
watch(() => route.params.date, (newDate, oldDate) => {
    getShows()
})

function getShows() {
    axios({
        method: 'get',
        url: serverUrl() + '/shows/' + router.currentRoute.value.params.date,
        headers: {
            "Content-Type": "application/json",
        }
    })
        .then(function (response) {
            let obj = response.data;
            obj = Object.groupBy(obj, ({ filmId }) => filmId)
            filmList.value = Object.entries(obj)
            loaded.value = true
            if (filmList.value.length == 0) {
                zeroShows.value = true;
            } else {
                zeroShows.value = false;
            }
        })
        .catch(function (error) {
            console.log(error);
        });
}

function loadContent() {

}
getShows()

</script>

<template>

    <div class="film_list">
        <div class="mb-5 overflow-x-auto overflow-y-hidden blackspace-nowrap">
            <RouterLink v-for="day in dateList" :to="day.toLocaleDateString('en-CA')">
                <DayButton class="mr-7" :date="day" />
            </RouterLink>

        </div>
        <FilmSepLine class="mb-10" />
        <div v-if="loaded && !zeroShows" v-for="film in filmList">
            <FilmCard :film-id="film[0]" :show-list="film[1]" />
            <FilmSepLine v-if="loaded" class="mb-10" />
        </div>
        <div v-if="loaded && zeroShows" class="text-center text-3xl text-black">Нет показов на этот день ({{
            route.params.date }})
        </div>
    </div>
</template>


<style scoped>
.film_list {
    width: 1200px;
    height: auto;
    display: inline;
    padding-top: 25px;
}
</style>