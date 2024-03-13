<template>
  <div class="container">
    <h3 class="mt-2 mb-3 float-left text-primary">Transações</h3>
    <table class="table table-striped">
      <thead>
        <tr>
          <th scope="col">#</th>
          <th scope="col">MOEDA</th>
          <th scope="col">VALOR DE COMPRA</th>
          <th scope="col">TAXA</th>
          <th scope="col">VALOR TOTAL PAGO</th>
          <th scope="col">DATA/HORA</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(transaction, index) in transactions" :key="transaction.name" class="m-5">
          <th scope="row">{{ index + 1 }}</th>
          <td>{{ transaction.coinName }}</td>
          <td>{{ transaction.coinName }} {{ transaction.amount }}</td>
          <td>R$ {{ transaction.rateBrl }}</td>
          <td>R$ {{ transaction.totalPaidBrl }}</td>
          <td>{{ transaction.createAt }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: 'TransactionsTable',
  data() {
    return {
      transactions: [],
      token: sessionStorage.getItem('token')
    }
  },
  mounted() {
    this.fetchTransactions();
  },
  methods: {
    // Requisição POST para criar um novo usuário
    async fetchTransactions() {
      try {
        const response = await fetch('http://localhost:8000/api/transactions', {
          method: 'GET',
          headers: {
            'Authorization': this.token
          }
        });
        if (response.ok) {
          const data = await response.json();
          this.transactions = data.data;
        } else {
          console.error('Erro na requisição:', response.status);
        }
      } catch (error) {
        console.error('Erro:', error.message);
      }
    }
  },
  computed: {
  }
}
</script>

<style scoped>
th {
  padding-left: 1.2rem;
}

body {
  margin: 0; /* Remove margens padrão do corpo */
  padding: 0; /* Remove preenchimento padrão do corpo */
  background-image: url("../assets/background.jpg") !important;
  background-size: cover; /* Ajusta o tamanho da imagem para cobrir todo o container */
  background-position: center; /* Centraliza a imagem no container */
}
</style>
