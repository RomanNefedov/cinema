<template>
    <div class="show_container">
        <div class="time_and_money">
            <div class="time">{{ time }}</div>
            <div class="money">{{ 'от ' + money + 'Р' }}</div>
        </div>
        <div class="hall_type">{{ hall_type }}</div>
    </div>
</template>

<script setup>
let props = defineProps({
    time: String,
    money: Number,
    hall_type: String
})
</script>

<style scoped>
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