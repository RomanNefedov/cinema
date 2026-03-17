<template>
    <div v-if="loaded" class="film_container">
        <img class="film_img" :src="serverUrl() + '/films/image?path=' + film.imagePath" alt="">
        <div class="film_desc">
            <div class="age_restrict">{{ film.ageRating + '+' }}</div>
            <div class="film_name">{{ film.name }}</div>
            <div class="film_genres">{{ film.genres.join(", ") }}</div>
            <div class="film_duration">{{ getHM(film.duration) }}</div>
        </div>
        <div class="film_shows">
            <RouterLink class="w-24 h-20 mr-4 mb-4" v-for="show in showList" :to="'/orders/' + show.id">
                <ShowButton :time="new Date(show.date).toLocaleTimeString('ru', { hour: 'numeric', minute: 'numeric' })"
                    :money="show.basePrice" :hall_type="show.hallType" :key="console.log(show)" />
            </RouterLink>
        </div>

    </div>
</template>

<script setup>
import ShowButton from './ShowButton.vue';
import axios from 'axios';
import serverUrl from "@/config"
import getHM from "@/functions/minsToHM";
import { ref, watch } from 'vue';

const props = defineProps({
    filmId: String,
    showList: Array
})

watch(() => props.filmId, (newFilmId, oldFilmId) => {
    getFilm()
})

const film = ref()
let loaded = ref(false)

getFilm()
function getFilm() {
    axios({
        method: 'get',
        url: serverUrl() + '/films/' + props.filmId,
        headers: {
            "Content-Type": "application/json",
        }
    })
        .then(function (response) {
            film.value = response.data;
            loaded.value = true;
            console.log(film.value)
        })
        .catch(function (error) {
            console.log(error);
        });

}


</script>

<style scoped>
.film_container {
    width: 100%;
    height: 400px;
    display: flex;
    margin-bottom: 50px;
}

.film_img {
    height: 100%;
    border-radius: 10px;
    margin-right: 20px;
}

.film_desc {
    width: 200px;
    height: 100%;
    color: rgb(136, 136, 136);
    margin-right: 20px;
}

.age_restrict {
    width: 35px;
    height: 25px;
    line-height: 25px;
    background-color: rgb(255, 255, 255);
    color: black;
    border: solid;
    border-radius: 5px;
    border-width: 1px;
    text-align: center;

    margin-bottom: 20px;
}

.film_name {
    color: black;
    font-weight: bold;
    font-size: 20px;
    margin-bottom: 20px;
}

.film_shows {
    width: 695px;
    height: 100%;
    display: flex;
    flex-wrap: wrap;
    color: rgb(136, 136, 136);
}

.show_container {
    width: 100px;
    height: 80px;
    display: block;
    text-align: center;
    margin-right: 15px;
}

.show_container:hover div {
    color: rgb(135, 135, 255);
    cursor: pointer;
    transition: 0.4s;
}

.time_and_money {
    color: black;
    border: solid;
    text-align: center;
    border-width: 2px;
    border-radius: 10px;
}

.money {
    color: rgb(136, 136, 136);
}

.film_sep_line {
    width: 100%;
    color: rgb(136, 136, 136);
    height: 2px;
    border-radius: 1px;
    background-color: rgb(136, 136, 136);
    margin-bottom: 50px;
}
</style>