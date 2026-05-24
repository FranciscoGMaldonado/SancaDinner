# Sanca-Dinner

Projeto desenvolvido para a disciplina de Tópicos em Computação, exercida no Instituto Federal de Educação, Ciência e Tecnologia de São Paulo, Campus São Carlos (IFSP-SCL), lecionada pelo professor Rodrigo Ellias Bianchi.

## Subindo Os Serviços

Para subir os containers referentes ao projeto, é necessário realizar os seguintes passos:

### Builds

- Primeiro, realize os builds da aplicação. Na raiz do repositório, rode:

```bash
docker build -t backend ./backend/.
docker build -t frontend ./frontend/.
```

### Backend

- Para rodar os serviços de Backend, deve-se criar um arquivo `.env` no diretório do `backend` com as variáveis usadas pelos serviços. 
  - Possuímos o [.env.example](.env.example) com valores mock para serem usados localmente.
  - Para o valor `JWT_SECRET`, será necessário criar um valor em `Base64` de pelo menos 32 caracteres. Pode ser feito pelo terminal usando:
    - Windows: `[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Maximum 256 }))`.
    - Linux/Mac: `openssl rand -base64 32`.

- Para iniciá-los, rode o comando:

```bash
docker compose up -d
```

### Frontend

- Primeiro, deve rodar esse comando no diretório do `frontend`:

```bash
flutter pub get
```

- Depois, use esse comando para criar o container do Frontend:

```bash
docker run -it --rm --name frontend -p 3000:3000 -v ./frontend:/app -v /app/.dart_tool frontend bash
```

- Para iniciar o servidor web, rode dentro do container:

```bash
flutter run -d web-server --web-port=3000
```

## Postgres

Para acessar o banco da aplicação, deve estar com o container do banco criado, como foi explicado anteriormente. Usando os valores definidos no arquivo `.env` no comando, rode:
```bash
docker exec -it postgres psql -U user -d sancadinner
```
