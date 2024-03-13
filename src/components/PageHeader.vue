<template>
  <div class="container">
    <header>
      <h1 class="mb-0">COMPRA DE MOEDAS</h1>
    </header>
    <nav class="mt-4 mb-3">
      <a href="#" @click="logout" class="btn btn-outline-primary mr-1">SAIR</a>
    </nav>
  </div>
</template>

<script>
  export default {  
    name: 'PageHeader',
    methods: {
      logout() {
        sessionStorage.removeItem('token');
        window.location.reload();
      }
    }
  }
</script>
<style scoped>
</style>