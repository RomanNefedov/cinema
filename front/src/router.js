import { createMemoryHistory, createRouter,createWebHistory } from 'vue-router';

import ShowList from '@/views/ShowList.vue';
import FilmList from '@/views/FilmList.vue';
import AdminPanel from '@/views/AdminPanel.vue';
import Login from '@/views/Login.vue';
import ReportPanel from '@/views/ReportPanel.vue';
import FilmReport from '@/views/reports/FilmReport.vue';
import ShowReport from '@/views/reports/ShowReport.vue';
import HallCapacityReport from '@/views/reports/HallCapacityReport.vue';
import Film from '@/views/Film.vue';
import Order from '@/views/Order.vue';
import AdminView from '@/views/AdminView.vue'
import AdminShowView from '@/views/AdminShowView.vue'
import AdminFilmView from '@/views/AdminFilmView.vue'
const routes = [
    { path: '/shows/:date', component: ShowList },
    { path: '/', component: FilmList },
    { path: '/films', component: FilmList },
    { path: '/films/:id', component: Film },
    { path: '/admin', component: AdminPanel },
    { path: '/admin/:name',component: AdminView},
    { path: '/admin/films',component: AdminFilmView},
    { path: '/admin/shows',component: AdminShowView},
    { path: '/login', component: Login },
    { path: '/report', component: ReportPanel },
    { path: '/orders/:id', component: Order},
    { path: '/report/film', component: FilmReport },
    { path: '/report/show', component: ShowReport },
    { path: '/report/capacity', component: HallCapacityReport },
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;
