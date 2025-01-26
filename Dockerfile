# Build stage
FROM node:20 AS builder

WORKDIR /usr/src/app

# Install dependencies with exact versions
COPY package*.json ./
RUN npm install

# Copy source
COPY . .

# Show directory structure before build
RUN echo "Directory structure before build:" && ls -la

# Clean any previous builds
RUN npm run clean

# Build Admin UI first
RUN echo "Building Admin UI..." && \
    npm run build:admin && \
    echo "Admin UI build complete. Contents:" && \
    ls -la admin-ui/dist/

# Build server with verbose output
RUN echo "Building server..." && \
    npm run build:server && \
    echo "Server build complete. Contents:" && \
    ls -la dist/

# Production stage
FROM node:20-slim

WORKDIR /usr/src/app

# Copy package files and install production dependencies
COPY package*.json ./
RUN npm install --only=production

# Create necessary directories
RUN mkdir -p dist admin-ui/dist

# Copy built assets from builder with verification
COPY --from=builder /usr/src/app/dist/ ./dist/
COPY --from=builder /usr/src/app/admin-ui/dist/ ./admin-ui/dist/

# Verify final structure
RUN echo "Final structure:" && \
    echo "dist contents:" && ls -la dist/

# Set production environment
ENV NODE_ENV production

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

EXPOSE 3000
CMD ["node", "./dist/index.js"]
