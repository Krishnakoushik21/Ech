FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Python runtime settings
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Fix matplotlib headless crash
ENV MPLBACKEND=Agg

# System dependencies (REQUIRED for faiss, numpy, matplotlib)
RUN apt-get update && apt-get install -y \
    build-essential \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies first (layer caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Streamlit default port
EXPOSE 8501

# Run Streamlit app
CMD ["streamlit", "run", "backend/app.py", "--server.address=0.0.0.0", "--server.port=8501"]
