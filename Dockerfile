# Use a imagem oficial do Node.js
FROM node:18-alpine

# Defina o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copie os arquivos do projeto para o contêiner
COPY . .

# Instale as dependências do projeto
RUN npm install

# Construa o projeto Vue.js
RUN npm run build

# Exponha a porta 8080 para acesso externo
EXPOSE 8080

# Execute o servidor de produção do Vue.js ao iniciar o contêiner
CMD ["npm", "run", "serve"]
