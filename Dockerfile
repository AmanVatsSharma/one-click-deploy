# Build stage
FROM node:20 AS builder

WORKDIR /usr/src/app

# Install ALL dependencies (including devDependencies)
COPY package*.json ./
RUN npm ci

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

# Build server
RUN echo "Building server..." && \
    npm run build:server && \
    echo "Server build complete. Contents:" && \
    ls -la dist/

# Production stage
FROM node:20-slim

WORKDIR /usr/src/app

# Copy package files
COPY package*.json ./

# Install production dependencies only
RUN npm ci --only=production

# Create necessary directories
RUN mkdir -p dist admin-ui/dist

# Copy built assets from builder with verification
COPY --from=builder /usr/src/app/dist ./dist/
COPY --from=builder /usr/src/app/admin-ui/dist ./admin-ui/dist/

# Verify final structure
RUN echo "Final dist contents:" && ls -la dist/ && \
    echo "Final admin-ui contents:" && ls -la admin-ui/dist/

# Set production environment
ENV NODE_ENV production

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

EXPOSE 3000
CMD ["npm", "run", "start:server"]
