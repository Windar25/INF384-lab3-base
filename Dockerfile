# --- ETAPA 1: Construcción (Builder) ---
FROM public.ecr.aws/lambda/nodejs:20 AS builder

# Usamos una carpeta de trabajo temporal aislada
WORKDIR /build

# Copiamos solo los archivos de dependencias
COPY package.json package-lock.json ./

# Instalación limpia desde el lock file
RUN npm ci

# Copiamos el código fuente
COPY src/ ./src/

# Empaquetamos el proyecto en dist/handler.js
RUN npm run build


# --- ETAPA 2: Imagen Final ---
FROM public.ecr.aws/lambda/nodejs:20

# Directorio de trabajo nativo de AWS Lambda
WORKDIR ${LAMBDA_TASK_ROOT}

# Copiamos UNICAMENTE la carpeta dist generada
COPY --from=builder /build/dist/ ./dist/

# Manejador de la función Lambda
CMD ["dist/handler.handler"]
