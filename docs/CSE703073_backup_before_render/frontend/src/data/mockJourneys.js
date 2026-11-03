import hanoiJourneyImage from '../assets/images/journeys/hanoi.jpeg'
import hueJourneyImage from '../assets/images/journeys/hue.jpg'
import hoiAnJourneyImage from '../assets/images/journeys/hoi-an.jpg'

export const mockJourneys = [
  {
    hanh_trinh_id: 1,
    ten_hanh_trinh: 'Hành trình ẩm thực Hà Nội',
    mo_ta: 'Khám phá những món ăn đặc trưng và câu chuyện văn hóa ẩm thực của Hà Nội.',
    thoi_luong: '1 ngày',
    image: hanoiJourneyImage,

    mon_an: [
      {
        mon_an_id: 1,
        ten_mon: 'Phở Hà Nội',
        mo_ta: 'Món ăn truyền thống nổi tiếng của Hà Nội.',
        gia_tham_khao: 50000
      },
      {
        mon_an_id: 2,
        ten_mon: 'Bún chả Hà Nội',
        mo_ta: 'Bún ăn kèm thịt nướng và nước chấm đặc trưng.',
        gia_tham_khao: 60000
      }
    ],

    lich: [
      {
        lich_kha_dung_id: 1,
        ngay_phuc_vu: '2026-10-10',
        so_cho_total: 20,
        so_cho_held: 2,
        so_cho_sold: 5,
        gia_tham_khao: 500000
      },
      {
        lich_kha_dung_id: 2,
        ngay_phuc_vu: '2026-10-17',
        so_cho_total: 20,
        so_cho_held: 1,
        so_cho_sold: 4,
        gia_tham_khao: 500000
      }
    ]
  },

  {
    hanh_trinh_id: 2,
    ten_hanh_trinh: 'Hành trình ẩm thực Huế',
    mo_ta: 'Trải nghiệm những món ăn đặc sắc gắn với văn hóa và lịch sử cố đô Huế.',
    thoi_luong: '2 ngày',
    image: hueJourneyImage,

    mon_an: [
      {
        mon_an_id: 5,
        ten_mon: 'Bún bò Huế',
        mo_ta: 'Món bún cay đặc trưng của cố đô Huế.',
        gia_tham_khao: 55000
      },
      {
        mon_an_id: 11,
        ten_mon: 'Bánh bèo Huế',
        mo_ta: 'Món bánh truyền thống nổi tiếng của Huế.',
        gia_tham_khao: 40000
      }
    ],

    lich: [
      {
        lich_kha_dung_id: 3,
        ngay_phuc_vu: '2026-10-12',
        so_cho_total: 15,
        so_cho_held: 1,
        so_cho_sold: 4,
        gia_tham_khao: 650000
      },
      {
        lich_kha_dung_id: 4,
        ngay_phuc_vu: '2026-10-19',
        so_cho_total: 15,
        so_cho_held: 0,
        so_cho_sold: 8,
        gia_tham_khao: 650000
      }
    ]
  },

  {
    hanh_trinh_id: 3,
    ten_hanh_trinh: 'Hành trình ẩm thực Đà Nẵng - Hội An',
    mo_ta: 'Khám phá những món ăn đặc trưng của miền Trung qua Đà Nẵng và Hội An.',
    thoi_luong: '2 ngày',
    image: hoiAnJourneyImage,

    mon_an: [
      {
        mon_an_id: 6,
        ten_mon: 'Mì Quảng',
        mo_ta: 'Món mì đặc sản của Quảng Nam.',
        gia_tham_khao: 55000
      },
      {
        mon_an_id: 10,
        ten_mon: 'Cao lầu Hội An',
        mo_ta: 'Món mì đặc trưng của phố cổ Hội An.',
        gia_tham_khao: 65000
      }
    ],

    lich: [
      {
        lich_kha_dung_id: 5,
        ngay_phuc_vu: '2026-10-14',
        so_cho_total: 20,
        so_cho_held: 0,
        so_cho_sold: 6,
        gia_tham_khao: 700000
      }
    ]
  }
]