import { LayoutDashboard, Map, Users } from 'lucide-react'
import { NavLink, Outlet } from 'react-router-dom'
import Box from '@mui/material/Box'
import List from '@mui/material/List'
import ListItemButton from '@mui/material/ListItemButton'
import ListItemIcon from '@mui/material/ListItemIcon'
import ListItemText from '@mui/material/ListItemText'
import Paper from '@mui/material/Paper'
import { useTheme } from '@mui/material/styles'

const SIDEBAR_WIDTH = 260

const navItems = [
  { to: '/', label: 'Dashboard', icon: LayoutDashboard },
  { to: '/mapa', label: 'Mapa en Vivo', icon: Map },
  { to: '/choferes', label: 'Choferes', icon: Users },
]

/**
 * Layout with fixed sidebar and main content area. Sidebar items: Dashboard, Mapa en Vivo, Choferes.
 */
export function DashboardLayout() {
  const theme = useTheme()

  return (
    <Box sx={{ display: 'flex', minHeight: '100vh' }}>
      <Paper
        elevation={0}
        sx={{
          width: SIDEBAR_WIDTH,
          flexShrink: 0,
          borderRight: 1,
          borderColor: 'divider',
          borderRadius: 0,
        }}
      >
        <List component="nav" sx={{ py: 2 }}>
          {navItems.map(({ to, label, icon: Icon }) => (
            <ListItemButton
              key={to}
              component={NavLink}
              to={to}
              sx={{
                mx: 1,
                borderRadius: 1,
                '&.active': {
                  bgcolor: theme.palette.primary.main,
                  color: theme.palette.primary.contrastText,
                  '& .MuiListItemIcon-root': {
                    color: 'inherit',
                  },
                },
              }}
            >
              <ListItemIcon>
                <Icon size={20} />
              </ListItemIcon>
              <ListItemText primary={label} />
            </ListItemButton>
          ))}
        </List>
      </Paper>
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          p: 3,
          bgcolor: 'background.default',
          minWidth: 0,
        }}
      >
        <Outlet />
      </Box>
    </Box>
  )
}
