FROM ghcr.io/cirruslabs/flutter:3.41.7

WORKDIR /app

COPY pubspec.* ./
RUN flutter pub get

COPY . .

EXPOSE 3000