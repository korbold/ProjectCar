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
    api
      .get<Truck[]>('/camiones')
      .then((res) => setTrucks(Array.isArray(res.data) ? res.data : []))
      .catch(() => {
        // Mock data when backend is not available
        setTrucks([
          {
            id: '1',
            placa: 'ABC-1234',
            activo: true,
            ubicacion: { lat: -0.3517, lng: -78.1223 },
          },
        ])
      })
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
