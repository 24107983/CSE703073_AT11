import { createRouter, createWebHistory } from 'vue-router'

import AdminView from '../views/AdminView.vue'
import ForbiddenView from '../views/ForbiddenView.vue'

const router = createRouter({
  history: createWebHistory(),

  routes: [
    {
      path: '/',
      name: 'home',
      component: () => import('../views/HomeView.vue')
    },

    {
      path: '/admin',
      name: 'admin',
      component: AdminView
    },

    {
      path: '/mon-an',
      name: 'mon-an',
      component: () => import('../views/DishListView.vue')
    },

    {
      path: '/mon-an/:id',
      name: 'mon-an-chi-tiet',
      component: () => import('../views/DishDetailView.vue')
    },

    {
      path: '/ban-do',
      name: 'ban-do',
      component: () => import('../views/MapView.vue')
    },

    {
      path: '/hanh-trinh',
      name: 'hanh-trinh',
      component: () => import('../views/JourneyView.vue')
    },

    {
      path: '/dang-nhap',
      name: 'dang-nhap',
      component: () => import('../views/LoginView.vue')
    },
    {
      path: '/dang-ky',
      name: 'dang-ky',
      component: () => import('../views/RegisterView.vue')
    },
    {
      path: '/403',
      name: 'forbidden',
      component: ForbiddenView
    }
  ]
})

router.beforeEach((to) => {
  if (to.path !== '/admin') {
    return true
  }

  const user = localStorage.getItem('auth_user')

  if (!user) {
    return '/dang-nhap'
  }

  const authUser = JSON.parse(user)

  if (authUser.vai_tro !== 'quan_tri_vien') {
    return '/403'
  }

  return true
})

export default router