# Stage 1: Build Vue.js application
FROM node:18 AS build

# Set working directory
WORKDIR /app

# Install Vue CLI globally
RUN npm install -g @vue/cli

# Create a new Vue.js project
RUN vue create my-vue-app --default --packageManager=npm

# Change working directory to the newly created project
WORKDIR /app/my-vue-app

# Install babel-eslint and other required packages
RUN npm install babel-eslint eslint-plugin-vue @vue/cli-plugin-eslint --save-dev

# Create or modify the .eslintrc.js to disable the multi-word-component-names rule
RUN echo "module.exports = { root: true, env: { node: true }, extends: ['plugin:vue/essential', 'eslint:recommended'], parserOptions: { parser: 'babel-eslint' }, rules: { 'vue/multi-word-component-names': 'off' } };" > .eslintrc.js

# Copy the App.vue file into the project
COPY frontend/App.vue src/App.vue

# Install project dependencies
RUN npm install

# Build the Vue.js project
RUN npm run build

# Install a simple web server to serve the static files
RUN npm install -g serve

# Stage 2: Use the official PHP image with Apache
FROM php:8.2-apache

# Copy the PHP application to the Apache root directory
COPY backend /var/www/html/

# Copy the built Vue.js application to a public directory
COPY --from=build /app/my-vue-app/dist /var/www/html/frontend

# Expose ports
EXPOSE 80
EXPOSE 5000

# Command to run the Apache server and serve static files
CMD ["sh", "-c", "apache2-foreground & serve -s /var/www/html/frontend -l 5000"]
