import { useState, useEffect, useCallback } from 'react'
import type { Truck } from '../../domain/entities'
import { getTrucksUseCase } from '../../application/container'

/**
 * Hook that fetches trucks from the application layer (GetTrucksUseCase).
 * Refreshes every 5 seconds for live map updates.
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
    const interval = setInterval(fetchTrucks, 5000)
    return () => clearInterval(interval)
  }, [fetchTrucks])

  return { trucks, loading, error, refetch: fetchTrucks }
}
