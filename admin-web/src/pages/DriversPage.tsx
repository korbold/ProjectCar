import { useState, useEffect } from 'react'
import Typography from '@mui/material/Typography'
import { DriversTable } from '../components/DriversTable'
import { api } from '../api/client'
import type { Driver } from '../types'

/**
 * Page that lists drivers using the DriversTable component.
 */
export function DriversPage() {
  const [drivers, setDrivers] = useState<Driver[]>([])

  useEffect(() => {
    api
      .get<Driver[]>('/usuarios')
      .then((res) => setDrivers(Array.isArray(res.data) ? res.data : []))
      .catch(() => {
        setDrivers([
          { id: 1, email: 'admin@ibarra.local', rol: 'ADMIN' },
          { id: 2, email: 'conductor@ejemplo.com', rol: 'CONDUCTOR' },
        ])
      })
  }, [])

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
