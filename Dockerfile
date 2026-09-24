# ETAPA 1: Builder
FROM public.ecr.aws/lambda/nodejs:20 AS builder
WORKDIR /build
COPY package.json package-lock.json ./
RUN npm ci
COPY src/ ./src/
RUN npm run build

# ETAPA 2: Imagen Final
FROM public.ecr.aws/lambda/nodejs:20
WORKDIR /var/task
COPY --from=builder /build/dist/handler.js ./handler.js
CMD ["handler.handler"]
