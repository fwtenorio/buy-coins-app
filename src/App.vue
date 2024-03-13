<template>
  <div id="app" v-if="shouldRenderApp">
    <PageLogin />
  </div>
  <div v-else>
    <PageHeader />
    <PageTransactionsCreate />
    <PageTransactions />
  </div>
</template>

<script>
  import PageHeader from './components/PageHeader.vue';
  import PageTransactions from './components/PageTransactions.vue';
  import PageTransactionsCreate from './components/PageTransactionsCreate.vue';
  import PageLogin from './components/PageLogin.vue';

  export default {
    name: 'App',
    components: {
      PageHeader,
      PageTransactionsCreate,
      PageTransactions,
      PageLogin
    },
    data() {
      return {
        isLoggedUser: false
      };
    },
    computed: {
      shouldRenderApp() {
        return !sessionStorage.getItem('token');
      }
    },
    mounted() {
      const hasToken = sessionStorage.getItem('token');
      if (hasToken) {
        this.isLoggedUser = true;
      }
    },
    methods: {
    }
  }
</script>

<style>
  #app {
    margin-top: 40px;
  }
</style>
