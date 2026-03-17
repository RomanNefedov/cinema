<template>
    <div class="show_container">
        <div class="time_and_money">
            <div class="time">{{ date.toLocaleDateString("ru", dateOptions) }}</div>
            <div class="day" v-if="date.getDate() != new Date().getDate()">{{ date.toLocaleDateString("ru", weekDay) }}
            </div>
            <div class="day" v-else>{{ "сегодня" }}</div>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue'
const props = defineProps({
    date: Date,
})
let dateOptions = {
    day: "numeric",
    month: "long"
}
let weekDay = {
    weekday: "long",
}

</script>

<style scoped>
.show_container {
    width: 140px;
    display: inline-block;
    text-align: center;
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

.day {
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