FROM node:22-slim

# Create app directory
WORKDIR /app

# Install Playwright MCP package
RUN npm install @playwright/mcp@latest

# Expose port
EXPOSE 8020

# Set the default command
CMD ["npx", "@playwright/mcp@latest", "--port", "8020"]
