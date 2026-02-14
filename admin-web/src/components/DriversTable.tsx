import { Pencil, Ban } from 'lucide-react'
import Box from '@mui/material/Box'
import Button from '@mui/material/Button'
import { DataGrid, type GridColDef } from '@mui/x-data-grid'
import type { Driver } from '../domain/entities'

export interface DriversTableProps {
  drivers: Driver[]
  onEdit?: (driver: Driver) => void
  onBlock?: (driver: Driver) => void
}

/**
 * MUI DataGrid listing drivers with Acciones column: Editar and Bloquear.
 */
export function DriversTable({ drivers, onEdit, onBlock }: DriversTableProps) {
  const columns: GridColDef<Driver>[] = [
    { field: 'id', headerName: 'ID', width: 80 },
    { field: 'email', headerName: 'Email', flex: 1, minWidth: 200 },
    { field: 'rol', headerName: 'Rol', width: 120 },
    {
      field: 'acciones',
      headerName: 'Acciones',
      width: 180,
      sortable: false,
      filterable: false,
      renderCell: ({ row }) => (
        <Box sx={{ display: 'flex', gap: 0.5 }}>
          <Button
            size="small"
            variant="outlined"
            startIcon={<Pencil size={16} />}
            onClick={() => onEdit?.(row)}
          >
            Editar
          </Button>
          <Button
            size="small"
            color="error"
            variant="outlined"
            startIcon={<Ban size={16} />}
            onClick={() => onBlock?.(row)}
          >
            Bloquear
          </Button>
        </Box>
      ),
    },
  ]

  return (
    <DataGrid
      rows={drivers}
      columns={columns}
      getRowId={(row) => row.id}
      initialState={{
        pagination: { paginationModel: { pageSize: 10 } },
      }}
      pageSizeOptions={[5, 10, 25]}
      disableRowSelectionOnClick
      autoHeight
    />
  )
}
