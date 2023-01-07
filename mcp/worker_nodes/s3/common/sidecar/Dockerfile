FROM python:3.10.6-slim-buster AS builder

ENV LANG=C.UTF-8
ENV PYTHONUNBUFFERED=1
ENV PATH="/venv/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1

RUN python3 -m venv /venv
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

FROM python:3.10.6 AS runtime-image

ENV PYTHONUNBUFFERED=1
ENV PATH="/venv/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

COPY --from=builder /venv /venv
WORKDIR /usr/src/app

RUN addgroup --system user && adduser --system --no-create-home --group user
RUN chown -R user:user /usr/src/app && chmod -R 755 /usr/src/app

USER user
COPY secrets/ /usr/src/app/secrets

ENTRYPOINT ["python3"]

CMD ["secrets/run.py"]
