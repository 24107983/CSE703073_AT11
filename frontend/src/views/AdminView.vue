<script setup>
import { nextTick, onBeforeUnmount, onMounted, ref } from 'vue'
import axios from 'axios'
import {
  Chart,
  DoughnutController,
  BarController,
  ArcElement,
  BarElement,
  CategoryScale,
  LinearScale,
  Tooltip,
  Legend
} from 'chart.js'

Chart.register(
  DoughnutController,
  BarController,
  ArcElement,
  BarElement,
  CategoryScale,
  LinearScale,
  Tooltip,
  Legend
)

const loading = ref(true)
const errorMessage = ref('')

const summary = ref({
  total_bookings: 0,
  confirmed_bookings: 0,
  cancelled_bookings: 0,
  total_revenue: 0
})

const bookingStatus = ref([])
const revenueByDate = ref([])
const bookingsList = ref([]) // Bổ sung mảng chứa danh sách đơn đặt chỗ thực tế từ API

const statusChartCanvas = ref(null)
const revenueChartCanvas = ref(null)

let statusChart = null
let revenueChart = null

const formatCurrency = (value) => {
  return new Intl.NumberFormat('vi-VN').format(Number(value || 0)) + 'đ'
}

const formatDate = (value) => {
  if (!value) return ''
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return value
  return new Intl.DateTimeFormat('vi-VN').format(date)
}

const getStatusLabel = (status) => {
  const labels = {
    draft: 'Nháp',
    pending_payment: 'Chờ thanh toán',
    confirmed: 'Đã xác nhận',
    cancelled: 'Đã hủy',
    expired: 'Hết hạn',
    refunded: 'Đã hoàn tiền',
    completed: 'Hoàn thành'
  }
  return labels[status] || status
}

const fetchDashboard = async () => {
  loading.value = true
  errorMessage.value = ''

  try {
    const response = await axios.get(
      '/api/admin/dashboard/stats',
      {
        withCredentials: true,
        headers: { Accept: 'application/json' }
      }
    )

    const result = response.data

    summary.value = result.data.summary || {}
    bookingStatus.value = result.data.booking_status || []
    revenueByDate.value = result.data.revenue_by_date || []
    bookingsList.value = result.data.recent_bookings || result.data.bookings || []

    loading.value = false

    await nextTick()

    createStatusChart()
    createRevenueChart()
  } catch (error) {
    console.error(error)
    if (error.response) {
      errorMessage.value =
        error.response.data?.message ||
        `Không thể tải dashboard. HTTP ${error.response.status}`
    } else {
      errorMessage.value = 'Không thể kết nối đến máy chủ.'
    }
    loading.value = false
  }
}

// XỬ LÝ XUẤT FILE EXCEL / CSV THỰC TẾ TỪ DỮ LIỆU API
const exportToExcel = () => {
  if (loading.value) return

  // Chuẩn bị dữ liệu từ API
  const rows = [
    ['BÁO CÁO THỐNG KÊ DASHBOARD AT-11'],
    [`Ngày xuất: ${new Date().toLocaleDateString('vi-VN')}`],
    [''],
    ['--- TỔNG QUAN KPI ---'],
    ['Tổng đơn đặt chỗ', summary.value.total_bookings || 0],
    ['Đơn đã xác nhận', summary.value.confirmed_bookings || 0],
    ['Đơn đã hủy', summary.value.cancelled_bookings || 0],
    ['Tổng doanh thu (VNĐ)', summary.value.total_revenue || 0],
    [''],
    ['--- TRẠNG THÁI ĐƠN ĐẶT CHỖ ---'],
    ['Trạng thái', 'Số lượng']
  ]

  bookingStatus.value.forEach(item => {
    rows.push([getStatusLabel(item.trang_thai), item.so_luong])
  })

  rows.push([''])
  rows.push(['--- DOANH THU THEO NGÀY ---'])
  rows.push(['Ngày', 'Doanh thu (VNĐ)'])

  revenueByDate.value.forEach(item => {
    rows.push([formatDate(item.ngay), item.doanh_thu])
  })

  if (bookingsList.value.length > 0) {
    rows.push([''])
    rows.push(['--- DANH SÁCH ĐƠN ĐẶT CHỖ ---'])
    rows.push(['Mã đơn', 'Khách hàng', 'Số điện thoại', 'Hành trình', 'Ngày đặt', 'Tổng tiền', 'Trạng thái'])
    
    bookingsList.value.forEach(item => {
      rows.push([
        item.id || item.ma_don || '',
        item.customer_name || item.ten_khach_hang || '',
        item.phone || item.so_dien_thoai || '',
        item.journey_name || item.ten_hanh_trinh || '',
        formatDate(item.created_at || item.ngay_dat),
        item.total_price || item.tong_tien || 0,
        getStatusLabel(item.status || item.trang_thai)
      ])
    })
  }

  // Chuyển đổi thành CSV với BOM UTF-8 hỗ trợ tiếng Việt trên Excel
  const csvContent = '\uFEFF' + rows.map(e => e.map(val => `"${val}"`).join(',')).join('\n')
  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.setAttribute('href', url)
  link.setAttribute('download', `Bao_Cao_Dashboard_AT11_${new Date().toISOString().slice(0, 10)}.csv`)
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

const createStatusChart = () => {
  if (!statusChartCanvas.value) return
  if (statusChart) statusChart.destroy()

  statusChart = new Chart(statusChartCanvas.value, {
    type: 'doughnut',
    data: {
      labels: bookingStatus.value.map(item => getStatusLabel(item.trang_thai)),
      datasets: [
        {
          data: bookingStatus.value.map(item => Number(item.so_luong)),
          backgroundColor: [
            '#F59E0B', // Chờ thanh toán
            '#16A34A', // Đã xác nhận
            '#EF4444', // Đã hủy
            '#64748B', // Hết hạn
            '#8B5CF6'  // Đã hoàn tiền
          ],
          borderColor: '#FFFFFF',
          borderWidth: 3,
          hoverOffset: 8
        }
      ]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { position: 'bottom' }
      }
    }
  })
}

const createRevenueChart = () => {
  if (!revenueChartCanvas.value) return
  if (revenueChart) revenueChart.destroy()

  revenueChart = new Chart(revenueChartCanvas.value, {
    type: 'bar',
    data: {
      labels: revenueByDate.value.map(item => formatDate(item.ngay)),
      datasets: [
        {
          label: 'Doanh thu',
          data: revenueByDate.value.map(item => Number(item.doanh_thu)),
          backgroundColor: '#2563EB',
          hoverBackgroundColor: '#1D4ED8',
          borderColor: '#1D4ED8',
          borderWidth: 1,
          borderRadius: 6,
          maxBarThickness: 64
        }
      ]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            callback: value => formatCurrency(value)
          }
        }
      },
      plugins: {
        tooltip: {
          callbacks: {
            label: context => formatCurrency(context.raw)
          }
        },
        legend: { display: false }
      }
    }
  })
}

onMounted(() => {
  fetchDashboard()
})

onBeforeUnmount(() => {
  if (statusChart) statusChart.destroy()
  if (revenueChart) revenueChart.destroy()
})
</script>

<template>
  <main class="dashboard-page">
    <section class="dashboard-header">
      <div>
        <p class="eyebrow">QUẢN TRỊ</p>
        <h1>Dashboard quản trị</h1>
        <p class="dashboard-description">
          Tổng quan tình hình đặt chỗ và doanh thu của hệ thống AT-11.
        </p>
      </div>

      <!-- CỤM NÚT THAO TÁC (LÀM MỚI + XUẤT EXCEL) -->
      <div class="action-buttons">
        <button
          class="export-excel-button"
          type="button"
          :disabled="loading"
          @click="exportToExcel"
        >
          📊 Xuất báo cáo Excel
        </button>

        <button
          class="refresh-button"
          type="button"
          :disabled="loading"
          @click="fetchDashboard"
        >
          {{ loading ? 'Đang tải...' : 'Làm mới dữ liệu' }}
        </button>
      </div>
    </section>

    <section v-if="errorMessage" class="error-box">
      {{ errorMessage }}
    </section>

    <section v-if="loading" class="loading-box">
      Đang tải dữ liệu dashboard...
    </section>

    <template v-else>
      <!-- KPI CARDS -->
      <section class="kpi-grid">
        <article class="kpi-card">
          <span class="kpi-label">Tổng đơn đặt chỗ</span>
          <strong class="kpi-value">{{ summary.total_bookings }}</strong>
        </article>

        <article class="kpi-card">
          <span class="kpi-label">Đơn đã xác nhận</span>
          <strong class="kpi-value success-color">{{ summary.confirmed_bookings }}</strong>
        </article>

        <article class="kpi-card">
          <span class="kpi-label">Đơn đã hủy</span>
          <strong class="kpi-value danger-color">{{ summary.cancelled_bookings }}</strong>
        </article>

        <article class="kpi-card">
          <span class="kpi-label">Tổng doanh thu</span>
          <strong class="kpi-value">{{ formatCurrency(summary.total_revenue) }}</strong>
        </article>
      </section>

      <!-- CHARTS SECTION -->
      <section class="charts-grid">
        <article class="chart-card">
          <div class="chart-header">
            <div>
              <h2>Trạng thái đơn đặt chỗ</h2>
              <p>Phân bố đơn theo trạng thái hiện tại.</p>
            </div>
          </div>
          <div class="chart-container">
            <canvas ref="statusChartCanvas"></canvas>
          </div>
        </article>

        <article class="chart-card">
          <div class="chart-header">
            <div>
              <h2>Doanh thu theo ngày</h2>
              <p>Doanh thu từ đơn đã xác nhận hoặc hoàn thành.</p>
            </div>
          </div>
          <div class="chart-container">
            <canvas ref="revenueChartCanvas"></canvas>
          </div>
        </article>
      </section>

      <!-- BẢNG DANH SÁCH ĐƠN ĐẶT CHỖ TỪ API (NẾU CÓ DỮ LIỆU) -->
      <section v-if="bookingsList.length > 0" class="table-card">
        <div class="table-header">
          <h2>Danh sách đơn đặt chỗ mới nhất</h2>
          <span class="count-badge">{{ bookingsList.length }} đơn</span>
        </div>
        <div class="table-wrapper">
          <table class="real-data-table">
            <thead>
              <tr>
                <th>Mã đơn</th>
                <th>Khách hàng</th>
                <th>Hành trình</th>
                <th>Ngày đặt</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(item, idx) in bookingsList" :key="idx">
                <td class="font-bold">{{ item.id || item.ma_don || `#${idx + 1}` }}</td>
                <td>{{ item.customer_name || item.ten_khach_hang || 'Khách vãng lai' }}</td>
                <td>{{ item.journey_name || item.ten_hanh_trinh || 'Hành trình AT-11' }}</td>
                <td>{{ formatDate(item.created_at || item.ngay_dat) }}</td>
                <td class="font-bold text-blue">{{ formatCurrency(item.total_price || item.tong_tien) }}</td>
                <td>
                  <span class="status-tag" :class="item.status || item.trang_thai">
                    {{ getStatusLabel(item.status || item.trang_thai) }}
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>

    </template>
  </main>
</template>

<style scoped>
.dashboard-page {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 24px 64px;
}

.dashboard-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: 32px;
}

.eyebrow {
  margin: 0 0 8px;
  color: #2563eb;
  font-size: 14px;
  font-weight: 700;
  letter-spacing: 0.08em;
}

.dashboard-header h1 {
  margin: 0;
  color: #111827;
  font-size: 32px;
  line-height: 1.2;
}

.dashboard-description {
  margin: 10px 0 0;
  color: #6b7280;
  font-size: 16px;
}

.action-buttons {
  display: flex;
  gap: 12px;
}

.export-excel-button {
  padding: 11px 18px;
  border: 1px solid #10b981;
  border-radius: 8px;
  background: #10b981;
  color: #ffffff;
  font-size: 14px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s;
}

.export-excel-button:hover {
  background: #059669;
  border-color: #059669;
}

.refresh-button {
  min-width: 140px;
  padding: 11px 16px;
  border: 1px solid #2563eb;
  border-radius: 8px;
  background: #2563eb;
  color: #ffffff;
  font-size: 14px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s;
}

.refresh-button:hover {
  background: #1d4ed8;
}

.refresh-button:disabled,
.export-excel-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.kpi-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 24px;
}

.kpi-card {
  padding: 22px;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  background: #ffffff;
  box-shadow: 0 4px 12px rgba(15, 23, 42, 0.05);
}

.kpi-label {
  display: block;
  margin-bottom: 12px;
  color: #6b7280;
  font-size: 14px;
  font-weight: 500;
}

.kpi-value {
  display: block;
  color: #2563eb;
  font-size: 28px;
  line-height: 1.2;
}

.kpi-value.success-color { color: #16a34a; }
.kpi-value.danger-color { color: #ef4444; }

.charts-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 24px;
  margin-bottom: 32px;
}

.chart-card, .table-card {
  min-width: 0;
  padding: 24px;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  background: #ffffff;
  box-shadow: 0 4px 12px rgba(15, 23, 42, 0.05);
}

.chart-header h2, .table-header h2 {
  margin: 0;
  color: #111827;
  font-size: 20px;
}

.chart-header p {
  margin: 6px 0 0;
  color: #6b7280;
  font-size: 14px;
}

.chart-container {
  position: relative;
  height: 320px;
  margin-top: 24px;
}

/* BẢNG DỮ LIỆU ĐẶT CHỖ */
.table-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 20px;
}

.count-badge {
  background: #eff6ff;
  color: #2563eb;
  font-size: 12px;
  font-weight: 700;
  padding: 2px 10px;
  border-radius: 99px;
}

.table-wrapper {
  overflow-x: auto;
}

.real-data-table {
  width: 100%;
  border-collapse: collapse;
  text-align: left;
  font-size: 14px;
}

.real-data-table th {
  background: #f8fafc;
  color: #475569;
  font-weight: 700;
  padding: 12px 16px;
  border-bottom: 2px solid #e2e8f0;
}

.real-data-table td {
  padding: 14px 16px;
  border-bottom: 1px solid #f1f5f9;
  color: #1e293b;
}

.font-bold { font-weight: 700; }
.text-blue { color: #2563eb; }

.status-tag {
  display: inline-block;
  padding: 4px 10px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 700;
  background: #f3f4f6;
  color: #374151;
}

.status-tag.confirmed { background: #dcfce7; color: #166534; }
.status-tag.pending_payment { background: #ffedd5; color: #9a3412; }
.status-tag.cancelled { background: #fee2e2; color: #991b1b; }

.loading-box,
.error-box {
  padding: 20px;
  border-radius: 10px;
  margin-bottom: 24px;
}

.loading-box {
  background: #f8fafc;
  color: #6b7280;
  text-align: center;
}

.error-box {
  border: 1px solid #fecaca;
  background: #fef2f2;
  color: #dc2626;
}

@media (max-width: 1024px) {
  .kpi-grid { grid-template-columns: repeat(2, 1fr); }
  .charts-grid { grid-template-columns: 1fr; }
}

@media (max-width: 640px) {
  .dashboard-page { padding: 28px 16px 48px; }
  .dashboard-header { align-items: flex-start; flex-direction: column; }
  .action-buttons { width: 100%; flex-direction: column; }
  .refresh-button, .export-excel-button { width: 100%; }
  .kpi-grid { grid-template-columns: 1fr; }
}
</style>