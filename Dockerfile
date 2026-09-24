# Dockerfile corregido para el Laboratorio 3 (A1)

# Etapa 1: Construcción (build)
# Corrección Defecto 1: Usar versión fija (nodejs:20) y nombrar la etapa 'build'
FROM public.ecr.aws/lambda/nodejs:20 AS build

# Establecer el directorio de trabajo obligatorio
WORKDIR /build

# Corrección Defecto 2 y 3: Copiar manifests primero e instalar con 'npm ci' para builds reproducibles
COPY package*.json ./
RUN npm ci

# Copiar el código fuente
COPY . .

# Corrección Defecto 4: Se eliminó la credencial en texto plano (ENV DB_PASSWORD)

# Corrección Defecto 5: Se eliminó la instalación de herramientas del sistema (dnf)

### NO TOCAR DE ACA EN ADELANTE, CONSIDEREN QUE EL WORKDIR DEBE SER /build
RUN npx esbuild src/handler.js \
      --bundle --platform=node --target=node20 \
      --outfile=dist/handler.js

# Etapa final: recibe unicamente el artefacto empaquetado.
# El arbol de node_modules se queda en la etapa anterior.
FROM public.ecr.aws/lambda/nodejs:20 AS runtime
COPY --from=build /build/dist/handler.js ${LAMBDA_TASK_ROOT}/
CMD ["handler.handler"]
