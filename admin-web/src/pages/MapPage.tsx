import { useState, useEffect } from 'react'
import Typography from '@mui/material/Typography'
import Box from '@mui/material/Box'
import { LiveMap } from '../components/LiveMap'
import { api } from '../api/client'
import type { Truck } from '../types'

/**
 * Page that renders the live map with trucks from the API (or mock data).
 */
export function MapPage() {
  const [trucks, setTrucks] = useState<Truck[]>([])

  useEffect(() => {
    const fetchTrucks = async () => {
      try {
        const res = await api.get<Truck[]>('/camiones')
        setTrucks(Array.isArray(res.data) ? res.data : [])
      } catch {
        setTrucks((prev) =>
          prev.length ? prev : [{ id: '1', placa: 'ABC-1234', activo: true, ubicacion: { lat: -0.3517, lng: -78.1223 } }]
        )
      }
    }
    fetchTrucks()
    const interval = setInterval(fetchTrucks, 5000)
    return () => clearInterval(interval)
  }, [])

  return (
    <>
      <Typography variant="h4" gutterBottom>
        Mapa en Vivo
      </Typography>
      <Box sx={{ height: 'calc(100vh - 180px)', minHeight: 400 }}>
        <LiveMap trucks={trucks} />
      </Box>
    </>
  )
}
