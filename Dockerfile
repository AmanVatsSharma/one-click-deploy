# Build stage
FROM node:20 AS builder

WORKDIR /usr/src/app

# Install ALL dependencies (including devDependencies)
COPY package*.json ./
RUN npm ci

# Copy source
COPY . .

# Build Admin UI and server
RUN npm run build

# Verify build output
RUN ls -la dist/
RUN ls -la admin-ui/dist/

# Production stage
FROM node:20-slim

WORKDIR /usr/src/app

# Copy package files
COPY package*.json ./

# Install production dependencies only
RUN npm ci --only=production

# Create necessary directories
RUN mkdir -p dist admin-ui/dist

# Copy built assets from builder
COPY --from=builder /usr/src/app/dist ./dist
COPY --from=builder /usr/src/app/admin-ui/dist ./admin-ui/dist

# Verify copied files
RUN ls -la dist/
RUN ls -la admin-ui/dist/

# Set production environment
ENV NODE_ENV production

EXPOSE 3000
CMD ["npm", "run", "start:server"]
