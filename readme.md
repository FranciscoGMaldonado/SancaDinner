# Sanca-Dinner

Projeto desenvolvido para a disciplina de Tópicos em Computação, execida no Instituto Federal de Educação, Ciência e Tecnologia de São Paulo, Campus São Carlos (IFSP-SCL), lecionada pelo professor Rodrigo Ellias Bianchi.

## Subindo Os Serviços

Para subir os containers referentes ao projeto, basta usar esse comando no diretório raiz:
```bash
docker compose up -d
```

## Postgres

Para acessar o banco e conseguir iniciar a conexão com o Postgres, é preciso criar um arquivo `.env` com os valores que serão usados na criação do banco. Disponibilizamos um arquivo `.env.example` no repositório para ser usado como referência:
```env
POSTGRES_DB=sancadinner
POSTGRES_USER=seu_usuario
POSTGRES_PASSWORD=sua_senha
```

Além disso, é necessário configurar o arquivo `application.properties` com os mesmos valores:
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/sancadinner
spring.datasource.username=seu_usuario
spring.datasource.password=sua_senha
```