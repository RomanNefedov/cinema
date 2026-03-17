<script setup>
import router from '@/router/router';
import FilmButton from '@/components/FilmButton.vue';
import { ref, watch } from 'vue'
import axios from 'axios'

import serverUrl from "@/config"

const film_model = {
    name: ""
}

const film_list = ref()
let loaded = ref(false)
axios({
    method: 'get',
    url: serverUrl() + '/films',
    headers: {
        "Content-Type": "application/json",
    }
})
    .then(function (response) {
        console.log(response.data);
        film_list.value = response.data;
        console.log(film_list.value)
        for (let i = 0; i < film_list.value.length; i++) {
            console.log(i)
        }

    })
    .catch(function (error) {
        console.log(error);
    });



</script>

<template>
    <div class="panel">
        <RouterLink v-for="film in film_list" :to="'/films/' + film.id">
            <FilmButton class="mr-11 mb-11" :film_name="film.name" :film_genres="film.genres" :film_id="film.id"
                :film_image_path="serverUrl() + '/films/image?path=' + film.imagePath">
            </FilmButton>
        </RouterLink>

    </div>
</template>

<style scoped>
.panel {
    width: 1300px;
    height: auto;
    justify-content: space-between;
    display: flex;
    flex-wrap: wrap;
    padding-top: 25px;
}
</style>