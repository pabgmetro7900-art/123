FROM python:3.9-slim
WORKDIR /app
RUN pip install aiogram==3.3.0 aiohttp==3.9.1
COPY bot.py .
CMD ["python", "bot.py"]
