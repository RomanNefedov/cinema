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
                                <v-row cols="12" md="4" sm="6">
                                    <v-text-field v-model="modelArray[1]" label="Номер зала"></v-text-field>
                                </v-row>
                                <v-row cols="12" md="4" sm="6">
                                    <v-select v-model="modelArray[2]" item-value="id" label="Фильм" item-title="name"
                                        :items="allFilms"></v-select>
                                </v-row>
                                <v-row cols="12" md="4" sm="6">
                                    <v-text-field v-model="modelArray[3]" label="Базовая цена"></v-text-field>
                                </v-row>
                                <v-row cols="12" md="4" sm="6">
                                    <v-text-field v-model="modelArray[4]" label="Длительность"></v-text-field>
                                </v-row>
                                <v-row cols="12" md="4" sm="6">
                                    <div class="mr-10">Дата </div>
                                    <input class="bg-black" type="datetime-local" v-model="modelArray[5]" name="Дата"
                                        label="Дата" min="2026-01-01 00:00" max="2028-01-01 00:00" />
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
        <template v-slot:item.filmId="{ item }">
            <div>{{allFilms.find((elem) => elem.id == item.filmId).name}}</div>
        </template>
        <template v-slot:no-data>
            <v-btn color="primary" @click="initialize">
                Reset
            </v-btn>
        </template>
    </v-data-table>
</template>

<script setup>
import { ref, toRaw } from 'vue'
import { useRoute } from 'vue-router';
import axios from 'axios';
import serverUrl from '@/config';
import router from '@/router/router';
let route = useRoute()
let loaded = ref(false)
let dialog = ref(false)
let editedIndex = ref()
let dialogDelete = ref(false)
let modelArray = ref([])
let time = ref()
let allFilms = ref()
let editedItem = ref({
    name: '',
    calories: 0,
    fat: 0,
    carbs: 0,
    protein: 0,
})
let defaultItem = ref({
    name: '',
    calories: 0,
    fat: 0,
    carbs: 0,
    protein: 0,
})

function mapAndClearModelArray() {
    mapModelArray()
    for (let i = 0; i < modelArray.value.length; i++) {
        modelArray.value[i] = ''
    }
}

function mapModelArray() {
    let keys = Object.keys(defaultItem.value)
    console.log(keys)
    for (let i = 0; i < keys.length; i++) {
        editedItem.value[keys[i]] = modelArray.value[i]
    }
}

function mapFromItemToModelArray() {
    let keys = Object.keys(defaultItem.value)
    console.log(keys)
    for (let i = 0; i < keys.length; i++) {
        modelArray.value[i] = editedItem.value[keys[i]]
    }
}

function editItem(item) {

    editedIndex.value = items.value.indexOf(item)
    editedItem.value = Object.assign({}, item)
    dialog.value = true
    mapFromItemToModelArray()
}

function deleteItem(item) {
    editedIndex.value = items.value.indexOf(item)
    editedItem.value = Object.assign({}, item)
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
    deleteRequest(editedItem)
    closeDelete()
}

function createRequest(obj) {
    obj.value.show_datetime = obj.value.show_datetime.replace("T", " ")
    console.log(toRaw(obj.value))
    axios({
        method: 'post',
        url: serverUrl() + "/" + "shows" + "/create",
        headers: {
            "Content-Type": "application/json",
        },
        data: toRaw(obj.value),
    })
        .then(function (response) {
            //console.log(response.data);
            getData()
        })
        .catch(function (error) {
            console.log(error);
        });
}

function updateRequest(obj) {
    obj.value.show_datetime = obj.value.show_datetime.replace("T", " ")
    console.log(toRaw(obj.value))
    axios({
        method: 'post',
        url: serverUrl() + "/" + "shows" + "/update",
        headers: {
            "Content-Type": "application/json",
        },
        data: toRaw(obj.value),
    })
        .then(function (response) {
            //console.log(response.data);
            getData()
        })
        .catch(function (error) {
            console.log(error);
        });
}

function deleteRequest(obj) {
    obj.value.show_datetime = obj.value.show_datetime.replace("T", " ")
    console.log(toRaw(obj.value))
    axios({
        method: 'post',
        url: serverUrl() + "/" + "shows" + "/delete",
        headers: {
            "Content-Type": "application/json",
        },
        data: toRaw(obj.value),
    })
        .then(function (response) {
            //console.log(response.data);
            getData()
        })
        .catch(function (error) {
            console.log(error);
        });
}

function save() {

    mapModelArray()
    if (editedIndex.value > -1) {
        updateRequest(editedItem);
    } else {
        createRequest(editedItem);
    }
    close()
}

function getFilms() {
    axios({
        method: 'get',
        url: serverUrl() + "/films",
        headers: {
            "Content-Type": "application/json",
        }
    })
        .then(function (response) {
            console.log(response.data);
            allFilms.value = response.data;
            initAfterGet()
        })
        .catch(function (error) {
            console.log(error);
        });
}

function initAfterGet() {

    defaultItem.value = items.value[0]
    loaded.value = true;
}

let headers = ref([
    { title: 'Номер показа', key: 'showId' },
    { title: 'Номер зала', key: 'hallNumber' },
    { title: 'Фильм', key: 'filmId' },
    { title: 'Стоимость', key: 'showBasePrice' },
    { title: 'Продолжительность', key: 'showDuration' },
    { title: 'Дата и время', key: 'show_datetime' },
    { title: 'Действия', key: 'actions', sortable: false },
])

function getData() {
    axios({
        method: 'get',
        url: serverUrl() + "/" + "shows",
        headers: {
            "Content-Type": "application/json",
        }
    })
        .then(function (response) {
            console.log(response.data);
            getFilms()
            items.value = response.data;

        })
        .catch(function (error) {
            console.log(error);
        });
}
getData()
let items = ref([])
</script>

<style scoped></style>