/** @type {import('vite').UserConfig} */
import react from "@vitejs/plugin-react";
import { readdirSync } from "fs";
import path from "path";
import { defineConfig } from "vite";

const absolutePathAliases = {};
const srcPath = path.resolve("./src/");
const srcRootContent = readdirSync(srcPath, { withFileTypes: true }).map((dirent) =>
  dirent.name.replace(/(\.js){1}(x?)/, "")
);
const env = process.env;

srcRootContent.forEach((directory) => {
  absolutePathAliases[directory] = path.join(srcPath, directory);
});

export default defineConfig({
  resolve: {
    alias: {
      ...absolutePathAliases,
    },
  },
  
  plugins: [react()],
  server: {
    watch: {
      usePolling: true,
    },
    host: true,
    strictPort: true,
    port: 3000,
    proxy: {
      '/api': {
          // Lấy từ biến môi trường, fallback về localhost nếu chạy non-docker
          target: env.VITE_API_TARGET || 'http://localhost:9000',
          changeOrigin: true,
          secure: false,
        }
    }
  },
  preview: {
  }
});
