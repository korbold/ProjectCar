import Typography from '@mui/material/Typography'
import Box from '@mui/material/Box'
import { LiveMap } from '../components/LiveMap'
import { useTrucks } from '../presentation/hooks'

/**
 * Page that renders the live map with trucks from the application layer.
 */
export function MapPage() {
  const { trucks } = useTrucks()

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
