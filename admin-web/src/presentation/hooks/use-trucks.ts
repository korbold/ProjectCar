import { useState, useEffect, useCallback } from 'react'
import { Client } from '@stomp/stompjs'
import type { Truck } from '../../domain/entities'
import { getTrucksUseCase } from '../../application/container'
import { getWebSocketUrl } from '../../infrastructure/ws-url'

function mergeTruckById(prev: Truck[], truck: Truck): Truck[] {
  const rest = prev.filter((t) => t.id !== truck.id)
  return [...rest, truck]
}

/**
 * Hook that fetches trucks and subscribes to real-time location updates via WebSocket (STOMP).
 * Initial load from GET /camiones; updates pushed on /topic/camiones.ubicacion.
 */
export function useTrucks(): {
  trucks: Truck[]
  loading: boolean
  error: Error | null
  refetch: () => Promise<void>
} {
  const [trucks, setTrucks] = useState<Truck[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<Error | null>(null)

  const fetchTrucks = useCallback(async () => {
    try {
      setError(null)
      const data = await getTrucksUseCase.execute()
      setTrucks(data)
    } catch (e) {
      setError(e instanceof Error ? e : new Error(String(e)))
      setTrucks((prev) =>
        prev.length
          ? prev
          : [
              {
                id: '1',
                placa: 'ABC-1234',
                activo: true,
                ubicacion: { lat: -0.3517, lng: -78.1223 },
              },
            ]
      )
    } finally {
      setLoading(false)
    }
  }, [])

  useEffect(() => {
    fetchTrucks()
  }, [fetchTrucks])

  useEffect(() => {
    const client = new Client({
      brokerURL: getWebSocketUrl(),
    })
    client.onConnect = () => {
      client.subscribe('/topic/camiones.ubicacion', (message) => {
        try {
          const body = JSON.parse(message.body) as Truck
          if (body?.id) {
            setTrucks((prev) => mergeTruckById(prev, body))
          }
        } catch {
          // ignore malformed messages
        }
      })
    }
    client.activate()
    return () => {
      void client.deactivate()
    }
  }, [])

  return { trucks, loading, error, refetch: fetchTrucks }
}
