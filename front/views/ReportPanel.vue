<template>
    <div class="panel">
        <RouterLink to="/report/film">
            <ButtonCustom class="buttonA" text="Отчет о прибыли фильмов за промежуток времени" />
        </RouterLink>
        <FilmSepLine class="mb-5" />
        <RouterLink to="/report/show">
            <ButtonCustom class="buttonA" text="Отчет о прибыли показов с выбором фильма и промежутка времени" />
        </RouterLink>
        <FilmSepLine class="mb-5" />
        <RouterLink to="/report/capacity">
            <ButtonCustom class="buttonA" text="Отчет о загруженности залов за промежуток времени"> </ButtonCustom>
        </RouterLink>
    </div>
</template>

<script setup>
import ButtonCustom from '@/components/ButtonCustom.vue'
import FilmSepLine from '@/components/FilmSepLine.vue';
</script>

<style scoped>
.panel {
    width: 1200px;
    height: auto;
    display: inline;
    padding-top: 25px;
}

.buttonA {
    margin-right: 20px;
    margin-bottom: 20px;
}
</style>