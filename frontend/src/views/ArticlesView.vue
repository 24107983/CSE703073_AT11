<script setup>
import { ref, computed } from 'vue'
import { RouterLink } from 'vue-router'

import hanoiImg from '../assets/images/journeys/hanoi.jpeg'
import hoiAnImg from '../assets/images/journeys/hoi-an.jpg'
import phuQuocImg from '../assets/images/journeys/journey-6.jpg'
import tayBacImg from '../assets/images/journeys/ha-giang.jpg'
const searchQuery = ref('')
const selectedCategory = ref('all')

const categories = [
  { id: 'all', name: 'Tất cả bài viết' },
  { id: 'heritage', name: 'Di sản & Văn hóa' },
  { id: 'guide', name: 'Cẩm nang & Kinh nghiệm' },
  { id: 'field-notes', name: 'Nhật ký trải nghiệm' }
]

const articles = ref([
  {
    id: 1,
    title: 'Phở Hà Nội: Từ gánh hàng rong ven đường đến biểu tượng ẩm thực thế giới',
    excerpt: 'Hành trình hơn một thế kỷ lắng đọng trong tô phở truyền thống - nét tinh hoa văn hóa ngàn năm văn hiến được gìn giữ qua bao thế hệ.',
    category: 'heritage',
    categoryName: 'Di sản & Văn hóa',
    readTime: '6 phút đọc',
    publishedDate: '15/10/2026',
    author: 'Biên tập viên AT-11',
    image: hanoiImg,
    featured: true,
    relatedJourneyId: 1,
    relatedJourneyName: 'Tinh hoa Ẩm thực Phố cổ Hà Nội'
  },
  {
    id: 2,
    title: 'Bí mật đằng sau sợi mì Cao Lầu Hội An: Nước giếng cổ và tro củi tràm xứ Quảng',
    excerpt: 'Tại sao Cao Lầu chỉ chuẩn vị khi được làm từ nước giếng Bá Lễ và tro củi tràm Cù Lao Chàm? Khám phá ẩn số độc bản của ẩm thực xứ Quảng.',
    category: 'heritage',
    categoryName: 'Di sản & Văn hóa',
    readTime: '5 phút đọc',
    publishedDate: '20/10/2026',
    author: 'Góc Biên Tập',
    image: hoiAnImg,
    featured: false,
    relatedJourneyId: 3,
    relatedJourneyName: 'Hương vị Phố cổ Hội An'
  },
  {
    id: 3,
    title: 'Cẩm nang thưởng thức hải sản Phú Quốc: Ăn gì, ở đâu và cách chọn đồ tươi sống',
    excerpt: 'Bỏ túi bí kíp sành ăn khi đến Đảo Ngọc: Cách chọn ghẹ Hàm Ninh, thưởng thức gỏi cá trích tái chanh và ghé thăm những làng chài lâu đời.',
    category: 'guide',
    categoryName: 'Cẩm nang & Kinh nghiệm',
    readTime: '7 phút đọc',
    publishedDate: '24/10/2026',
    author: 'Chuyên gia Du lịch',
    image: phuQuocImg,
    featured: false,
    relatedJourneyId: 6,
    relatedJourneyName: 'Hương vị Biển đảo Phú Quốc'
  },
  {
    id: 4,
    title: 'Nhật ký Tây Bắc: Lạc bước giữa sắc màu văn hóa và ẩm thực vùng cao nguyên đá',
    excerpt: 'Trải nghiệm săn mây đỉnh đèo, khám phá chợ phiên rực rỡ sắc màu và thưởng thức hương vị mắc khén, hạt dổi đậm đà núi rừng Tây Bắc.',
    category: 'field-notes',
    categoryName: 'Nhật ký trải nghiệm',
    readTime: '6 phút đọc',
    publishedDate: '26/10/2026',
    author: 'Linh Đào',
    image: tayBacImg, // Dùng ảnh minh họa núi rừng/hành trình
    featured: false,
    relatedJourneyId: 4, // Trỏ chính xác vào ID hành trình Tây Bắc
    relatedJourneyName: 'Sắc màu Ẩm thực Tây Bắc'
  }
])

const filteredArticles = computed(() => {
  const query = searchQuery.value.trim().toLowerCase()
  return articles.value.filter(article => {
    const matchesCategory = selectedCategory.value === 'all' || article.category === selectedCategory.value
    const matchesSearch = !query ||
      article.title.toLowerCase().includes(query) ||
      article.excerpt.toLowerCase().includes(query) ||
      article.categoryName.toLowerCase().includes(query)
    return matchesCategory && matchesSearch
  })
})

const featuredArticle = computed(() => {
  return articles.value.find(a => a.featured) || articles.value[0]
})
</script>

<template>
  <main class="page">
    <div class="container">

      <!-- HEADING BANNER -->
      <section class="page-heading">
        <span class="eyebrow">GÓC BIÊN TẬP & VĂN HÓA</span>
        <h1>Bài viết ẩm thực</h1>
        <p>Lưu giữ những câu chuyện văn hóa, bí kíp ẩm thực ba miền và cảm hứng trải nghiệm nguyên bản.</p>
      </section>

      <!-- FEATURED HERO ARTICLE -->
      <section v-if="featuredArticle && !searchQuery && selectedCategory === 'all'" class="featured-hero">
        <div class="hero-image-wrap">
          <img :src="featuredArticle.image" :alt="featuredArticle.title" />
          <span class="badge-featured">Bài viết nổi bật</span>
        </div>
        <div class="hero-content">
          <div class="meta-top">
            <span class="cat-tag">{{ featuredArticle.categoryName }}</span>
            <span>•</span>
            <span>⏱ {{ featuredArticle.readTime }}</span>
          </div>
          <h2>{{ featuredArticle.title }}</h2>
          <p>{{ featuredArticle.excerpt }}</p>

          <div class="journey-link-box" v-if="featuredArticle.relatedJourneyId">
            <span>🗺️ Hành trình liên quan:</span>
            <RouterLink :to="`/hanh-trinh/${featuredArticle.relatedJourneyId}`">
              {{ featuredArticle.relatedJourneyName }} →
            </RouterLink>
          </div>

          <div class="hero-footer">
            <span class="author-name">✍️ {{ featuredArticle.author }} • {{ featuredArticle.publishedDate }}</span>
            <RouterLink :to="`/bai-viet/${featuredArticle.id}`" class="read-more-btn">
              Đọc tiếp →
            </RouterLink>
          </div>
        </div>
      </section>

      <!-- SEARCH & CATEGORY FILTERS -->
      <section class="filter-bar">
        <div class="category-tabs">
          <button
            v-for="cat in categories"
            :key="cat.id"
            type="button"
            class="tab-btn"
            :class="{ active: selectedCategory === cat.id }"
            @click="selectedCategory = cat.id"
          >
            {{ cat.name }}
          </button>
        </div>

        <div class="search-box">
          <span class="search-icon">🔍</span>
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Tìm kiếm bài viết, món ăn..."
          />
        </div>
      </section>

      <!-- ARTICLES GRID -->
      <section class="articles-grid">
        <article
          v-for="article in filteredArticles"
          :key="article.id"
          class="article-card"
        >
          <div class="card-media">
            <img :src="article.image" :alt="article.title" />
            <span class="card-cat-badge">{{ article.categoryName }}</span>
          </div>

          <div class="card-body">
            <div class="card-meta">
              <span>{{ article.publishedDate }}</span>
              <span>•</span>
              <span>⏱ {{ article.readTime }}</span>
            </div>

            <h3 class="card-title">
              <RouterLink :to="`/bai-viet/${article.id}`">{{ article.title }}</RouterLink>
            </h3>

            <p class="card-excerpt">{{ article.excerpt }}</p>

            <div v-if="article.relatedJourneyId" class="card-journey-tag">
              <span class="tag-label">Trải nghiệm thực tế:</span>
              <RouterLink :to="`/hanh-trinh/${article.relatedJourneyId}`">
                {{ article.relatedJourneyName }} ↗
              </RouterLink>
            </div>

            <div class="card-footer">
              <span class="author-text">Viết bởi: {{ article.author }}</span>
              <RouterLink :to="`/bai-viet/${article.id}`" class="link-arrow">Đọc chi tiết →</RouterLink>
            </div>
          </div>
        </article>
      </section>

      <!-- EMPTY STATE -->
      <section v-if="filteredArticles.length === 0" class="empty-card">
        <div class="empty-icon">📖</div>
        <h3>Không tìm thấy bài viết phù hợp</h3>
        <p>Thử tìm kiếm với từ khóa khác hoặc chuyển chuyên mục.</p>
      </section>

    </div>
  </main>
</template>

<style scoped>
.page { padding: var(--space-8) 0 var(--space-16); }
.eyebrow { display: inline-block; margin-bottom: var(--space-3); color: var(--color-primary); font-size: var(--font-size-xs); font-weight: var(--font-weight-bold); letter-spacing: 0.08em; }
.page-heading { margin-bottom: var(--space-8); }
.page-heading h1 { margin: 0 0 var(--space-2); font-size: clamp(2rem, 4vw, 2.5rem); color: var(--color-text); }
.page-heading p { color: var(--color-text-muted); font-size: var(--font-size-md); max-width: 680px; margin: 0; }

/* FEATURED HERO */
.featured-hero { display: grid; grid-template-columns: 1.1fr 0.9fr; gap: 24px; background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-xl); overflow: hidden; margin-bottom: var(--space-8); box-shadow: var(--shadow-sm); align-items: center; }
.hero-image-wrap { position: relative; height: 260px; }
.hero-image-wrap img { width: 100%; height: 100%; object-fit: cover; display: block; }
.badge-featured { position: absolute; top: 12px; left: 12px; background: #2563eb; color: #ffffff; font-size: 11px; font-weight: 700; padding: 4px 10px; border-radius: 20px; }

.hero-content { padding: 24px; display: flex; flex-direction: column; justify-content: center; }
.meta-top { display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--color-text-muted); margin-bottom: 8px; }
.cat-tag { color: var(--color-primary); font-weight: 700; }
.hero-content h2 { font-size: 20px; line-height: 1.35; margin: 0 0 10px; color: var(--color-text); }
.hero-content p { color: var(--color-text-muted); font-size: 14px; line-height: 1.5; margin: 0 0 12px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }

.journey-link-box { background: #f0f7ff; border: 1px solid #bfdbfe; border-radius: 6px; padding: 8px 12px; font-size: 12px; margin-bottom: 14px; display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }
.journey-link-box a { color: #1d4ed8; font-weight: 700; text-decoration: none; }
.journey-link-box a:hover { text-decoration: underline; }

.hero-footer { display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-top: auto; padding-top: 10px; border-top: 1px solid var(--color-border); }
.author-name { font-size: 12px; color: var(--color-text-muted); }
.read-more-btn { background: var(--color-primary); color: #ffffff; padding: 6px 14px; border-radius: 6px; text-decoration: none; font-size: 13px; font-weight: 700; }
.read-more-btn:hover { opacity: 0.9; }

/* FILTERS */
.filter-bar { display: flex; justify-content: space-between; align-items: center; gap: 16px; margin-bottom: var(--space-8); flex-wrap: wrap; }
.category-tabs { display: flex; gap: 8px; flex-wrap: wrap; }
.tab-btn { background: var(--color-surface); border: 1px solid var(--color-border); padding: 8px 16px; border-radius: 8px; font-size: 14px; color: var(--color-text-muted); cursor: pointer; transition: all 0.2s; }
.tab-btn.active, .tab-btn:hover { background: var(--color-primary); color: #ffffff; border-color: var(--color-primary); }

.search-box { display: flex; align-items: center; gap: 8px; background: var(--color-surface); border: 1px solid var(--color-border); border-radius: 8px; padding: 8px 14px; min-width: 260px; }
.search-box input { border: none; outline: none; background: transparent; font-size: 14px; color: var(--color-text); width: 100%; }

/* GRID */
.articles-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 24px; }
.article-card { background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-xl); overflow: hidden; display: flex; flex-direction: column; transition: transform 0.2s, box-shadow 0.2s; }
.article-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-md); border-color: var(--color-primary); }

.card-media { position: relative; height: 190px; }
.card-media img { width: 100%; height: 100%; object-fit: cover; display: block; }
.card-cat-badge { position: absolute; bottom: 10px; left: 10px; background: rgba(15, 23, 42, 0.8); color: #ffffff; font-size: 11px; font-weight: 700; padding: 3px 8px; border-radius: 6px; backdrop-filter: blur(4px); }

.card-body { padding: 18px; display: flex; flex-direction: column; flex: 1; }
.card-meta { font-size: 12px; color: var(--color-text-muted); display: flex; gap: 6px; margin-bottom: 6px; }
.card-title { font-size: 16px; line-height: 1.35; margin: 0 0 8px; }
.card-title a { color: var(--color-text); text-decoration: none; }
.card-title a:hover { color: var(--color-primary); }
.card-excerpt { font-size: 13.5px; color: var(--color-text-muted); line-height: 1.5; margin: 0 0 14px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }

.card-journey-tag { background: #f8fafc; border-top: 1px dashed var(--color-border); padding: 8px 0; margin-top: auto; font-size: 12px; display: flex; gap: 6px; flex-wrap: wrap; }
.tag-label { color: var(--color-text-muted); }
.card-journey-tag a { color: var(--color-primary); font-weight: 700; text-decoration: none; }

.card-footer { display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--color-border); padding-top: 10px; margin-top: 10px; font-size: 12px; }
.author-text { color: var(--color-text-muted); }
.link-arrow { color: var(--color-primary); font-weight: 700; text-decoration: none; }

.empty-card { text-align: center; padding: 50px 20px; background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-xl); margin-top: 20px; }
.empty-icon { font-size: 42px; margin-bottom: 10px; }

@media (max-width: 900px) {
  .featured-hero { grid-template-columns: 1fr; }
  .hero-image-wrap { height: 220px; }
}
</style>