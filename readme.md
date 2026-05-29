# Sanca-Dinner

Projeto desenvolvido para a disciplina de Tópicos em Computação, exercida no Instituto Federal de Educação, Ciência e Tecnologia de São Paulo, Campus São Carlos (IFSP-SCL), lecionada pelo professor Rodrigo Ellias Bianchi.

## Subindo a Aplicação

Para subir os containers referentes ao projeto, basta rodar o comando:

```bash
docker compose up --build -d
```

## Usuários

Para logar na plataforma, criamos alguns usuários mock referentes a cada _role_:

| Email                 | Senha          | Role    |
|-----------------------|----------------|---------|
| admin@gmail.com       | admin123       | ADMIN   |
| atendimento@gmail.com | atendimento123 | SERVICE |
| cozinha@gmail.com     | cozinha123     | KITCHEN |

## Postgres

Para acessar o banco da aplicação, caso queira verificar os dados registrados, basta rodar o comando:

```bash
docker exec -it postgres psql -U user -d sancadinner
```
