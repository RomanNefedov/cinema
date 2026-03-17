<template>
    <v-data-table v-if="loaded" items-per-page="1000" :headers="headers" :items="items">
        <template v-slot:top>
            <v-toolbar flat>
                <v-toolbar-title>Таблица</v-toolbar-title>
                <v-divider class="mx-4" inset vertical></v-divider>
                <v-spacer></v-spacer>
                <v-dialog v-model="dialog" max-width="500px">
                    <template v-slot:activator="{ props }">
                        <v-btn @click="mapAndClearModelArray" class="mb-2" color="primary" dark v-bind="props">
                            Добавить
                        </v-btn>
                    </template>
                    <v-card>
                        <v-card-title>
                            <span class="text-h5">Добавить новую запись</span>
                        </v-card-title>

                        <v-card-text>
                            <v-container>
                                <v-row>
                                    <v-text-field v-model="editedItem.name" label="Название"></v-text-field>
                                </v-row>
                                <v-row>
                                    <v-text-field @keypress="numFilter(event)" type="number" v-model="editedItem.ageRating" label="Возрастной рейтинг"></v-text-field>
                                </v-row>
                                <v-row>
                                    <v-date-input  v-model="editedItem.worldPremiereDate"
                                        label="Мировая премьера"></v-date-input>
                                </v-row>
                                <v-row>
                                    <v-select multiple v-model="editedItem.genres" item-title="genreName" item-value="genreName" :items="allGenres" label="Жанры"></v-select>
                                </v-row>
                                <v-row>
                                    <v-select multiple v-model="editedItem.countries" item-title="countryName" item-value="countryName" :items="allCountries" label="Страны"></v-select>
                                </v-row>

                                <v-row>
                                    <v-text-field @keypress="numFilter(event)" type="number" v-model="editedItem.duration"
                                        label="Длительность"></v-text-field>
                                </v-row>
                                <v-row>
                                    <v-text-field v-model="editedItem.description" label="Описание"></v-text-field>
                                </v-row>
                                <v-row>
                                    <v-select multiple v-model="editedItem.actors" item-value="id" item-title="nameAndSurname"  :items="allActors" label="Актеры"></v-select>
                                </v-row>
                                <v-row>
                                    <v-select multiple v-model="editedItem.directors" item-value="id" item-title="nameAndSurname"  :items="allDirectors" label="Режиссеры"></v-select>
                                </v-row>
                                <v-row>
                                    <v-file-input accept="image/*" v-model="editedItem.imagePath" label="Картинка"></v-file-input>
                                </v-row>
                            </v-container>
                        </v-card-text>

                        <v-card-actions>
                            <v-spacer></v-spacer>
                            <v-btn color="blue-darken-1" variant="text" @click="close">
                                Отмена
                            </v-btn>
                            <v-btn color="blue-darken-1" variant="text" @click="save">
                                Сохранить/Добавить
                            </v-btn>
                        </v-card-actions>
                    </v-card>
                </v-dialog>
                <v-dialog v-model="dialogDelete" max-width="500px">
                    <v-card>
                        <v-card-title class="text-h5">Вы уверены, что хотите удалить?</v-card-title>
                        <v-card-actions>
                            <v-spacer></v-spacer>
                            <v-btn color="blue-darken-1" variant="text" @click="closeDelete">Отмена</v-btn>
                            <v-btn color="blue-darken-1" variant="text" @click="deleteItemConfirm">Подтвердить</v-btn>
                            <v-spacer></v-spacer>
                        </v-card-actions>
                    </v-card>
                </v-dialog>
            </v-toolbar>
        </template>
        <template v-slot:item.actions="{ item }">
            <v-icon class="me-2" size="small" @click="editItem(item)">
                mdi-pencil
            </v-icon>
            <v-icon size="small" @click="deleteItem(item)">
                mdi-delete
            </v-icon>
        </template>
        
        <template v-slot:item.actors="{ item }">
            <span>{{ item.actors.map((item)=>item.nameAndSurname).join(", ") }}</span>
        </template>
        <template v-slot:item.directors="{ item }">
            <span>{{ item.directors.map((item)=>item.nameAndSurname).join(", ") }}</span>
        </template>
        <template v-slot:item.genres="{ item }">
            <span>{{ item.genres.join(", ") }}</span>
        </template>
        <template v-slot:item.countries="{ item }">
            <span>{{ item.countries.join(", ") }}</span>
        </template>
        <template v-slot:item.worldPremiereDate="{ item }">
            <span>{{ item.worldPremiereDate.toLocaleDateString("ru") }}</span>
        </template>
        
        <template v-slot:item.imagePath="{ item }">
            <img :src="serverUrl() + '/films/image?path=' + item.imagePath" width="100px" alt="">
        </template>
        
        <template v-slot:no-data>
            <v-btn color="primary" @click="initialize">
                Reset
            </v-btn>
        </template>
    </v-data-table>
</template>

<script setup>
import { ref,toRaw } from 'vue'
import { useRoute } from 'vue-router';
import axios from 'axios';
import serverUrl from '@/config';
import { VDateInput } from 'vuetify/labs/VDateInput'
import { reactive } from 'vue';
import { VToolbarItems } from 'vuetify/lib/components/index.mjs';

let route = useRoute()
let loaded = ref(false)
let dialog = ref(false)
let editedIndex = ref()
let dialogDelete = ref(false)
let modelArray = ref([])
let items = ref([])
getData()

let allGenres = ref([])
let allActors = ref([])
let allDirectors = ref([])
let allCountries = ref([])
let editedItem = ref({
    id: 0,
    name: [],
    genres: [],
    worldPremiereDate: new Date(),
    duration: 0,
    description: '',
    ageRating: 0,
    actors: [],
    countries:[],
    directors: [],
    imagePath: "",
})
let defaultItem = ref({
    id : 0,
    name: '',
    genres: [],
    worldPremiereDate: new Date(),
    duration: 0,
    description: '',
    ageRating: '',
    actors: [],
    countries: [],
    directors: [],
    imagePath: "",
})



let headers = ref([
    { title: 'Назване', key: 'name' },
    { title: "Мировая премьера", key: "worldPremiereDate" },
    { title: "Жанры", key: "genres" },
    { title: "Страны", key: "countries" },
    { title: "Длительность", key: "duration" },
    { title: "Описание", key: "description" },
    { title: "Возрастной рейтинг", key: "ageRating" },
    { title: "Актёры", key: "actors" },
    { title: "Режиссеры", key: "directors" },
    { title: "Превью", key: "imagePath" },
    { title: 'Действия', key: 'actions', sortable: false },
])

function mapAndClearModelArray() {
    editedIndex.value = -1
    editedItem.value = Object.assign({},defaultItem.value)
}


function editItem(item) {
    editedIndex.value = items.value.indexOf(item)
    editedItem.value = Object.assign({}, item)
    dialog.value = true
}

function deleteItem(item) {
    editedIndex.value = items.value.indexOf(item)
    editedItem.value = Object.assign({}, item)
    console.log(item)

    dialogDelete.value = true
}


function close() {
    dialog.value = false
    editedIndex.value = -1
}

function closeDelete() {
    dialogDelete.value = false
    editedItem.value = Object.assign({}, defaultItem.value)
    editedIndex.value = -1
}

function deleteItemConfirm() {
    deleteFilm(editedItem)
    closeDelete()
}

function saveImage(multiPartImage){
    let formData = new FormData()
    formData.append("image",multiPartImage)
    axios({
        method: 'post',
        url: serverUrl() + "/films/image/new",
        headers: {
            "Content-Type":'multipart/form-data',
        },
        data: formData,
    })
    .then(function (response) {
        console.log(response.data);
    })
    .catch(function (error) {
        console.log(error);
    });
}

function deleteFilm(item){
    axios({
        method: 'post',
        url: serverUrl() + "/films/delete?id="+item.value.id,
        headers: {
            "Content-Type": "application/json",
        },
    })
    .then(function (response) {
        console.log(response.data);
        getData()
    })
    .catch(function (error) {
        console.log(error);
    });
}

function addNewFilm(item){
    const obj = Object.assign({},toRaw(item.value))
    obj.directors = obj.directors.map((items)=>({id : items, nameAndSurname : ""}))
    obj.actors = obj.actors.map((items)=>({id : items, nameAndSurname : ""}))
    saveImage(obj.imagePath)
    obj.imagePath = obj.imagePath.name
    console.log(obj)
    axios({
        method: 'post',
        url: serverUrl() + "/films/new",
        headers: {
            "Content-Type": "application/json",
        },
        data: obj,
    })
    .then(function (response) {
        console.log(response.data);
        getData()
    })
    .catch(function (error) {
        console.log(error);
    });
}

function saveFilm(item){
    const obj = Object.assign({},toRaw(item.value))
    obj.directors = toRaw(obj.directors)
    obj.actors = toRaw(obj.actors)
    obj.directors = obj.directors.map((items)=>({id : items, nameAndSurname : ""}))
    obj.actors = obj.actors.map((items)=>({id : items, nameAndSurname : ""}))
    obj.countries = toRaw(obj.countries)
    obj.genres = toRaw(obj.genres)
    if(typeof obj.imagePath == File){
        saveImage(obj.imagePath)
        obj.imagePath = obj.imagePath.name
    }
   
    // obj.worldPremiereDate = obj.worldPremiereDate
    console.log(obj)
    axios({
        method: 'post',
        url: serverUrl() + "/films/update",
        headers: {
            "Content-Type": "application/json",
        },
        data: obj,
    })
    .then(function (response) {
        console.log(response.data);
        getData()
    })
    .catch(function (error) {
        console.log(error);
    });
}

function save() {
    if (editedIndex.value > -1) {
        saveFilm(editedItem)
    } else {
        console.log(editedItem.value)
        addNewFilm(editedItem)
    }
    
    editedIndex.value = -1
    close()
}

function numFilter (evt) {
      evt = (evt) ? evt : window.event;
      let expect = evt.target.value.toString() + evt.key.toString();
      
      if (!/^[-+]?[0-9]*\.?[0-9]*$/.test(expect)) {
        evt.preventDefault();
      } else {
        return true;
      }
}


function initAfterGet() {
    loaded.value = true
}

function getFilms(){
    axios({
        method: 'get',
        url: serverUrl() + "/films",
        headers: {
            "Content-Type": "application/json",
        }
    })
    .then(function (response) {
        console.log(response.data);
        items.value = response.data.map((item)=>setCorrectDate(item));
    })
    .catch(function (error) {
        console.log(error);
    });
}
function setCorrectDate(item){
    item.worldPremiereDate = new Date(item.worldPremiereDate)
    return item
}
function getGenres(){
    axios({
        method: 'get',
        url: serverUrl() + "/genres",
        headers: {
            "Content-Type": "application/json",
        }
    })
    .then(function (response) {
        console.log(response.data);
        allGenres.value = response.data;
        
    })
    .catch(function (error) {
        console.log(error);
    });
}
function getCountries(){
    axios({
        method: 'get',
        url: serverUrl() + "/countries",
        headers: {
            "Content-Type": "application/json",
        }
    })
    .then(function (response) {
        console.log(response.data);
        allCountries.value = response.data;
        
    })
    .catch(function (error) {
        console.log(error);
    });
}
function getActors(){
    axios({
        method: 'get',
        url: serverUrl() + "/actors",
        headers: {
            "Content-Type": "application/json",
        }
    })
    .then(function (response) {
        console.log(response.data);
        allActors.value = response.data;
        
    })
    .catch(function (error) {
        console.log(error);
    });
}

function getDirectors(){
    axios({
        method: 'get',
        url: serverUrl() + "/directors",
        headers: {
            "Content-Type": "application/json",
        }
    })
    .then(function (response) {
        console.log(response.data);
        allDirectors.value = response.data;
        
    })
    .catch(function (error) {
        console.log(error);
    });
}

function getData() {
    getFilms()
    getActors()
    getDirectors()
    getCountries()
    getGenres()
    initAfterGet()
}


//items.value.push(defaultItem.value)
//items.value.push({})


</script>

<style scoped></style>
