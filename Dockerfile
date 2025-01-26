# Build stage
FROM node:20 AS builder

WORKDIR /usr/src/app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source
COPY . .

# Build Admin UI and server
RUN npm run build

# Production stage
FROM node:20-slim

WORKDIR /usr/src/app

# Copy package files
COPY package*.json ./

# Install production dependencies only
RUN npm ci --only=production

# Copy built assets from builder
COPY --from=builder /usr/src/app/dist ./dist
COPY --from=builder /usr/src/app/admin-ui/dist ./admin-ui/dist

# Set production environment
ENV NODE_ENV production

EXPOSE 3000
CMD ["npm", "run", "start:server"]
