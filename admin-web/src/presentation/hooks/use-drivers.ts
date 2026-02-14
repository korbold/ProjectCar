import { useState, useEffect, useCallback } from 'react'
import type { Driver } from '../../domain/entities'
import { getDriversUseCase } from '../../application/container'

/**
 * Hook that fetches drivers from the application layer (GetDriversUseCase).
 */
export function useDrivers(): {
  drivers: Driver[]
  loading: boolean
  error: Error | null
  refetch: () => Promise<void>
} {
  const [drivers, setDrivers] = useState<Driver[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<Error | null>(null)

  const fetchDrivers = useCallback(async () => {
    try {
      setError(null)
      const data = await getDriversUseCase.execute()
      setDrivers(data)
    } catch (e) {
      setError(e instanceof Error ? e : new Error(String(e)))
      setDrivers([
        { id: 1, email: 'admin@ibarra.local', rol: 'ADMIN' },
        { id: 2, email: 'conductor@ejemplo.com', rol: 'CONDUCTOR' },
      ])
    } finally {
      setLoading(false)
    }
  }, [])

  useEffect(() => {
    fetchDrivers()
  }, [fetchDrivers])

  return { drivers, loading, error, refetch: fetchDrivers }
}
