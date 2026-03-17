<template>
    <div class="block">
        <p class="m-10 text-black text-center">Вход</p>
        <InputCustom type="text" v-model="loginV" defaultText="Логин" class="mb-10" />
        <InputCustom type="password" v-model="passwordV" defaultText="Пароль" class="mb-10" />
        <ButtonCustom @click="auth" class="w-32 block ml-auto mr-auto" text="Войти" />
        <div v-if="error" class="text-red ml-5">Неверный логин или пароль</div>
    </div>
</template>

<script setup>
import InputCustom from '@/components/InputCustom.vue';
import ButtonCustom from '@/components/ButtonCustom.vue';
import { ref, toRaw } from 'vue'
import { useRouter } from 'vue-router';
import serverUrl from '@/config';
import axios from 'axios';
let router = useRouter()
let loginV = ref('')
let passwordV = ref('')
let error = ref(false)

function clearError() {
    error.value = false
}

function auth() {
    console.log(loginV)
    console.log(passwordV)
    axios({
        method: 'post',
        url: serverUrl() + '/accounts/auth',
        headers: {
            "Content-Type": "application/json",
        },
        data: { login: loginV.value, password: passwordV.value },
    })
        .then(function (response) {
            console.log(response.data);
            if (response.data != '') {
                localStorage.setItem("ROLE", response.data.role);
                router.push("/films")
            }
            else {
                error.value = true
                alert("Неверный логин или пароль")
                setTimeout(clearError, 2000);
            }
        })
        .catch(function (error) {
            console.log(error);
        });
}
</script>

<style scoped></style>