<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { RouterLink } from 'vue-router'
const router = useRouter()

const user = ref(null)

const isDark = ref(false)

const applyTheme = (dark) => {
  isDark.value = dark

  document.documentElement.setAttribute(
    'data-theme',
    dark ? 'dark' : 'light'
  )

  localStorage.setItem(
    'app-theme',
    dark ? 'dark' : 'light'
  )
}

const toggleTheme = () => {
  applyTheme(!isDark.value)
}

const loadUser = () => {
  const savedUser = localStorage.getItem('auth_user')

  user.value = savedUser
    ? JSON.parse(savedUser)
    : null
}

const handleAuthChange = () => {
  loadUser()
}

const handleLogout = async () => {
  try {
    const response = await fetch(
      '/api/auth/logout',
      {
        method: 'POST',
        headers: {
          Accept: 'application/json'
        },
        credentials: 'include'
      }
    )

    if (!response.ok && response.status !== 204) {
      throw new Error(`HTTP ${response.status}`)
    }
  } catch (error) {
    console.error(error)
  } finally {
    localStorage.removeItem('auth_user')

    window.dispatchEvent(
      new Event('auth-changed')
    )

    router.push('/dang-nhap')
  }
}
const mobileMenuOpen = ref(false)

const toggleMobileMenu = () => {
  mobileMenuOpen.value = !mobileMenuOpen.value
}

const closeMobileMenu = () => {
  mobileMenuOpen.value = false
}

onMounted(() => {
  loadUser()
  const savedTheme = localStorage.getItem('app-theme')
  applyTheme(savedTheme === 'dark')
  window.addEventListener(
    'auth-changed',
    handleAuthChange
  )
})

onUnmounted(() => {
  window.removeEventListener(
    'auth-changed',
    handleAuthChange
  )
})
</script>

<template>
  <header class="site-header">

    <div class="container header-inner">

      <!-- LOGO -->
      <RouterLink
        to="/"
        class="logo"
        @click="closeMobileMenu"
      >
        AT-11
      </RouterLink>


      <!-- DESKTOP NAV -->
      <nav class="main-nav">

        <RouterLink
          to="/"
          @click="closeMobileMenu"
        >
          Trang chá»§
        </RouterLink>

        <RouterLink
          to="/mon-an"
          @click="closeMobileMenu"
        >
          MĂ³n Äƒn
        </RouterLink>

        <RouterLink
          to="/ban-do"
          @click="closeMobileMenu"
        >
          Báº£n Ä‘á»“
        </RouterLink>

        <RouterLink
          to="/hanh-trinh"
          @click="closeMobileMenu"
        >
          HĂ nh trĂ¬nh áº©m thá»±c
        </RouterLink>
<RouterLink
        v-if="user?.vai_tro === 'quan_tri_vien'"
        to="/admin"
        @click="closeMobileMenu"
      >
        Quáº£n trá»‹
      </RouterLink>
      </nav>


<button
  type="button"
  class="theme-toggle"
  :aria-label="isDark ? 'Chuyá»ƒn sang giao diá»‡n sĂ¡ng' : 'Chuyá»ƒn sang giao diá»‡n tá»‘i'"
  @click="toggleTheme"
>
  {{ isDark ? 'â˜€ï¸ SĂ¡ng' : 'đŸŒ™ Tá»‘i' }}
</button>

      <!-- DESKTOP AUTH -->
      <div
        v-if="!user"
        class="auth-actions desktop-auth"
      >
        <RouterLink
          to="/dang-ky"
          class="auth-link"
        >
          ÄÄƒng kĂ½
        </RouterLink>

        <RouterLink
          to="/dang-nhap"
          class="auth-link"
        >
          ÄÄƒng nháº­p
        </RouterLink>
      </div>


      <div
        v-else
        class="auth-actions desktop-auth"
      >
        <button
          type="button"
          class="auth-link logout-button"
          @click="handleLogout"
        >
          ÄÄƒng xuáº¥t
        </button>
      </div>


      <!-- MOBILE BUTTON -->
      <button
        type="button"
        class="mobile-menu-button"
        :aria-expanded="mobileMenuOpen"
        aria-label="Má»Ÿ menu"
        @click="toggleMobileMenu"
      >
        <span></span>
        <span></span>
        <span></span>
      </button>

    </div>


    <!-- MOBILE MENU -->
    <div
      v-if="mobileMenuOpen"
      class="mobile-menu"
    >

      <nav class="mobile-nav">

        <RouterLink
          to="/"
          @click="closeMobileMenu"
        >
          Trang chá»§
        </RouterLink>

        <RouterLink
          to="/mon-an"
          @click="closeMobileMenu"
        >
          MĂ³n Äƒn
        </RouterLink>

        <RouterLink
          to="/ban-do"
          @click="closeMobileMenu"
        >
          Báº£n Ä‘á»“
        </RouterLink>

        <RouterLink
          to="/hanh-trinh"
          @click="closeMobileMenu"
        >
          HĂ nh trĂ¬nh áº©m thá»±c
        </RouterLink>
<RouterLink
        v-if="user?.vai_tro === 'quan_tri_vien'"
        to="/admin"
        @click="closeMobileMenu"
      >
        Quáº£n trá»‹
      </RouterLink>
        <RouterLink
          to="/hanh-trinh"
          class="mobile-booking-link"
          @click="closeMobileMenu"
        >
          Äáº·t chá»—
        </RouterLink>

      </nav>


      <div
        v-if="!user"
        class="mobile-auth"
      >
        <RouterLink
          to="/dang-ky"
          class="mobile-auth-link"
          @click="closeMobileMenu"
        >
          ÄÄƒng kĂ½
        </RouterLink>

        <RouterLink
          to="/dang-nhap"
          class="mobile-auth-link mobile-login"
          @click="closeMobileMenu"
        >
          ÄÄƒng nháº­p
        </RouterLink>
      </div>


      <div
        v-else
        class="mobile-auth"
      >
        <button
          type="button"
          class="mobile-auth-link mobile-login"
          @click="handleLogout"
        >
          ÄÄƒng xuáº¥t
        </button>
      </div>

    </div>

  </header>
</template>
<style scoped>
/* =====================================================
   HEADER
====================================================== */

.site-header {
  position: relative;
  z-index: 1000;

  background: var(--color-background);

  border-bottom: 1px solid var(--color-border);
}

.header-inner {
  min-height: 72px;

  display: flex;
  align-items: center;

  gap: 36px;
}


/* LOGO */

.logo {
  flex-shrink: 0;

  color: var(--color-primary);

  font-size: 24px;
  font-weight: 800;

  text-decoration: none;
}


/* DESKTOP NAV */

.main-nav {
  display: flex;
  align-items: center;
  gap: 30px;

  flex: 1;
}

.main-nav a {
  color: var(--color-text);

  font-size: 16px;
  font-weight: 500;

  text-decoration: none;

  white-space: nowrap;

  transition: color 0.2s ease;
}

.main-nav a:hover,
.main-nav a.router-link-active {
  color: var(--color-primary);
}


/* AUTH */

.auth-actions {
  display: flex;
  align-items: center;
  gap: 12px;

  flex-shrink: 0;
}

.auth-link {
  display: inline-flex;
  align-items: center;
  justify-content: center;

  min-height: 42px;
  padding: 0 18px;

  border: 1px solid var(--color-primary);
  border-radius: 10px;

  background: transparent;

  color: var(--color-primary);

  font-size: 15px;
  font-weight: 600;

  text-decoration: none;

  cursor: pointer;
}

.auth-link:hover {
  background: var(--color-primary);
  color: #ffffff;
}


/* MOBILE BUTTON */

.mobile-menu-button {
  display: none;

  width: 42px;
  height: 42px;

  padding: 8px;

  border: 1px solid var(--color-border);
  border-radius: 10px;

  background: var(--color-background);

  cursor: pointer;
}

.mobile-menu-button span {
  display: block;

  width: 22px;
  height: 2px;

  margin: 4px auto;

  background: var(--color-text);

  border-radius: 2px;
}


/* MOBILE MENU */

.mobile-menu {
  display: none;
}


/* =====================================================
   MOBILE
====================================================== */

@media (max-width: 767px) {

  .header-inner {
    min-height: 64px;

    gap: 0;

    justify-content: space-between;
  }


  .logo {
    font-size: 22px;
  }


  /* áº¨N NAV DESKTOP */

  .main-nav {
    display: none;
  }

  .desktop-auth {
    display: none;
  }


  /* HIá»†N NĂT MENU */

  .mobile-menu-button {
    display: block;
  }


  /* MENU */

  .mobile-menu {
    display: block;

    position: absolute;

    top: 100%;
    left: 0;
    right: 0;

    background: var(--color-background);

    border-top: 1px solid var(--color-border);
    border-bottom: 1px solid var(--color-border);

    box-shadow:
      0 12px 24px rgba(15, 23, 42, 0.08);
  }


  .mobile-nav {
    display: flex;
    flex-direction: column;

    padding: 8px 16px;
  }


  .mobile-nav a {
    display: flex;
    align-items: center;

    min-height: 48px;
    padding: 0 8px;

    border-bottom: 1px solid var(--color-border);

    color: var(--color-text);

    font-size: 16px;
    font-weight: 500;

    text-decoration: none;
  }


  .mobile-nav a:last-child {
    border-bottom: none;
  }


  .mobile-nav a.router-link-active {
    color: var(--color-primary);
    font-weight: 700;
  }


  /* Äáº¶T CHá»– */

  .mobile-nav .mobile-booking-link {
    color: var(--color-primary);
    font-weight: 700;
  }


  /* AUTH MOBILE */

  .mobile-auth {
    display: grid;
    grid-template-columns: 1fr 1fr;

    gap: 10px;

    padding: 16px;
  }


  .mobile-auth-link {
    display: flex;
    align-items: center;
    justify-content: center;

    min-height: 44px;

    border: 1px solid var(--color-primary);
    border-radius: 10px;

    background: transparent;

    color: var(--color-primary);

    font-size: 15px;
    font-weight: 600;

    text-decoration: none;

    cursor: pointer;
  }


  .mobile-login {
    background: var(--color-primary);
    color: #ffffff;
  }
  .theme-toggle {
  margin-left: auto;
  margin-right: 10px;
  min-height: 36px;
  padding: 0 11px;
  font-size: 12px;
}

}

/* Theme toggle */
.theme-toggle {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 7px;

  min-height: 38px;
  padding: 0 14px;

  border: 1px solid var(--color-border);
  border-radius: 999px;

  background: var(--color-surface);
  color: var(--color-text);

  font-size: 13px;
  font-weight: 600;
  white-space: nowrap;

  cursor: pointer;
  transition:
    background 0.2s ease,
    color 0.2s ease,
    border-color 0.2s ease,
    transform 0.2s ease;
}

.theme-toggle:hover {
  border-color: var(--color-primary);
  background: var(--color-background);
  transform: translateY(-1px);
}

.theme-toggle:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 3px;
}

.theme-toggle:active {
  transform: scale(0.97);
}

</style>
