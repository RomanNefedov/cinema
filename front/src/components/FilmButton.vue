<template>
    <div class="card cursor-pointer h-96 w-fit inline-block rounded-3xl relative">
        <img class="film_img rounded-3xl" draggable="false" :src="film_image_path" alt="">
        <div class="rect rounded-bl-3xl rounded-br-3xl pt-5">
            <div class="text-black text-center font-bold text-lg mb-10">
                {{ film_name }}
            </div>
            <div class="text-black text-center text-lg genres">{{ film_genres.join(", ") }}</div>
        </div>
    </div>


</template>

<script setup>
import { ref } from 'vue'



const props = defineProps({
    film_name: String,
    film_genres: Array,
    film_image_path: String
})

</script>

<style scoped>
.film_img {
    height: 100%;
}

.cropped {
    height: 100%;
    clip-path: inset(20px 50px 10px 0 round 50px);
}

.rect {
    position: absolute;
    width: 100%;
    height: 20%;
    top: 80%;
    background-color: rgba(255, 255, 255, 0.9);

    transition: 0.2s;
}

.card {
    transition: 0.2s;
    overflow: hidden;
    black-space: nowrap;
}

.card:hover {
    .rect {
        top: 60%;
        height: 40%;
    }
}

img {
    pointer-events: none;
}

.card:active {

    transform: scale(0.9);
}
</style>