
FROM public.ecr.aws/lambda/nodejs:20 AS builder

COPY package.json package-lock.json ./

RUN npm ci

COPY src/ ./src/

RUN npm run build

FROM public.ecr.aws/lambda/nodejs:20

COPY --from=builder ${LAMBDA_TASK_ROOT}/dist/handler.js ${LAMBDA_TASK_ROOT}/

CMD ["handler.handler"]
