<script setup>
import { RouterLink } from 'vue-router'
</script>

<template>
  <footer class="site-footer">
    <div class="container footer-content">
      <div class="footer-grid">

        <!-- Cột 1: Thông tin thương hiệu -->
        <div class="footer-brand">
          <div class="brand-logo">
            <span class="logo-badge">AT-11</span>
            <span class="logo-text">Vietnam Culinary Editorial</span>
          </div>
          <p class="brand-desc">
            Nền tảng biên tập và lưu trữ di sản văn hóa ẩm thực Việt Nam. Kết nối thực khách với những hành trình trải nghiệm ba miền nguyên bản.
          </p>
          <div class="social-links">
            <a href="#" class="social-btn" title="Facebook">FB</a>
            <a href="#" class="social-btn" title="Instagram">IG</a>
            <a href="#" class="social-btn" title="YouTube">YT</a>
            <a href="#" class="social-btn" title="TikTok">TT</a>
          </div>
        </div>

        <!-- Cột 2: Khám phá nhanh -->
        <div class="footer-col">
          <h4>Khám phá</h4>
          <ul>
            <li><RouterLink to="/">Trang chủ</RouterLink></li>
            <li><RouterLink to="/hanh-trinh">Hành trình ẩm thực</RouterLink></li>
            <li><RouterLink to="/mon-an">Danh mục món ăn</RouterLink></li>
            <li><RouterLink to="/ban-do">Bản đồ ẩm thực</RouterLink></li>
            <li><RouterLink to="/ho-so-ca-nhan">Tài khoản cá nhân</RouterLink></li>
          </ul>
        </div>

        <!-- Cột 3: Hỗ trợ & Pháp lý -->
        <div class="footer-col">
          <h4>Hỗ trợ & Pháp lý</h4>
          <ul>
            <li><a href="#">Điều khoản sử dụng</a></li>
            <li><a href="#">Chính sách bảo mật</a></li>
            <li><a href="#">Chính sách hoàn tiền</a></li>
            <li><a href="#">Câu hỏi thường gặp (FAQ)</a></li>
          </ul>
        </div>

        <!-- Cột 4: Đăng ký nhận tin & Hotline -->
        <div class="footer-col footer-newsletter">
          <h4>Bản tin Ẩm thực</h4>
          <p>Nhận bài viết biên tập và ưu đãi hành trình mới nhất hàng tuần.</p>
          <div class="newsletter-box">
            <input type="email" placeholder="Email của bạn..." />
            <button type="button">Gửi →</button>
          </div>
          <div class="contact-info">
            <span>📞 Hotline: 1900 1122</span>
            <span>✉️ Email: contact@culinaryeditorial.vn</span>
          </div>
        </div>

      </div>

      <!-- Dòng bản quyền dưới cùng -->
      <div class="footer-bottom">
        <p>© 2026 Vietnam Culinary Editorial (AT-11). Tất cả quyền được bảo lưu.</p>
        <div class="footer-bottom-links">
          <a href="#">Bảo mật</a>
          <span>•</span>
          <a href="#">Điều khoản</a>
          <span>•</span>
          <a href="#">Sitemap</a>
        </div>
      </div>
    </div>
  </footer>
</template>

<style scoped>
.site-footer {
  background: #0f172a;
  color: #94a3b8;
  padding: 60px 0 24px;
  margin-top: auto;
  border-top: 1px solid #1e293b;
  font-family: inherit;
}

.footer-grid {
  display: grid;
  grid-template-columns: 1.8fr 1fr 1fr 1.4fr;
  gap: 40px;
  margin-bottom: 48px;
}

.footer-brand .brand-logo {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
}

.logo-badge {
  background: #2563eb;
  color: #ffffff;
  font-weight: 800;
  font-size: 13px;
  padding: 4px 8px;
  border-radius: 6px;
}

.logo-text {
  color: #ffffff;
  font-size: 18px;
  font-weight: 700;
  letter-spacing: -0.02em;
}

.brand-desc {
  font-size: 14px;
  line-height: 1.6;
  color: #94a3b8;
  margin-bottom: 20px;
}

.social-links {
  display: flex;
  gap: 10px;
}

.social-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  background: #1e293b;
  color: #cbd5e1;
  border-radius: 8px;
  text-decoration: none;
  font-size: 12px;
  font-weight: 700;
  transition: all 0.2s ease;
}

.social-btn:hover {
  background: #2563eb;
  color: #ffffff;
  transform: translateY(-2px);
}

.footer-col h4 {
  color: #ffffff;
  font-size: 16px;
  font-weight: 600;
  margin: 0 0 20px;
}

.footer-col ul {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.footer-col a {
  color: #94a3b8;
  text-decoration: none;
  font-size: 14px;
  transition: color 0.2s ease;
}

.footer-col a:hover {
  color: #38bdf8;
}

.footer-newsletter p {
  font-size: 14px;
  line-height: 1.5;
  margin-bottom: 16px;
}

.newsletter-box {
  display: flex;
  gap: 8px;
  margin-bottom: 20px;
}

.newsletter-box input {
  flex: 1;
  background: #1e293b;
  border: 1px solid #334155;
  border-radius: 8px;
  padding: 10px 14px;
  color: #ffffff;
  font-size: 14px;
  outline: none;
}

.newsletter-box input:focus {
  border-color: #2563eb;
}

.newsletter-box button {
  background: #2563eb;
  color: #ffffff;
  border: none;
  border-radius: 8px;
  padding: 0 16px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s;
}

.newsletter-box button:hover {
  background: #1d4ed8;
}

.contact-info {
  display: flex;
  flex-direction: column;
  gap: 6px;
  font-size: 13px;
  color: #cbd5e1;
}

.footer-bottom {
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-top: 1px solid #1e293b;
  padding-top: 24px;
  font-size: 13px;
  color: #64748b;
}

.footer-bottom p {
  margin: 0;
}

.footer-bottom-links {
  display: flex;
  gap: 12px;
  align-items: center;
}

.footer-bottom-links a {
  color: #64748b;
  text-decoration: none;
}

.footer-bottom-links a:hover {
  color: #94a3b8;
}

@media (max-width: 1024px) {
  .footer-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 640px) {
  .footer-grid {
    grid-template-columns: 1fr;
    gap: 32px;
  }
  .footer-bottom {
    flex-direction: column;
    gap: 12px;
    text-align: center;
  }
}
</style>