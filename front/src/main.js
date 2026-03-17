import './assets/main.css';

// Vuetify
import 'vuetify/styles'
import {createVuetify} from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
import '@mdi/font/css/materialdesignicons.css'


// HTML to pdf



import { createApp } from 'vue';
import router from './router/router.js';
import App from './App.vue';
import './config.js';

const vuetify = createVuetify({
    theme:{
        defaultTheme: 'dark'
    },
    components,
    directives,
})

const app = createApp(App).use(router).use(vuetify,{iconfont:'mdi'}).mount('#app');
