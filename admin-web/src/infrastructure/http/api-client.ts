import axios from 'axios'

/**
 * Axios instance configured to connect to the backend API.
 * In production build, set VITE_API_URL (e.g. in Docker build args).
 */
export const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_URL ?? 'http://localhost:8080/api',
  headers: {
    'Content-Type': 'application/json',
  },
})
