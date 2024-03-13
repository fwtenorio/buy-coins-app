<template>
  <div class="login-container">
    <div class="login-form">
      <p style="font-size:20px !important"><b>COMPRA DE MOEDAS</b></p>
      <br>
      <form @submit.prevent="loginOrCreateUser">
        <div class="form-group">
          <label for="email"><b>Email:</b></label>
          <input type="email" id="email" v-model="email" name="email" required @click="hideError">
        </div>
        <div class="form-group">
          <label for="password"><b>Password:</b></label>
          <input type="password" id="password" v-model="password" minlength="5" required @click="hideError">
        </div>
        <div class="error-alert" v-if="showMessageLabel">
          <p style="font-size:12px !important"><b>{{ messageLabel }}</b></p>
        </div>
        <div class="create-account-link" v-if="showSignUp">
          <p style="font-size: 14px;padding-top: 3px;">Ainda não tem uma conta? <a href="#" @click="signUp"><b>Criar conta</b></a></p>
        </div>
        <div v-else>
          <p style="font-size: 14px;padding-top: 3px;">Já tem sua conta? <a href="#" @click="signIn"><b>Logar</b></a></p>
        </div>
        <br>
        <button type="submit" :disabled="isDisabled" :class="{ 'inactive-button': isDisabled }"><b>{{ buttonLabel }}</b></button>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      email: '',
      password: '',
      showMessageLabel: false,
      showSignUp: true,
      buttonLabel: 'Login',
      messageLabel: '',
      isLogin: true,
      isDisabled: false
    };
  },
  methods: {
    hideError: function() {
      this.showMessageLabel = false; 
    },
    signUp() {
      this.buttonLabel = 'Registrar';
      this.showSignUp = false;
      this.isLogin = false;
    },
    signIn() {
      this.buttonLabel = 'Logar';
      this.showSignUp = true;
      this.isLogin = true;
    },
    async loginOrCreateUser() {
      try {
        this.isDisabled = true;
        let url = '';
        if (this.isLogin) {
          url = 'sign-in'
        } else {
          url = 'sign-up'
        }
        const response = await fetch(`https://bitsharktoken.com/backend/public/api/${url}`, {
          method: 'POST',
          headers: {
            'Content-type': 'application/json'
          },
          body: JSON.stringify({
            email: this.email,
            password: this.password
          })
        });
        const data = await response.json();
        if (response.ok) {
          if (this.isLogin) {
            sessionStorage.setItem('token', data.data);
            window.location.reload();
          } else {
            this.signIn()
            this.showMessageLabel = true;
            this.messageLabel = 'Cadastro realizado com sucesso!';
          }
        } else {
          this.showMessageLabel = true;
          this.messageLabel = data.message;
        }
        this.isDisabled = false;
      } catch (error) {
        console.error(error);
      }
    }
  }
};
</script>

<style>
  body {
    margin: 0;
    padding: 0;
    background-color: rgba(255, 255, 255, 0.5);
    background-image: url("../assets/bg_app.jpg");
    background-size: cover;
    background-position: center;
  }
  .login-form {
    background-color: #fff;
  }
  .login-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 80vh;
  }
  .error-alert {
    background-color: #f8d7da;
    color: #721c24;
    padding: 10px;
    border: 1px solid #f5c6cb;
    border-radius: 5px;
    text-align: center;
  }
  .error-alert p {
    font-size: 14px;
    margin: 0;
  }
  .login-form {
    width: 300px;
    padding: 20px;
    border: 1px solid #ccc;
    border-radius: 5px;
  }
  .login-form p {
    font-size: 21px;
    margin: 0;
    text-align: center;
  }
  .form-group {
    margin-bottom: 15px;
  }
  label {
    display: block;
    margin-bottom: 5px;
  }
  input[type="email"],
  input[type="password"] {
    width: 100%;
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 3px;
  }
  button {
    width: 100%;
    padding: 10px;
    background-color: #007bff;
    color: #fff;
    border: none;
    border-radius: 3px;
    cursor: pointer;
  }
  button:hover {
    background-color: #0056b3;
  }
  .inactive-button {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>
