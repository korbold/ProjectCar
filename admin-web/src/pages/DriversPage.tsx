import Typography from '@mui/material/Typography'
import { DriversTable } from '../components/DriversTable'
import { useDrivers } from '../presentation/hooks'
import type { Driver } from '../domain/entities'

/**
 * Page that lists drivers using the DriversTable component.
 * Data comes from the application layer via useDrivers.
 */
export function DriversPage() {
  const { drivers } = useDrivers()

  const handleEdit = (driver: Driver) => {
    console.log('Editar', driver)
    // TODO: open edit modal/dialog
  }

  const handleBlock = (driver: Driver) => {
    console.log('Bloquear', driver)
    // TODO: confirm and call API to block
  }

  return (
    <>
      <Typography variant="h4" gutterBottom>
        Choferes
      </Typography>
      <DriversTable
        drivers={drivers}
        onEdit={handleEdit}
        onBlock={handleBlock}
      />
    </>
  )
}
