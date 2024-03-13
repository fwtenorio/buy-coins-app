<template>
  <div class="container">
    <button v-on:click="showModal = !showModal" class="btn btn-primary mr-1 float-right"><b>Nova Transação</b></button>
    <div v-bind:class="modalClass" class="modal-container">
      <div class="user-modal">
        <h3 class="text-primary">COMPRAR MOEDA</h3>
        <br>
        <form @submit.prevent="sendBuy">
          <div class="form-group">
            <label for="quantity">Quantidade que deseja comprar (mínino: 50,00)</label>
            <input required v-model="inputAmount" @click="handleClickAmount" type="text" id="amount" class="form-control" placeholder="R$ 0,00"/>
          </div>
          <div class="form-group">
            <label for="name">Selecione a moeda de compra</label>
            <select v-model="selectedCoin" @change="fetchCoinData" :disabled="inputAmount < 50">
              <option value="" disabled selected>Selecione uma moeda</option>
              <option v-for="coin in coins" :key="coin.name" :value="coin.code">{{ coin.name }}</option>
            </select>
          </div>
          <div class="form-group" v-if="showTotalToPay">
            <label for="totalToPay">Valor total a pagar (incluindo taxa de serviço)</label>
            <input type="text" v-model="totalToPay" class="form-control" disabled>
          </div>

          <div class="form-group" v-if="showTotalToBuy">
            <label for="totalToPay">Você estará comprando:</label>
            <input type="text" v-model="totalToBuy" class="form-control" disabled>
          </div>
          <br><br>
          <div>
            <button v-on:click.prevent="showModal = !showModal" class="btn btn-secondary mr-1 mb-2">CANCELAR</button>
            <button :disabled="(inputAmount != '' && parseFloat(inputAmount) < 50) || !btnBuyActive" class="btn btn-primary mr-1 mb-2"><b>{{ btnBuyLabel }}</b></button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'UserRegisterForm',
    data() {
      return {
        users: [],
        coins: [],
        selectedCoin: '',
        inputAmount: '',
        totalToPay: '',
        totalToBuy: '',
        showModal: false,
        showTotalToPay: false,
        showTotalToBuy: false,
        btnBuyActive: false,
        btnBuyLabel: 'COMPRAR!',
        token: sessionStorage.getItem('token')
      };
    },
    mounted() {
      this.fetchListCoin();
    },
    methods: {
      handleClickAmount() {
        this.isLoading = true;
        this.selectedCoin = '';
        this.btnBuyActive = false;
        this.totalToPay = '';
        this.totalToBuy = '';
      },
      // Requisição POST para criar um novo usuário
      async fetchListCoin() {
        try {
          const response = await fetch('http://localhost:8000/api/coins', {
            method: 'GET',
            headers: {
              'Authorization': this.token
            }
          });
          if (response.ok) {
            const data = await response.json();
            this.coins = data.data;
          } else {
            console.error('Erro na requisição:', response.status);
          }
        } catch (error) {
          console.error('Erro:', error.message);
        }
      },
      async fetchCoinData() {
        try {
          if (this.inputAmount !== '') {
            this.btnBuyLabel = 'CARREGANDO...';
            const response = await fetch('http://localhost:8000/api/coins/price-rate', {
              method: 'POST',
              headers: {
                'Content-type': 'application/json',
                'Authorization': this.token
              },
              body: JSON.stringify({
                amount: this.inputAmount,
                coin: this.selectedCoin
              })
            });
            if (response.ok) {
              const data = await response.json();
              this.showTotalToPay = true;
              this.showTotalToBuy = true;
              this.totalToPay = `BRL ${data.data.totalPayWithRate}`;
              this.totalToBuy = `${data.data.shortName} ${data.data.totalBuy}`;
              this.btnBuyLabel = 'COMPRAR!';
              this.btnBuyActive = true;
            } else {
              this.totalToPay = '';
              this.totalToBuy = '';
              this.btnBuyActive = false;
            }
          }
        } catch (error) {
          console.error('Erro:', error.message);
        }
      },
      async sendBuy() {
        try {
          this.btnBuyLabel = 'AGUARDE...';
          this.btnBuyActive = false;
          const response = await fetch('http://localhost:8000/api/transactions', {
            method: 'POST',
            headers: {
              'Content-type': 'application/json',
              'Authorization': this.token
            },
            body: JSON.stringify({
              amount: this.inputAmount,
              coin: this.selectedCoin
            })
          });
          if (response.ok) {
            window.location.reload();
          } else {
            console.error('Erro na requisição:', response.status);
          }
        } catch (error) {
          console.error('Erro:', error.message);
        }
      }
    },
    computed: {
      modalClass() {
        return this.showModal ? 'show' : '';
      }
    }
  };
</script>

<style>
  .modal-container {
    position: fixed;
    background-color: rgba(0, 0, 0, 0.3);
    top: 0;
    left: 0;
    height: 100vh;
    width: 100vw;
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    pointer-events: none;
    transition: opacity 0.3s ease-in-out;
  }

  .modal-container.show {
    opacity: 1;
    pointer-events: auto;
  }

  .user-modal {
    color: #535353;
    background-color: #fff;
    background-image: url("../assets/background.jpg");
    width: 450px;
    padding: 40px 50px;
    max-width: 100%;
    border-radius: 10px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
  }

  .user-modal h1 {
    margin: 0;
  }

  .user-modal p {
    opacity: 0.9;
  }
</style>
