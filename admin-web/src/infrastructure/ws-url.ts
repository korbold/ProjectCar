/**
 * WebSocket URL for STOMP (e.g. ws://localhost:8080/ws).
 * Derived from VITE_API_URL: same host/port, path /ws, scheme ws/wss.
 */
export function getWebSocketUrl(): string {
  const apiUrl = import.meta.env.VITE_API_URL ?? 'http://localhost:8080/api'
  const url = new URL(apiUrl)
  const wsProtocol = url.protocol === 'https:' ? 'wss:' : 'ws:'
  return `${wsProtocol}//${url.host}/ws`
}
