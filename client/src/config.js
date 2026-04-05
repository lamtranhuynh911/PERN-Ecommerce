// src/config.js

const getEnv = (key, defaultValue = "") => {
  // 👇 Bước 1: Kiểm tra xem có phải môi trường Browser không?
  if (typeof window !== "undefined" && window._env_ && window._env_[key]) {
    return window._env_[key];
  }

  // 👇 Bước 2: Nếu không (hoặc đang build), dùng import.meta.env
  // Lưu ý: import.meta.env an toàn với Vite
  return import.meta.env[key] || defaultValue;
};

export const config = {
  googleClientId: getEnv("VITE_GOOGLE_CLIENT_ID"),
  stripePubKey: getEnv("VITE_STRIPE_PUB_KEY"),
  paystackPubKey: getEnv("VITE_PAYSTACK_PUB_KEY"),
  apiUrl: getEnv("VITE_API_TARGET", "http://localhost:9000"),
  nodeEnv: getEnv("VITE_NODE_ENV", "development"),
};
