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
                                <v-row  v-for="(key, i) in Object.keys(defaultItem)" cols="12" md="4" sm="6">
                                    <v-text-field v-if="key != 'id' && key != 'showId'" v-model="modelArray[i]" :label="key"></v-text-field>
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
import router from '@/router/router';
import setHeader from '@/setHeaders'
let route = useRoute()
let loaded = ref(false)
let dialog = ref(false)
let editedIndex = ref()
let dialogDelete = ref(false)
let modelArray = ref([])


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

function createRequest(obj){
    console.log(toRaw(obj.value))
    axios({
        method: 'post',
        url: serverUrl() + "/" + route.params.name +"/create",
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

function updateRequest(obj){
    console.log(toRaw(obj.value))
    axios({
        method: 'post',
        url: serverUrl() + "/" + route.params.name +"/update",
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

function deleteRequest(obj){
    console.log(toRaw(obj.value))
    axios({
        method: 'post',
        url: serverUrl() + "/" + route.params.name +"/delete",
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

function initHeaders() {
    let headersStr = Object.keys(defaultItem.value)
    let headersArray = []
    for (let i = 0; i < headersStr.length; i++) {
        if (headersStr[i] != 'id')
            headersArray.push({ title: headersStr[i], key: headersStr[i] })
    }
    headersArray = setHeader(route.params.name)
    console.log(headersArray)
    headersArray.push({ title: 'Действия', key: 'actions', sortable: false })
    console.log("4")
    console.log(headersArray)
    return headersArray
}

function initAfterGet() {

    defaultItem.value = items.value[0]
    loaded.value = true;

    headers.value = initHeaders()
}

let headers = ref()

function getData() {
    axios({
        method: 'get',
        url: serverUrl() + "/" + route.params.name,
        headers: {
            "Content-Type": "application/json",
        }
    })
        .then(function (response) {
            console.log(response.data);
            items.value = response.data;
            initAfterGet()
        })
        .catch(function (error) {
            console.log(error);
        });
}
getData()
let items = ref([])
</script>

<style scoped></style>