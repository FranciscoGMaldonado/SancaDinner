# Sanca-Dinner

Projeto desenvolvido para a disciplina de Tópicos em Computação, exercida no Instituto Federal de Educação, Ciência e Tecnologia de São Paulo, Campus São Carlos (IFSP-SCL), lecionada pelo professor Rodrigo Ellias Bianchi.

## Subindo Os Serviços

Para subir os containers referentes ao projeto, é necessário realizar os seguintes passos:

1. Realizar o build da aplicação. Para isso, na raiz do repositório, rode:

```bash
docker build -t backend . 
```

2. Depois, deve-se criar um arquivo `.env` na raiz com as variáveis usadas pelos serviços. 
   - Possuímos o [.env.example](.env.example) com valores mock para serem usados localmente.
   - Para o valor `JWT_SECRET`, será necessário criar um valor em `Base64` de pelo menos 32 caracteres. Pode ser feito pelo terminal usando:
     - Windows: `[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Maximum 256 }))`.
     - Linux/Mac: `openssl rand -base64 32`.

3. Por fim, para iniciar os containers, rode:

```bash
docker compose up -d
```

## Postgres

Para acessar o banco da aplicação, deve estar com o container do banco criado, como foi explicado anteriormente. Usando os valores definidos no arquivo `.env` no comando, rode:
```bash
docker exec -it postgres psql -U user -d sancadinner
```