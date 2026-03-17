<template>
    <div class="panel">
        <div v-if="filmLoaded" class="flex mb-16">
            <div class="circular--portrait mr-10">
                <img :src="serverUrl() + '/films/image?path=' + film.imagePath" alt="">
            </div>
            <div class="inline-block w-auto">
                <div class="text-black text-3xl font-bold mt-5 mb-5">{{ film.name }}</div>
                <div class="flex">
                    <div class="info text-black text-xl flex">{{ show.date }}</div>
                    <div class="info text-black text-xl flex">{{ show.hallNumber + ' зал' }}</div>
                    <div class=" text-black text-xl flex">{{ show.hallType }}</div>
                </div>
            </div>
        </div>

        <div v-if="seatsLoaded && ticketsLoaded">
            <svg class="mb-10" width="1240" height="88" viewBox="0 0 1028 88" fill="none"
                xmlns="http://www.w3.org/2000/svg">
                <path d="M2 88V35C2 35 195 2 514 2C833 2 1026 35 1026 35V88H2Z" fill="url(#paint0_linear)"></path>
                <path d="M2 35C2 35 193 2.5 514 2.5C835 2.5 1026 35 1026 35" stroke="#BD257F" stroke-width="4"
                    stroke-linecap="round"></path>
                <defs>
                    <linearGradient id="paint0_linear" x1="514" y1="2" x2="514" y2="69.5"
                        gradientUnits="userSpaceOnUse">
                        <stop stop-color="#BD257F"></stop>
                        <stop offset=".01" stop-color="#BD257F" stop-opacity=".5"></stop>
                        <stop offset="1" stop-color="#2A2A2A" stop-opacity="0"></stop>
                    </linearGradient>
                </defs>
            </svg>
            <div class="grid m-auto mb-20">
                <div v-for="(row, rowIndex) in rows" class="m-auto">
                    <div class="inline-block w-10 h-10 text-3xl text-black mr-20">{{ rowIndex + 1 }}</div>
                    <Seat @clicked="onSeatClicked" v-for="(seat, seatIndex) in numbers" class="inline"
                        :number="seatIndex + 1" :row="rowIndex + 1"
                        :seat="seatsList.find((element) => element.seatNumber == seatIndex + 1 && element.rowNumber == rowIndex + 1)" />
                    <div class="inline-block w-10 h-10 text-3xl text-black ml-20">{{ rowIndex + 1 }}</div>
                </div>
            </div>
        </div>
        <div v-if="pickedSeatList.length != 0" class="w-full h-auto bg-white p-5 mb-20">
            <div class="text-black font-bold text-3xl mb-5">Ваши места</div>
            <div v-for="seat in pickedSeatList">
                <div class="text-black font-bold text-3xl mb-5 inline-block"> {{ seat.rowNumber + ' ряд, ' +
                    seat.seatNumber + ' место' }}</div>
                <div class="text-black font-bold text-3xl mb-5 inline-block float-end">{{ 'Стоимость: ' +
                    Math.round(show.basePrice * seat.coefficient) + ' Р' }}</div>
            </div>
            <ButtonCustom @click="buyTickets" :text="'Купить билеты за ' + getSumTicketPrice() + ' Р'"></ButtonCustom>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue'
import axios from 'axios';
import serverUrl from '@/config';
import router from '@/router/router';
import Seat from '@/components/Seat.vue';
import getRole from '@/role';
import ButtonCustom from '@/components/ButtonCustom.vue';

let show = ref()
let film = ref()
let filmLoaded = ref(false)
let ticketsLoaded = ref(false)
let seatsLoaded = ref(false)
let pickedSeatList = ref([])
let seatsList = ref([])
let seatsListFor = ref([])
let sumTicketPrice = ref()
let role = ref()
setInterval(
    () => { role.value = getRole() },
    100
);
let rows = ref('')
let numbers = ref('')

function getSumTicketPrice() {
    let sum = 0
    pickedSeatList.value.forEach((obj) => sum += show.value.basePrice * obj.coefficient)
    sum = Math.round(sum)
    return sum
}

function buyTickets() {
    if (role.value != 3)
        return
    for (let i = 0; i < pickedSeatList.value.length; i++) {
        axios({
            method: 'post',
            url: serverUrl() + '/tickets/add?' + 'seatId=' + pickedSeatList.value[i].id + '&' + 'showId=' + + show.value.id,
            headers: {
                "Content-Type": "application/json",
            }
        })
            .then(function (response) {
                console.log(response.data)
                getTickets(show.value.id)
            })
            .catch(function (error) {
                console.log(error);
            });
    }
    pickedSeatList.value = []
}

function getTickets(showId) {
    axios({
        method: 'get',
        url: serverUrl() + '/tickets/' + showId,
        headers: {
            "Content-Type": "application/json",
        }
    })
        .then(function (response) {
            for (let i = 0; i < seatsList.value.length; i++) {
                if (response.data.find((element) => element.seatId == seatsList.value[i].id)) {
                    seatsList.value[i].sold = true;
                }
                else {
                    seatsList.value[i].sold = false;
                }
            }
            ticketsLoaded.value = true;
        })
        .catch(function (error) {
            console.log(error);
        });
}

function getMaxRow(list) {
    return Math.max.apply(Math, list.map(function (list) { return list.rowNumber; }))
}

function getMaxSeatNumber(list) {
    return Math.max.apply(Math, list.map(function (list) { return list.seatNumber; }))
}

function onSeatClicked(seat) {
    if (pickedSeatList.value.find((obj) => obj.id == seat.id) != undefined) {
        pickedSeatList.value = pickedSeatList.value.filter((pickedSeat) => pickedSeat.id !== seat.id)
        return
    }
    pickedSeatList.value.push(seat)
}

function getSeats(hallNumber, showId) {
    axios({
        method: 'get',
        url: serverUrl() + '/seats/' + hallNumber,
        headers: {
            "Content-Type": "application/json",
        }
    })
        .then(function (response) {
            seatsList.value = response.data;
            getTickets(showId)
            rows.value = getMaxRow(seatsList.value)
            numbers.value = getMaxSeatNumber(seatsList.value)
            seatsLoaded.value = true;
        })
        .catch(function (error) {
            console.log(error);
        });
}

function getShow() {
    axios({
        method: 'get',
        url: serverUrl() + '/shows/id/' + router.currentRoute.value.params.id,
        headers: {
            "Content-Type": "application/json",
        }
    })
        .then(function (response) {
            show.value = response.data;
            getFilm(show.value.filmId)
            getSeats(show.value.hallNumber, show.value.id)

        })
        .catch(function (error) {
            console.log(error);
        });
}

function getFilm(filmId) {
    axios({
        method: 'get',
        url: serverUrl() + '/films/' + filmId,
        headers: {
            "Content-Type": "application/json",
        }
    })
        .then(function (response) {
            film.value = response.data;
            filmLoaded.value = true;
        })
        .catch(function (error) {
            console.log(error);
        });

}

getShow()

</script>

<style scoped>
.info::after {
    width: 2px;
    height: 26px;
    background-color: black;
    content: '';
    margin-left: 25px;
    margin-right: 25px;
}

.circular--portrait {
    position: relative;
    width: 200px;
    height: 200px;
    overflow: hidden;
    border-radius: 50%;
}

.circular--portrait img {
    width: 100%;
    height: auto;
}

.panel {
    width: 1200px;
    height: auto;
    display: inline;
    padding-top: 25px;
}
</style>