<template>
    <header>
        <div class="header_container">
            <ul class="w-full">
                <li><a class="underline_effect">
                        <RouterLink :to="'/shows/' + new Date().toLocaleDateString('en-CA')">РАСПИСАНИЕ</RouterLink>
                    </a></li>
                <li><a class="underline_effect">
                        <RouterLink to="/films">ФИЛЬМЫ</RouterLink>
                    </a></li>

                <li v-if="role >= 100" class="float-right"><a class="underline_effect">
                        <RouterLink to="/login">ВХОД</RouterLink>
                    </a></li>
                <li @click="unAuth" v-else class="float-right"><a class="underline_effect">
                        <RouterLink to="/login">ВЫХОД</RouterLink>
                    </a></li>
                <li v-if="role == 2" class="float-right"><a class="underline_effect">
                        <RouterLink to="/admin">АДМИН ПАНЕЛЬ</RouterLink>
                    </a></li>
                <li v-if="role <= 1" class="float-right"><a class="underline_effect">
                        <RouterLink to="/report">ОТЧЕТЫ</RouterLink>
                    </a></li>

            </ul>
        </div>
    </header>
</template>

<script setup>
import getRole from '@/role';
import { ref } from 'vue'
const model = defineModel()
let role = ref()
function unAuth() {
    localStorage.setItem("ROLE", 100)
}
setInterval(
    () => { role.value = getRole(); console.log(getRole()) },
    101
);
</script>

<style scoped>
header {
    width: auto;
    height: 100px;
    background-color: rgb(255, 255, 255);
    vertical-align: middle;
    display: flex;
    align-items: center;
    justify-content: center;
}

.header_container {
    width: 1200px;
    height: 100px;

    vertical-align: middle;
    display: flex;
    align-items: center;
}

.logo {
    height: 70px;
    display: inline-block;
    margin-right: 20px;
}

ul {
    display: inline;
}

li {
    display: inline;
    color: rgb(0, 0, 0);
    margin-right: 20px;
}

.underline_effect {
    color: black;
    /* Цвет обычной ссылки */
    position: relative;
    cursor: pointer;
    text-decoration: none;
    /* Убираем подчеркивание */
}

.underline_effect:after {
    content: "";
    display: block;
    position: absolute;
    right: 0;
    bottom: -3px;
    width: 0;
    height: 2px;
    /* Высота линии */
    background-color: rgb(12, 0, 0);
    /* Цвет подчеркивания при исчезании линии*/
    transition: width 0.2s;
    /* Время эффекта */
}

.underline_effect:hover:after {
    content: "";
    width: 100%;
    display: block;
    position: absolute;
    left: 0;
    bottom: -3px;
    height: 2px;
    /* Высота линии */
    background-color: rgb(0, 0, 0);
    /* Цвет подчеркивания при появлении линии*/
    transition: width 0.5s;
    /* Время эффекта */
}

.underline_effect:focus {
    animation: pulse 0.2s;
}

@keyframes pulse {
    from {
        color: black;
    }

    to {
        color: black;
    }
}



.h_schedule {
    color: black;
}
</style>