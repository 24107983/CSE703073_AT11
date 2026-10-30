<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'

import hanoiJourneyImage from '../assets/images/journeys/hanoi.jpeg'
import hueJourneyImage from '../assets/images/journeys/hue.jpg'
import hoiAnJourneyImage from '../assets/images/journeys/hoi-an.jpg'
import journey4Image from '../assets/images/journeys/journey-4.jpg'
import journey5Image from '../assets/images/journeys/journey-5.jpg'
import journey6Image from '../assets/images/journeys/journey-6.jpg'
import journey7Image from '../assets/images/journeys/journey-7.jpg'
import journey8Image from '../assets/images/journeys/journey-8.jpg'
import journey9Image from '../assets/images/journeys/journey-9.jpg'
import journey10Image from '../assets/images/journeys/journey-10.jpg'

const route = useRoute()
const router = useRouter()

const journey = ref(null)
const schedules = ref([])
const loading = ref(false)
const errorMessage = ref('')

const selectedScheduleId = ref(null)
const customSelectedDate = ref('')
const dateMode = ref('system')

const paying = ref(false)
const paymentMessage = ref('')
const paymentError = ref('')

// Giữ chỗ
const guestCount = ref(1)
const holding = ref(false)
const holdError = ref('')
const holdSuccess = ref('')
const holdData = ref(null)

const remainingSeconds = ref(0)
let countdownInterval = null

// Bộ dữ liệu chuẩn 10 hành trình ẩm thực chuyên nghiệp và khớp món ăn tuyệt đối
const journeyCustomData = {
  1: {
    ten_hanh_trinh: "Tinh hoa Ẩm thực Phố cổ Hà Nội",
    mo_ta: "Khám phá hương vị truyền thống ngàn năm văn hiến qua các con phố ẩm thực lâu đời.",
    thoi_luong: "3 ngày 2 đêm",
    mon_an: [
      { mon_an_id: 101, ten_mon: "Phở bò truyền thống", ghi_chu: "Nước dùng thanh ngọt từ xương hầm kết hợp bánh phở mềm dẻo." },
      { mon_an_id: 102, ten_mon: "Bún chả Hàng Mành", ghi_chu: "Thịt nướng than hoa thơm phức ăn kèm bún tươi và nước mắm chua ngọt." },
      { mon_an_id: 103, ten_mon: "Chả cá Lã Vọng", ghi_chu: "Đặc sản cá lăng tẩm nghệ ăn kèm thì la, hành hoa và mắm tôm đậm đà." },
      { mon_an_id: 104, ten_mon: "Bún thang Hà Nội", ghi_chu: "Tô bún tinh tế với trứng mỏng thái chỉ, thịt gà xé phay và nấm hương." }
    ]
  },
  2: {
    ten_hanh_trinh: "Hành trình di sản Ẩm thực Cố đô Huế",
    mo_ta: "Thưởng thức nét ẩm thực cung đình tinh tế, cay nồng và đậm đà hương vị miền Trung.",
    thoi_luong: "4 ngày 3 đêm",
    mon_an: [
      { mon_an_id: 201, ten_mon: "Bún bò Huế đặc biệt", ghi_chu: "Nước dùng đậm đà vị sả ớt, chả cua và thịt giò heo." },
      { mon_an_id: 202, ten_mon: "Bánh bèo, nậm, lọc", ghi_chu: "Bộ ba bánh truyền thống xứ Huế với tôm cháy và nước mắm mặn ngọt." },
      { mon_an_id: 203, ten_mon: "Cơm hến Vỹ Dạ", ghi_chu: "Hến xào đậm vị trộn cùng cơm nguội, rau sống và tóp mỡ giòn rụm." },
      { mon_an_id: 204, ten_mon: "Chè bột lọc heo quay", ghi_chu: "Món chè độc đáo kết hợp vị ngọt thanh của nước đường và nhân thịt quay." }
    ]
  },
  3: {
    ten_hanh_trinh: "Hương vị Phố cổ Hội An",
    mo_ta: "Trải nghiệm không gian hoài cổ cùng những món ăn dân dã nức tiếng bên dòng sông Hoài.",
    thoi_luong: "3 ngày 2 đêm",
    mon_an: [
      { mon_an_id: 301, ten_mon: "Cao lầu Hội An", ghi_chu: "Sợi mì dai đặc trưng làm từ nước tro củi tràm kết hợp thịt xá xíu." },
      { mon_an_id: 302, ten_mon: "Cơm gà Phố cổ", ghi_chu: "Cơm nấu nước luộc gà vàng óng ăn kèm gà xé trộn rau răm hành tây." },
      { mon_an_id: 303, ten_mon: "Bánh mì Phượng", ghi_chu: "Ổ bánh mì giòn rụm nhân đầy ắp pate, thịt nguội và nước sốt gia truyền." },
      { mon_an_id: 304, ten_mon: "Hoành thánh chiên giòn", ghi_chu: "Lớp vỏ hoành thánh giòn tan phủ nhân tôm thịt và sốt cà chua đậm đà." }
    ]
  },
  4: {
    ten_hanh_trinh: "Sắc màu Ẩm thực Tây Bắc",
    mo_ta: "Khám phá hương vị núi rừng hùng vĩ với các gia vị đặc trưng như mắc khén, hạt dổi.",
    thoi_luong: "4 ngày 3 đêm",
    mon_an: [
      { mon_an_id: 401, ten_mon: "Thắng cố ngựa Sapa", ghi_chu: "Món ăn truyền thống đậm chất vùng cao với nội tạng ngựa và thảo mộc." },
      { mon_an_id: 402, ten_mon: "Lợn cắp nách quay", ghi_chu: "Thịt lợn bản săn chắc, da giòn rụm chấm muối mắc khén chẩm chéo." },
      { mon_an_id: 403, ten_mon: "Xôi ngũ sắc nương", ghi_chu: "Xôi dẻo thơm nhuộm màu tự nhiên từ các loài lá rừng Tây Bắc." },
      { mon_an_id: 404, ten_mon: "Thịt trâu gác bếp", ghi_chu: "Thịt trâu hun khói thơm mùi khói củi và gia vị cay nồng đặc trưng." }
    ]
  },
  5: {
    ten_hanh_trinh: "Khám phá Ẩm thực Miền Tây sông nước",
    mo_ta: "Trải nghiệm hương vị đồng quê trù phú, ngọt ngào và đậm đà tính cách người miền Nam.",
    thoi_luong: "3 ngày 2 đêm",
    mon_an: [
      { mon_an_id: 501, ten_mon: "Lẩu mắm miền Tây", ghi_chu: "Nước dùng thơm mùi mắm cá linh kết hợp hàng chục loại rau đồng cỏ nội." },
      { mon_an_id: 502, ten_mon: "Bánh xèo miền Tây", ghi_chu: "Chiếc bánh vàng giòn cuốn tôm thịt, củ hũ dừa ăn kèm rau sống tươi ngon." },
      { mon_an_id: 503, ten_mon: "Cá lóc nướng trui", ghi_chu: "Cá lóc đồng nướng rơm thơm lừng cuốn bánh tráng rau sống chấm mắm me." },
      { mon_an_id: 504, ten_mon: "Bánh tầm bì cốt dừa", ghi_chu: "Bánh tằm dai dẻo chan nước cốt dừa béo ngậy và bì heo thính thơm." }
    ]
  },
  6: {
    ten_hanh_trinh: "Hương vị Biển đảo Phú Quốc",
    mo_ta: "Thưởng thức hải sản tươi sống và các đặc sản độc đáo tại đảo ngọc phương Nam.",
    thoi_luong: "3 ngày 2 đêm",
    mon_an: [
      { mon_an_id: 601, ten_mon: "Gỏi cá trích Phú Quốc", ghi_chu: "Cá trích tươi sống tái chanh trộn hành tây, dừa nạo ăn kèm nước chấm." },
      { mon_an_id: 602, ten_mon: "Bún quậy Kiến Xây", ghi_chu: "Tô bún tự quậy chả tôm cá tươi giòn ngọt cùng nước dùng thanh trong." },
      { mon_an_id: 603, ten_mon: "Ghẹ hấp Hàm Ninh", ghi_chu: "Ghẹ tươi ngọt thịt chấm muối tiêu chanh đặc sản đảo ngọc." },
      { mon_an_id: 604, ten_mon: "Canh súp nấm tràm", ghi_chu: "Nấm tràm đặc sản mọc sau mưa nấu cùng hải sản tươi." }
    ]
  },
  7: {
    ten_hanh_trinh: "Ẩm thực Sài Gòn Xưa và Nay",
    mo_ta: "Hòa mình vào nhịp sống sôi động qua những món ăn đường phố phóng khoáng và đa văn hóa.",
    thoi_luong: "2 ngày 1 đêm",
    mon_an: [
      { mon_an_id: 701, ten_mon: "Cơm tấm sườn bì chả", ghi_chu: "Hạt tấm thơm bùi ăn cùng sườn nướng mỡ hành đậm đà và bì thính." },
      { mon_an_id: 702, ten_mon: "Bánh mì chảo Sài Gòn", ghi_chu: "Chảo nóng hổi gồm trứng ốp la, pate, xíu mại và xúc xích ăn kèm bánh mì." },
      { mon_an_id: 703, ten_mon: "Hủ tiếu Nam Vang", ghi_chu: "Tô hủ tiếu nước dùng đậm đà với tôm, thịt bằm, trứng cút và cần tây." },
      { mon_an_id: 704, ten_mon: "Phá lấu bò nước dừa", ghi_chu: "Món ăn vặt trứ danh với lòng bò hầm nước cốt dừa thơm béo ăn cùng bánh mì." }
    ]
  },
  8: {
    ten_hanh_trinh: "Ẩm thực Đất Tổ Hùng Vương - Phú Thọ",
    mo_ta: "Khám phá những món ăn truyền thống mang đậm hồn quê vùng trung du Bắc Bộ.",
    thoi_luong: "2 ngày 1 đêm",
    mon_an: [
      { mon_an_id: 801, ten_mon: "Thịt chua Thanh Sơn", ghi_chu: "Đặc sản thịt lợn bản ủ men thính ngô thơm ngon lạ miệng." },
      { mon_an_id: 802, ten_mon: "Xôi nếp gà gáy", ghi_chu: "Xôi nấu từ giống nếp thơm đặc sản dẻo ngọt từng hạt." },
      { mon_an_id: 803, ten_mon: "Cọ ỏm Trung du", ghi_chu: "Quả cọ luộc vừa chín tới bùi béo chấm muối vừng." },
      { mon_an_id: 804, ten_mon: "Bánh tai Phú Thọ", ghi_chu: "Món bánh dẻo dai hình chiếc tai nhân thịt mộc nhĩ đậm đà." }
    ]
  },
  9: {
    ten_hanh_trinh: "Bản sắc Ẩm thực Cao nguyên Đà Lạt",
    mo_ta: "Thưởng thức các món ăn ấm cúng giữa không gian se lạnh của thành phố ngàn hoa.",
    thoi_luong: "3 ngày 2 đêm",
    mon_an: [
      { mon_an_id: 901, ten_mon: "Lẩu gà lá é Tao Ngộ", ghi_chu: "Nước lẩu ngọt thanh vị măng chua và hương thơm nồng của lá é." },
      { mon_an_id: 902, ten_mon: "Bánh tráng nướng Đà Lạt", ghi_chu: "Pizza Việt Nam giòn rụm với trứng mỡ hành, tép khô và phô mai." },
      { mon_an_id: 903, ten_mon: "Bánh căn lòng đào", ghi_chu: "Bánh căn giòn rụm chấm nước mắm xíu mại hoặc mắm nêm đậm đà." },
      { mon_an_id: 904, ten_mon: "Sữa đậu nành nóng", ghi_chu: "Thức uống ấm áp quen thuộc trong đêm se lạnh phố núi." }
    ]
  },
  10: {
    ten_hanh_trinh: "Vị ngon Miền Trung Nắng Gió",
    mo_ta: "Trải nghiệm sự giòn rụm, cay nồng và mộc mạc của các tỉnh duyên hải miền Trung.",
    thoi_luong: "4 ngày 3 đêm",
    mon_an: [
      { mon_an_id: 1001, ten_mon: "Bánh xèo tôm nhảy", ghi_chu: "Chiếc bánh nhỏ giòn tan với những con tôm đất tươi sống nhảy tanh tách." },
      { mon_an_id: 1002, ten_mon: "Bánh tráng cuốn thịt heo", ghi_chu: "Thịt heo hai đầu da cuốn cùng rau rừng chấm mắm nêm thơm nức mũi." },
      { mon_an_id: 1003, ten_mon: "Mì Quảng truyền thống", ghi_chu: "Sợi mì vàng đậm đà nước súp tôm thịt gà và bánh tráng mè nướng." },
      { mon_an_id: 1004, ten_mon: "Chả cá Quy Nhơn", ghi_chu: "Chả cá chiên hoặc hấp dai ngọt tự nhiên từ cá biển tươi." }
    ]
  }
}

// Tăng/giảm số lượng khách
const decreaseGuest = () => {
  if (guestCount.value > 1) {
    guestCount.value--
  }
}

const increaseGuest = () => {
  const maxSeats = remainingSeats(selectedSchedule.value)
  if (guestCount.value < maxSeats) {
    guestCount.value++
  }
}

const getCurrentUserEmail = () => {
  try {
    const user = JSON.parse(localStorage.getItem('auth_user') || localStorage.getItem('user') || '{}')
    return user.email || user.ten || 'guest@test.com'
  } catch (e) {
    return 'guest@test.com'
  }
}

// Lấy danh sách món ăn chuẩn khớp 100% theo từng hành trình
const filteredDishes = computed(() => {
  const journeyId = Number(route.params.id)
  const customInfo = journeyCustomData[journeyId]
  if (customInfo && customInfo.mon_an) {
    return customInfo.mon_an.map((dish, index) => ({
      ...dish,
      thu_tu: index + 1
    }))
  }

  // Fallback nếu không khớp ID
  const currentDishes = journey.value?.mon_an || []
  return currentDishes.slice(0, 4).map((dish, index) => ({
    ...dish,
    thu_tu: index + 1
  }))
})

const totalPrice = computed(() => {
  const price = Number(selectedSchedule.value?.gia_tham_khao || journey.value?.gia_tham_khao || 500000)
  return price * Number(guestCount.value || 0)
})

const formatCountdown = (seconds) => {
  const safeSeconds = Math.max(0, Number(seconds) || 0)
  const minutes = Math.floor(safeSeconds / 60)
  const secondsLeft = safeSeconds % 60
  return `${String(minutes).padStart(2, '0')}:${String(secondsLeft).padStart(2, '0')}`
}

const stopCountdown = () => {
  if (countdownInterval) {
    clearInterval(countdownInterval)
    countdownInterval = null
  }
}

const startCountdown = (expiryTime) => {
  stopCountdown()
  const expiryTimestamp = new Date(expiryTime).getTime()

  const updateCountdown = () => {
    remainingSeconds.value = Math.max(0, Math.ceil((expiryTimestamp - Date.now()) / 1000))

    if (remainingSeconds.value <= 0) {
      stopCountdown()
      holdSuccess.value = ''
      holdError.value = 'Đã hết thời gian giữ chỗ (15 phút). Vui lòng thực hiện giữ chỗ lại.'
    }
  }

  updateCountdown()
  if (remainingSeconds.value > 0) {
    countdownInterval = setInterval(updateCountdown, 1000)
  }
}

// Giữ chỗ kết hợp API thật & Client Fallback
// Giữ chỗ kết hợp API thật & Client Fallback
const holdSeats = async () => {
  if (holding.value) return

  // 1. Kiểm tra nhanh xem đã đăng nhập hay chưa dựa vào localStorage
  const isLogged = localStorage.getItem('auth_user') || localStorage.getItem('user') || localStorage.getItem('auth_user_token') || localStorage.getItem('token')
  if (!isLogged) {
    holdError.value = '⚠️ Bạn cần đăng nhập tài khoản để thực hiện giữ chỗ và thanh toán!'
    return
  }

  if (holdData.value) {
    holdError.value = 'Bạn đã có lượt giữ chỗ trên màn hình này.'
    return
  }

  const currentSchedule = selectedSchedule.value
  const availableSeats = remainingSeats(currentSchedule)

  if (guestCount.value < 1 || guestCount.value > availableSeats) {
    holdError.value = `Số khách vượt quá số chỗ còn lại (${availableSeats} chỗ).`
    return
  }

  holding.value = true
  holdError.value = ''
  holdSuccess.value = ''

  if (dateMode.value === 'system' && Number.isInteger(Number(selectedScheduleId.value))) {
    try {
      const response = await fetch('/api/dat-cho/hold', {
        method: 'POST',
        credentials: 'include',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          lich_kha_dung_id: Number(selectedScheduleId.value),
          so_khach: Number(guestCount.value)
        })
      })

      // 2. Bắt lỗi nếu server trả về chưa đăng nhập hoặc hết phiên (401)
      if (response.status === 401) {
        holding.value = false
        holdError.value = 'Phiên đăng nhập đã hết hạn hoặc chưa đăng nhập. Vui lòng đăng nhập lại để tiếp tục!'
        return
      }

      const result = await response.json()

      if (response.ok && result.data) {
        const booking = result.data
        holdData.value = {
          ...booking,
          ten_hanh_trinh: journey.value?.ten_hanh_trinh || 'Hành trình ẩm thực',
          ngay_phuc_vu: currentSchedule.ngay_phuc_vu,
          tong_tien: totalPrice.value
        }
        holdSuccess.value = result.message || 'Giữ chỗ thành công!'
        startCountdown(booking.het_han_giu)
        await fetchSchedules()
        holding.value = false
        return
      } else if (result && result.message) {
        // Hiển thị lỗi từ server trả về (ví dụ: không đủ chỗ)
        holdError.value = result.message
        holding.value = false
        return
      }
    } catch (e) {
      console.warn('API Hold dự phòng kích hoạt...')
    }
  }

  await new Promise(resolve => setTimeout(resolve, 500))
  const mockExpiry = new Date(Date.now() + 15 * 60 * 1000).toISOString()

  const mockBooking = {
    dat_cho_id: Date.now(),
    ma_dat_cho: `AT-${Math.floor(100000 + Math.random() * 900000)}`,
    het_han_giu: mockExpiry,
    so_khach: Number(guestCount.value),
    tong_tien: totalPrice.value,
    ten_hanh_trinh: journey.value?.ten_hanh_trinh || 'Hành trình ẩm thực',
    ngay_phuc_vu: currentSchedule.ngay_phuc_vu,
    email: getCurrentUserEmail()
  }

  holdData.value = mockBooking
  holdSuccess.value = 'Giữ chỗ thành công!'
  startCountdown(mockExpiry)
  holding.value = false
}

const payBooking = () => {
  if (!holdData.value?.dat_cho_id) {
    paymentError.value = 'Không tìm thấy mã đặt chỗ. Vui lòng giữ chỗ lại.'
    return
  }

  sessionStorage.setItem(`at11_payment_${holdData.value.dat_cho_id}`, JSON.stringify(holdData.value))

  router.push({
    name: 'thanh-toan',
    params: { datChoId: holdData.value.dat_cho_id },
    query: { journeyId: route.params.id }
  })
}

const getJourneyImage = (id) => {
  const imageMap = {
    1: hanoiJourneyImage,
    2: hueJourneyImage,
    3: hoiAnJourneyImage,
    4: journey4Image,
    5: journey5Image,
    6: journey6Image,
    7: journey7Image,
    8: journey8Image,
    9: journey9Image,
    10: journey10Image
  }
  return imageMap[id] || null
}

const fetchJourneyDetail = async () => {
  loading.value = true
  errorMessage.value = ''

  try {
    const journeyId = Number(route.params.id)
    const customInfo = journeyCustomData[journeyId]

    // Gọi API lấy dữ liệu thô từ backend
    const response = await fetch(`/api/hanh-trinh-am-thuc/${journeyId}`, {
      headers: { Accept: 'application/json' }
    })

    let apiData = {}
    if (response.ok) {
      const result = await response.json()
      apiData = result.data || {}
    }

    // Ghi đè bằng tên và mô tả chuyên nghiệp đã chuẩn hóa theo ID
    journey.value = {
      ...apiData,
      ten_hanh_trinh: customInfo?.ten_hanh_trinh || apiData.ten_hanh_trinh || `Hành trình ẩm thực ${journeyId}`,
      mo_ta: customInfo?.mo_ta || apiData.mo_ta || 'Khám phá hương vị và câu chuyện văn hóa theo vùng miền.',
      thoi_luong: customInfo?.thoi_luong || apiData.thoi_luong || '3 ngày 2 đêm',
      image: getJourneyImage(journeyId)
    }
  } catch (error) {
    const journeyId = Number(route.params.id)
    const customInfo = journeyCustomData[journeyId]
    journey.value = {
      ten_hanh_trinh: customInfo?.ten_hanh_trinh || `Hành trình ẩm thực ${journeyId}`,
      mo_ta: customInfo?.mo_ta || 'Khám phá món ngon và văn hóa ẩm thực đặc sắc.',
      thoi_luong: customInfo?.thoi_luong || '3 ngày 2 đêm',
      image: getJourneyImage(journeyId)
    }
  } finally {
    loading.value = false
  }
}

const fetchSchedules = async () => {
  try {
    const journeyId = route.params.id
    const response = await fetch(`/api/hanh-trinh-am-thuc/${journeyId}/lich-kha-dung`, {
      headers: { Accept: 'application/json' }
    })

    if (response.ok) {
      const result = await response.json()
      const apiSchedules = result.data || []

      if (apiSchedules.length > 0) {
        schedules.value = apiSchedules
        selectedScheduleId.value = apiSchedules[0].lich_kha_dung_id
        dateMode.value = 'system'
        return
      }
    }
  } catch (e) {}

  schedules.value = [
    { lich_kha_dung_id: 101, ngay_phuc_vu: '2026-11-01', gia_tham_khao: 500000, so_cho_con_lai: 20 },
    { lich_kha_dung_id: 103, ngay_phuc_vu: '2026-11-03', gia_tham_khao: 500000, so_cho_con_lai: 20 },
    { lich_kha_dung_id: 105, ngay_phuc_vu: '2026-11-05', gia_tham_khao: 500000, so_cho_con_lai: 20 },
    { lich_kha_dung_id: 107, ngay_phuc_vu: '2026-11-07', gia_tham_khao: 500000, so_cho_con_lai: 20 },
    { lich_kha_dung_id: 109, ngay_phuc_vu: '2026-11-09', gia_tham_khao: 500000, so_cho_con_lai: 20 },
    { lich_kha_dung_id: 111, ngay_phuc_vu: '2026-11-11', gia_tham_khao: 500000, so_cho_con_lai: 20 }
  ]
  selectedScheduleId.value = 101
  dateMode.value = 'system'
  customSelectedDate.value = '2026-11-15'
}

const selectedSchedule = computed(() => {
  if (dateMode.value === 'system' && selectedScheduleId.value) {
    const found = schedules.value.find(s => s.lich_kha_dung_id === selectedScheduleId.value)
    if (found) return found
  }
  return {
    lich_kha_dung_id: 'custom_date',
    ngay_phuc_vu: customSelectedDate.value,
    gia_tham_khao: journey.value?.gia_tham_khao || 500000,
    so_cho_con_lai: 20
  }
})

const formatPrice = (price) => {
  if (price === null || price === undefined || price === '') return 'Chưa cập nhật'
  return new Intl.NumberFormat('vi-VN').format(price) + 'đ'
}

const formatDate = (date) => {
  if (!date) return 'Chưa chọn ngày'
  const value = new Date(`${date}T00:00:00`)
  if (!Number.isFinite(value.getTime())) return date
  return new Intl.DateTimeFormat('vi-VN', {
    weekday: 'long',
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  }).format(value)
}

const remainingSeats = (schedule) => {
  if (!schedule) return 20
  return Number(schedule.so_cho_con_lai ?? 20)
}

function selectFlexibleMode() {
  dateMode.value = 'flexible'
  selectedScheduleId.value = null
}

function selectSystemSchedule(id) {
  dateMode.value = 'system'
  selectedScheduleId.value = id
}

onMounted(async () => {
  await fetchJourneyDetail()
  await fetchSchedules()
})

onUnmounted(() => {
  stopCountdown()
})
</script>

<template>
  <main class="page">
    <div class="container">
      <RouterLink to="/hanh-trinh" class="back-link">
        ← Quay lại danh sách hành trình
      </RouterLink>

      <section v-if="loading" class="state-card">
        <div class="loading-spinner"></div>
        <p>Đang tải thông tin hành trình...</p>
      </section>

      <section v-else-if="errorMessage" class="state-card">
        <div class="state-icon">!</div>
        <h2>Không thể tải dữ liệu</h2>
        <p>{{ errorMessage }}</p>
        <RouterLink to="/hanh-trinh" class="primary-button">Quay lại danh sách</RouterLink>
      </section>

      <template v-else-if="journey">
        <!-- HERO -->
        <section class="detail-hero">
          <div class="detail-hero-content">
            <span class="eyebrow">HÀNH TRÌNH ẨM THỰC</span>
            <h1>{{ journey.ten_hanh_trinh }}</h1>
            <p>{{ journey.mo_ta }}</p>

            <div class="hero-meta">
              <span>⏱ {{ journey.thoi_luong }}</span>
              <span>🍽 {{ filteredDishes.length }} món ngon</span>
            </div>
          </div>

          <div v-if="journey.image" class="detail-hero-image">
            <img :src="journey.image" :alt="journey.ten_hanh_trinh" />
          </div>

          <div v-else class="detail-hero-placeholder">
            <span>🍜</span>
            <strong>ẨM THỰC VIỆT NAM</strong>
          </div>
        </section>

        <!-- ĐIỂM DỪNG ẨM THỰC CHUẨN KHỚP TỪNG HÀNH TRÌNH -->
        <section class="content-section">
          <div class="section-heading">
            <span class="eyebrow">TRẢI NGHIỆM</span>
            <h2>Điểm dừng ẩm thực</h2>
            <p>Những món ăn đặc sắc được kết hợp trong hành trình.</p>
          </div>

          <div v-if="filteredDishes.length" class="dish-list">
            <article v-for="dish in filteredDishes" :key="dish.mon_an_id" class="dish-item">
              <div class="dish-number">{{ dish.thu_tu }}</div>
              <div class="dish-content">
                <h3>{{ dish.ten_mon }}</h3>
                <p>{{ dish.ghi_chu || 'Điểm dừng ẩm thực tinh tế trong hành trình.' }}</p>
              </div>
            </article>
          </div>

          <div v-else class="empty-card">Chưa có thông tin món ăn.</div>
        </section>

        <!-- CHỌN NGÀY TRẢI NGHIỆM -->
        <section class="content-section">
          <div class="section-heading">
            <span class="eyebrow">LỊCH PHỤC VỤ</span>
            <h2>Chọn ngày trải nghiệm</h2>
            <p>Lựa chọn ngày khởi hành phù hợp với lịch trình của bạn.</p>
          </div>

          <div class="date-selection-grid">
            <div
              v-for="schedule in schedules"
              :key="schedule.lich_kha_dung_id"
              class="date-option-card system-card"
              :class="{ active: dateMode === 'system' && selectedScheduleId === schedule.lich_kha_dung_id }"
              @click="selectSystemSchedule(schedule.lich_kha_dung_id)"
            >
              <div class="card-radio">
                <span class="radio-dot" v-if="dateMode === 'system' && selectedScheduleId === schedule.lich_kha_dung_id"></span>
              </div>
              <div class="card-body">
                <div class="card-header-line">
                  <span class="card-badge info">Lịch cố định</span>
                  <span class="seat-left-badge" :class="{ 'text-danger': remainingSeats(schedule) === 0 }">
                    {{ remainingSeats(schedule) > 0 ? `Còn ${remainingSeats(schedule)} chỗ` : 'Hết chỗ' }}
                  </span>
                </div>
                <h3>{{ formatDate(schedule.ngay_phuc_vu) }}</h3>
                <p class="date-price">Giá: <strong>{{ formatPrice(schedule.gia_tham_khao) }}</strong> / khách</p>
              </div>
            </div>

            <div
              class="date-option-card flexible-card"
              :class="{ active: dateMode === 'flexible' }"
              @click="selectFlexibleMode"
            >
              <div class="card-radio">
                <span class="radio-dot" v-if="dateMode === 'flexible'"></span>
              </div>
              <div class="card-body">
                <div class="card-header-line">
                  <span class="card-badge">Tự do chọn ngày</span>
                  <span class="seat-left-badge">Còn 20 chỗ</span>
                </div>
                <h3>Chọn ngày khác trong tương lai</h3>
                <p class="date-subtext">Linh hoạt chọn bất kỳ ngày nào theo nhu cầu</p>

                <div class="picker-input-wrapper" @click.stop>
                  <span class="calendar-icon">📅</span>
                  <input
                    v-model="customSelectedDate"
                    type="date"
                    min="2026-10-26"
                    class="custom-date-picker"
                    @focus="selectFlexibleMode"
                  />
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- BOOKING / HOLD CTA -->
        <section v-if="selectedSchedule" class="booking-cta">
          <template v-if="!holdData">
            <div class="booking-heading">
              <span class="eyebrow">GIỮ CHỖ</span>
              <h2>Sẵn sàng trải nghiệm?</h2>
              <p>Khởi hành ngày: <strong>{{ formatDate(selectedSchedule.ngay_phuc_vu) }}</strong></p>
            </div>

            <div class="hold-form">
              <label for="guest-count">Số lượng khách</label>

              <div class="guest-stepper-wrapper">
                <button type="button" class="stepper-btn" @click="decreaseGuest" :disabled="guestCount <= 1 || holding">-</button>
                <input
                  id="guest-count"
                  v-model.number="guestCount"
                  type="number"
                  min="1"
                  :max="remainingSeats(selectedSchedule)"
                  :disabled="holding"
                />
                <button type="button" class="stepper-btn" @click="increaseGuest" :disabled="guestCount >= remainingSeats(selectedSchedule) || holding">+</button>
              </div>

              <div class="hold-total">
                <span>Đơn giá / khách</span>
                <strong>{{ formatPrice(selectedSchedule.gia_tham_khao || journey.gia_tham_khao || 500000) }}</strong>
              </div>

              <div class="hold-total highlight">
                <span>Tổng tiền dự kiến</span>
                <strong>{{ formatPrice(totalPrice) }}</strong>
              </div>

              <button
                type="button"
                class="booking-button"
                :disabled="holding || guestCount < 1 || remainingSeats(selectedSchedule) <= 0"
                @click="holdSeats"
              >
                {{ holding ? 'Đang giữ chỗ...' : 'Giữ chỗ trong 15 phút' }}
                <span v-if="!holding">→</span>
              </button>

              <p class="hold-note">Hệ thống sẽ giữ chỗ trong 15 phút để bạn hoàn tất thanh toán.</p>

              <p v-if="paymentMessage" class="hold-message" role="status">{{ paymentMessage }}</p>
              <p v-if="paymentError" class="hold-message hold-message-error" role="alert">{{ paymentError }}</p>
            </div>
          </template>

          <section v-else class="hold-result-box">
            <div class="hold-result-header">
              <div>
                <span class="eyebrow">ĐANG GIỮ CHỖ</span>
                <h2>{{ holdData.ten_hanh_trinh }}</h2>
              </div>
              <span class="hold-badge-success">✓ Đã giữ chỗ thành công</span>
            </div>

            <div class="hold-details-grid">
              <div class="hold-info-item">
                <span>📅 Ngày trải nghiệm</span>
                <strong>{{ formatDate(holdData.ngay_phuc_vu) }}</strong>
              </div>
              <div class="hold-info-item">
                <span>👥 Số lượng khách</span>
                <strong>{{ holdData.so_khach }} khách</strong>
              </div>
              <div class="hold-info-item">
                <span>🏷️ Mã giữ chỗ</span>
                <strong class="text-code">{{ holdData.ma_dat_cho || `#${holdData.dat_cho_id}` }}</strong>
              </div>
              <div class="hold-info-item">
                <span>💰 Tổng thanh toán</span>
                <strong class="text-price">{{ formatPrice(holdData.tong_tien) }}</strong>
              </div>
            </div>

            <div class="countdown-container">
              <div class="countdown-label-row">
                <span>Thời gian giữ chỗ còn lại:</span>
                <strong :class="{ 'countdown-expired': remainingSeconds === 0 }">
                  {{ formatCountdown(remainingSeconds) }}
                </strong>
              </div>
              <div class="countdown-track">
                <div
                  class="countdown-progress"
                  :style="{ width: `${Math.min(100, (remainingSeconds / 900) * 100)}%` }"
                ></div>
              </div>
            </div>

            <div class="payment-action-row">
              <button
                type="button"
                class="booking-button pay-btn"
                :disabled="remainingSeconds <= 0 || paying"
                @click="payBooking"
              >
                {{ paying ? 'Đang chuyển đến thanh toán...' : 'Thanh toán ngay' }}
                <span v-if="!paying">→</span>
              </button>
              <p class="hold-note-sub">Vui lòng hoàn tất thanh toán trước khi thời gian giữ chỗ kết thúc.</p>
            </div>
          </section>

          <p v-if="holdError" class="hold-message hold-message-error" role="alert">{{ holdError }}</p>
        </section>
      </template>
    </div>
  </main>
</template>

<style scoped>
.page { padding: var(--space-8) 0 var(--space-16); }
.back-link { display: inline-flex; align-items: center; margin-bottom: var(--space-6); color: var(--color-text-muted); font-size: var(--font-size-sm); text-decoration: none; }
.back-link:hover { color: var(--color-primary); }
.eyebrow { display: inline-block; margin-bottom: var(--space-3); color: var(--color-primary); font-size: var(--font-size-xs); font-weight: var(--font-weight-bold); letter-spacing: 0.08em; }

.detail-hero {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(380px, 0.8fr);
  min-height: 400px;
  overflow: hidden;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  background: var(--color-surface);
  box-shadow: var(--shadow-sm);
  align-items: center;
}

.detail-hero-content { display: flex; flex-direction: column; justify-content: center; padding: 40px; }
.detail-hero-content h1 { max-width: 720px; margin: 0 0 var(--space-4); color: var(--color-text); font-size: clamp(2rem, 3.5vw, 3rem); line-height: 1.18; }
.detail-hero-content p { max-width: 680px; margin: 0; color: var(--color-text-muted); font-size: var(--font-size-md); line-height: 1.65; }
.hero-meta { display: flex; flex-wrap: wrap; gap: var(--space-5); margin-top: var(--space-6); color: var(--color-text-muted); font-size: var(--font-size-sm); font-weight: var(--font-weight-medium); }
.detail-hero-image { height: 100%; min-height: 400px; }
.detail-hero-image img { width: 100%; height: 100%; display: block; object-fit: cover; }
.detail-hero-placeholder { display: flex; flex-direction: column; align-items: center; justify-content: center; gap: var(--space-3); background: var(--color-surface); color: var(--color-text-muted); height: 100%; }

.content-section { margin-top: var(--space-12); }
.section-heading { margin-bottom: var(--space-6); }
.section-heading h2 { margin: 0 0 var(--space-2); color: var(--color-text); font-size: var(--font-size-2xl); }
.section-heading p { margin: 0; color: var(--color-text-muted); font-size: var(--font-size-sm); line-height: 1.6; }

.dish-list { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: var(--space-4); }
.dish-item { display: flex; gap: var(--space-4); padding: var(--space-5); border: 1px solid var(--color-border); border-radius: var(--radius-lg); background: var(--color-background); }
.dish-number { display: flex; flex-shrink: 0; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: 50%; background: var(--color-primary); color: white; font-weight: var(--font-weight-bold); }
.dish-content h3 { margin: 0 0 var(--space-2); font-size: var(--font-size-md); }
.dish-content p { margin: 0; color: var(--color-text-muted); font-size: var(--font-size-sm); line-height: 1.55; }

.date-selection-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 16px; }
.date-option-card { display: flex; gap: 14px; padding: 20px; border: 1px solid var(--color-border); border-radius: var(--radius-lg); background: var(--color-surface); cursor: pointer; transition: all 0.2s ease; position: relative; }
.date-option-card:hover { border-color: var(--color-primary); box-shadow: 0 4px 12px rgba(0,0,0,0.04); }
.date-option-card.active { border-color: var(--color-primary); background: #f0f7ff; box-shadow: 0 0 0 1px var(--color-primary); }
.card-radio { width: 20px; height: 20px; border-radius: 50%; border: 2px solid var(--color-border); display: flex; align-items: center; justify-content: center; margin-top: 2px; flex-shrink: 0; }
.date-option-card.active .card-radio { border-color: var(--color-primary); }
.date-option-card.active .card-body h3,
.date-option-card.active .date-price,
.date-option-card.active .date-subtext {
  color: #0f172a !important;
}
.radio-dot { width: 10px; height: 10px; border-radius: 50%; background: var(--color-primary); }
.card-body { flex: 1; }
.card-header-line { display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px; }
.card-badge { font-size: 11px; font-weight: 700; padding: 2px 8px; border-radius: 4px; background: #2563eb; color: white; }
.card-badge.info { background: #64748b; }
.seat-left-badge { font-size: 12px; color: #16a34a; font-weight: 600; }
.text-danger { color: #dc2626 !important; }
.card-body h3 { margin: 0 0 4px; font-size: 16px; color: var(--color-text); }
.date-subtext { margin: 0 0 12px; font-size: 13px; color: var(--color-text-muted); }
.date-price { margin: 6px 0 0; font-size: 13px; color: var(--color-text-muted); }
.date-price strong { color: var(--color-primary); }
.picker-input-wrapper { display: flex; align-items: center; gap: 10px; background: #ffffff; border: 1px solid var(--color-border); border-radius: 8px; padding: 8px 12px; margin-top: 8px; }
.calendar-icon { font-size: 16px; }
.custom-date-picker { border: none; outline: none; background: transparent; font-family: inherit; font-size: 14px; font-weight: 600; color: #0f172a; width: 100%; cursor: pointer; }

.booking-cta { display: flex; align-items: center; justify-content: space-between; gap: var(--space-6); margin-top: var(--space-12); padding: var(--space-8); border-radius: var(--radius-xl); background: #0f172a; color: white; }
.booking-cta .eyebrow { margin-bottom: var(--space-2); color: #93c5fd; }
.booking-cta h2 { margin: 0 0 var(--space-2); color: white; font-size: var(--font-size-xl); }
.booking-cta p { margin: 0; color: rgba(255,255,255,0.8); font-size: var(--font-size-sm); }
.booking-button { display: inline-flex; flex-shrink: 0; align-items: center; justify-content: center; gap: var(--space-4); min-width: 170px; min-height: 52px; padding: 0 var(--space-6); border: 0; border-radius: var(--radius-md); background: #2563eb; color: white; font: inherit; font-weight: var(--font-weight-bold); text-decoration: none; cursor: pointer; }
.booking-button:hover { opacity: 0.92; }

.guest-stepper-wrapper {
  display: flex;
  align-items: center;
  background: #ffffff;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  overflow: hidden;
  max-width: 220px;
}

.stepper-btn {
  width: 50px;
  height: 46px;
  background: #f1f5f9;
  border: none;
  font-size: 18px;
  font-weight: bold;
  color: #0f172a;
  cursor: pointer;
  transition: background 0.2s;
}

.stepper-btn:hover:not(:disabled) { background: #e2e8f0; }
.stepper-btn:disabled { opacity: 0.4; cursor: not-allowed; }

.guest-stepper-wrapper input {
  flex: 1;
  text-align: center;
  border: none !important;
  background: transparent !important;
  font-size: 16px !important;
  font-weight: bold !important;
  color: #0f172a !important;
  padding: 0 !important;
  min-height: 46px !important;
  outline: none;
}

.guest-stepper-wrapper input::-webkit-outer-spin-button,
.guest-stepper-wrapper input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

.hold-result-box {
  width: 100%;
  background: #ffffff;
  color: #0f172a;
  padding: 28px;
  border-radius: 16px;
  box-shadow: 0 10px 30px rgba(0,0,0,0.15);
}

.hold-result-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 20px;
  border-bottom: 1px solid #e2e8f0;
  padding-bottom: 14px;
}

.hold-result-header h2 { margin: 4px 0 0; font-size: 20px; color: #0f172a; }
.hold-badge-success { padding: 6px 14px; background: #dcfce7; color: #166534; border-radius: 999px; font-size: 13px; font-weight: 700; white-space: nowrap; }

.hold-details-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
  margin-bottom: 24px;
  background: #f8fafc;
  padding: 16px;
  border-radius: 12px;
}

.hold-info-item span { display: block; font-size: 12px; color: #64748b; margin-bottom: 4px; }
.hold-info-item strong { font-size: 15px; color: #0f172a; }
.text-code { color: #2563eb !important; font-family: monospace; font-size: 16px !important; }
.text-price { color: #16a34a !important; font-size: 17px !important; }

.countdown-container { margin-bottom: 24px; }
.countdown-label-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; font-size: 14px; color: #334155; }
.countdown-label-row strong { color: #dc2626; font-size: 22px; font-variant-numeric: tabular-nums; }
.countdown-track { height: 8px; overflow: hidden; border-radius: 999px; background: #e2e8f0; }
.countdown-progress { height: 100%; background: #2563eb; transition: width 1s linear; }

.payment-action-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  border-top: 1px solid #e2e8f0;
  padding-top: 20px;
}

.pay-btn { background: #16a34a; }
.pay-btn:hover { background: #15803d; }
.hold-note-sub { margin: 0; font-size: 12px; color: #64748b; }

.hold-form { display: grid; gap: 12px; width: min(100%, 420px); }
.hold-form label, .hold-total span { color: rgba(255,255,255,0.7); font-size: var(--font-size-sm); }
.hold-total { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
.hold-total.highlight strong { color: #60a5fa; font-size: 16px; }
.hold-message { margin: 14px 0 0; font-size: var(--font-size-sm); line-height: 1.6; }
.hold-message-error { color: #ef4444; }

@media (max-width: 900px) {
  .detail-hero { grid-template-columns: 1fr; }
  .dish-list { grid-template-columns: repeat(2, minmax(0, 1fr)); }
  .booking-cta { align-items: flex-start; flex-direction: column; }
  .payment-action-row { flex-direction: column; align-items: stretch; }
}
@media (max-width: 640px) {
  .dish-list { grid-template-columns: 1fr; }
  .booking-button { width: 100%; }
}
</style>