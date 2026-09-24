# --- ETAPA 1: Construcción (Builder) ---
FROM public.ecr.aws/lambda/nodejs:20 AS builder

WORKDIR ${LAMBDA_TASK_ROOT}

# Copiar manifiesto y lock file
COPY package.json package-lock.json ./

# Instalación limpia desde el lock file
RUN npm ci

# Copiar el código fuente
COPY src/ ./src/

# Empaquetar la aplicación en dist/handler.js
RUN npm run build


# --- ETAPA 2: Imagen Final ---
FROM public.ecr.aws/lambda/nodejs:20

WORKDIR ${LAMBDA_TASK_ROOT}

# Copiar el artefacto empaquetado preservando la carpeta dist
COPY --from=builder ${LAMBDA_TASK_ROOT}/dist/ ./dist/

CMD ["dist/handler.handler"]
