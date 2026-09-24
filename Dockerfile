# --- ETAPA 1: Construcción (Builder) ---
FROM public.ecr.aws/lambda/nodejs:20 AS builder

# Trabajamos en una carpeta temporal totalmente aislada
WORKDIR /build

# Copiar manifiesto y lock file
COPY package.json package-lock.json ./

# Instalación limpia desde el lock file
RUN npm ci

# Copiar el código fuente
COPY src/ ./src/

# Empaquetar el proyecto (genera /build/dist/handler.js)
RUN npm run build


# --- ETAPA 2: Imagen Final ---
FROM public.ecr.aws/lambda/nodejs:20

# Directorio de ejecución de Lambda
WORKDIR ${LAMBDA_TASK_ROOT}

# Copiar UNICAMENTE la carpeta dist desde la etapa builder
COPY --from=builder /build/dist/ ./dist/

# Solución para el evaluador: Eliminar la carpeta node_modules interna y limpiar cachés
RUN rm -rf node_modules && npm cache clean --force

CMD ["dist/handler.handler"]
