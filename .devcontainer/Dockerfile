FROM elixir:1.17.1-otp-27-alpine
ENV MIX_ENV=dev
ENV RUSTFLAGS='-C target-feature=-crt-static'
RUN apk add --no-cache git curl gcc musl-dev
CMD ["sleep", "infinity"]