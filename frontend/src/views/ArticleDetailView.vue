<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, RouterLink } from 'vue-router'

import hanoiImg from '../assets/images/journeys/hanoi.jpeg'
import hoiAnImg from '../assets/images/journeys/hoi-an.jpg'
import phuQuocImg from '../assets/images/journeys/journey-6.jpg'
import tayBacImg from '../assets/images/journeys/ha-giang.jpg'

const route = useRoute()
const articleId = computed(() => Number(route.params.id))

// KHO BÀI VIẾT CHUYÊN SÂU & GIÀU CHẤT LIỆU VĂN HÓA
const articlesData = {
  1: {
    id: 1,
    title: 'Phở Hà Nội: Từ gánh hàng rong ven đường đến biểu tượng ẩm thực thế giới',
    subtitle: 'Hành trình hơn một thế kỷ lắng đọng trong tô phở truyền thống - nét tinh hoa văn hóa ngàn năm văn hiến được gìn giữ qua bao thế hệ người Tràng An.',
    categoryName: 'Di sản & Văn hóa',
    publishedDate: '15/10/2026',
    readTime: '8 phút đọc',
    author: 'Biên tập viên AT-11',
    authorRole: 'Chuyên gia Văn hóa Ẩm thực Bắc Bộ',
    image: hanoiImg,
    relatedJourneyId: 1,
    relatedJourneyName: 'Tinh hoa Ẩm thực Phố cổ Hà Nội',
    relatedJourneyDesc: 'Trải nghiệm trực tiếp gánh phở gia truyền 3 đời, học cách phân biệt phở Bò Thìn - Phở Bát Đàn và khám phá 4 điểm dừng ẩm thực độc bản giữa lòng Phố Cổ.',
    highlights: [
      'Nguồn gốc hình thành gắn liền với tiếng rao đêm Phố Cổ đầu thế kỷ 20.',
      'Bí mật nồi nước dùng thanh ngọt nguyên bản từ xương ống hầm 12 tiếng & sá sùng khô.',
      'Nghệ thuật thưởng thức chuẩn điệu người Tràng An: Không rau giá, thêm quẩy giòn và chút ớt phố cổ.'
    ],
    contentHtml: `
      <p class="drop-cap">Nếu có một món ăn có thể gói gọn trọn vẹn tinh thần, nhịp sống và chiều sâu văn hóa của Thủ đô ngàn năm văn hiến, đó chắc chắn phải là Phở Hà Nội. Không chỉ đơn thuần là một món ăn sáng, phở đã trở thành một triết lý thưởng thức, một di sản sống động hiện diện trong từng hơi thở của người dân Thành Nam qua bao thăng trầm thời gian.</p>

      <h2>1. Lịch sử gánh phở xưa và tiếng rao đêm Phố Cổ</h2>
      <p>Nguồn gốc của phở Hà Nội bắt đầu từ những năm đầu thế kỷ 20, gắn liền với những gánh phở rong trảo trên vai người bán dọc theo các con phố cổ như Hàng Bạc, Hàng Bè, Cầu Gỗ. Đôi gánh gỗ ấy một bên là thùng nước dùng nghi ngút khói giữ nhiệt bằng bếp than hồng đỏ lửa giữa đêm đông, bên kia là thùng gỗ đựng bánh phở, bát đĩa và chiếc dĩa thái thịt sáng bóng.</p>
      <p>Tiếng rao <em>"Phở ơơơ..."</em> ngân vang qua các ngõ ngách rêu phong không chỉ xua đi cái lạnh cắt da cắt thịt của mùa đông Bắc Bộ, mà còn định hình nên một thói quen thưởng thức ẩm thực đầy tinh tế của người Hà Thành.</p>

      <blockquote class="editorial-quote">
        “Phở là một quà đặc biệt của Hà Nội, không phải chỉ riêng Hà Nội mới có, nhưng chính là vì chỉ ở Hà Nội mới ngon. Phở ngon phải là phở "cổ điển", nấu bằng thịt bò, nước dùng trong và ngọt, bánh dẻo mà không nát, thịt mỏng mà dẻo...”
        <cite>— Nhà văn Thạch Lam (Tập luận văn "Hà Nội 36 phố phường")</cite>
      </blockquote>

      <h2>2. Nghệ thuật hầm nước dùng thanh ngọt nguyên bản</h2>
      <p>Bí quyết làm nên tâm hồn của Phở Hà Nội nằm trọn ở nồi nước dùng. Khác với phở miền Nam thường có vị ngọt đậm của đường và dùng kèm rau thơm rậm rạp, phở Hà Nội chú trọng tuyệt đối vào <strong>độ thanh trong nhưng vị sâu thẳm</strong>.</p>
      <p>Một nồi nước dùng chuẩn vị truyền thống đòi hỏi sự kiên nhẫn tột cùng:</p>
      <ul>
        <li><strong>Xương ống bò tươi:</strong> Được tẩy sạch bằng muối và gừng nướng, luộc bỏ nước đầu rồi mới đem hầm liu riu liên tục từ 10 đến 12 tiếng.</li>
        <li><strong>Gia vị nướng gia truyền:</strong> Hành khô, gừng già được nướng xém vỏ trên than hồng để lấy mùi thơm, kết hợp cùng hoa hồi, thảo quả, nụ vối và chút quế chi.</li>
        <li><strong>Bí kíp sá sùng khô:</strong> Ở những tiệm phở cổ truyền trứ danh, người thợ luôn thả vào nồi hầm một vốc sá sùng Quan Lạn nướng kỹ. Sá sùng mang lại vị ngọt đậm đà tự nhiên (vị Umami) mà không loại gia vị công nghiệp nào có thể thay thế được.</li>
      </ul>

      <div class="highlight-stats">
        <div class="stat-item">
          <strong>12+ Tiếng</strong>
          <span>Thời gian hầm xương bò tiêu chuẩn</span>
        </div>
        <div class="stat-item">
          <strong>100% Nguyên bản</strong>
          <span>Vị ngọt tự nhiên từ Sá sùng & Thảo mộc</span>
        </div>
        <div class="stat-item">
          <strong>3 Đời</strong>
          <span>Gia truyền gìn giữ công thức cốt lõi</span>
        </div>
      </div>

      <h2>3. Thưởng thức Phở đúng điệu người Tràng An</h2>
      <p>Thưởng thức phở Hà Nội đúng cách là một nghi thức tinh tế. Bát phở bưng ra phải nóng hổi, khói bốc nghi ngút tỏa hương thơm ngạt ngào của hành hoa, thì là và thịt bò. Bánh phở mỏng, dẻo dai vừa phải; thịt bò tái chần vừa tới giữ trọn màu hồng đào tươi tắn.</p>
      <p>Trước khi nêm thêm bất kỳ gia vị nào, hãy nhấp một thìa nước dùng đầu tiên để cảm nhận vị béo ngậy thanh tao tan chảy nơi đầu lưỡi. Người Hà Nội sành ăn thường dùng phở kèm vài quẩy giòn rụm chấm ngập trong nước phở, thêm chút dấm tỏi ớt gia truyền để đánh thức trọn vẹn vị giác.</p>

      <div class="recommend-box">
        <h4>📍 Địa chỉ Phở gia truyền trứ danh nên thử tại Hà Nội:</h4>
        <ul>
          <li><strong>Phở Bát Đàn:</strong> 49 Bát Đàn, Hoàn Kiếm (Nổi tiếng với văn hóa xếp hàng thưởng thức phở bò gia truyền).</li>
          <li><strong>Phở Thìn Lò Đúc:</strong> 13 Lò Đúc, Hai Bà Trưng (Đặc trưng với món phở bò tái lăn xào chảo lửa lớn béo ngậy).</li>
          <li><strong>Phở Tư Lùn:</strong> 23C Hai Bà Trưng (Nước dùng ngầu đục đặc trưng, đậm đà vị tủy xương).</li>
        </ul>
      </div>
    `
  },
  2: {
    id: 2,
    title: 'Bí mật đằng sau sợi mì Cao Lầu Hội An: Nước giếng cổ và tro củi tràm xứ Quảng',
    subtitle: 'Tại sao Cao Lầu chỉ chuẩn vị khi được chế tác tại Phố cổ Hội An? Khám phá ẩn số độc bản của di sản ẩm thực xứ Quảng nức tiếng dải đất miền Trung.',
    categoryName: 'Di sản & Văn hóa',
    publishedDate: '20/10/2026',
    readTime: '7 phút đọc',
    author: 'Góc Biên Tập',
    authorRole: 'Nhà nghiên cứu Văn hóa Dân gian xứ Quảng',
    image: hoiAnImg,
    relatedJourneyId: 3,
    relatedJourneyName: 'Hương vị Phố cổ Hội An',
    relatedJourneyDesc: 'Thưởng thức tô Cao Lầu chính gốc bên dòng sông Hoài thơ mộng, khám phá làng rau Trà Quế và bí kíp làm bánh mì Phượng truyền thống.',
    highlights: [
      'Giao thoa văn hóa giữa Nhật Bản (mì Ramen), Trung Hoa (xá xíu) và tâm hồn Việt.',
      'Sử dụng nước giếng cổ Bá Lễ ngàn năm không nhiễm mặn hay phèn.',
      'Bột gạo ngâm tro củi tràm lấy từ Cù Lao Chàm tạo nên độ dai sần sật độc nhất.'
    ],
    contentHtml: `
      <p class="drop-cap">Cao Lầu không chỉ đơn thuần là một món ăn ngon, mà còn là một sự ngưng đọng lịch sử đầy tự hào của thương cảng Faifo sầm uất thế giới ở thế kỷ 17. Mang nét giao thoa độc đáo giữa mì Ramen Nhật Bản, thịt xá xíu Trung Hoa và tâm hồn ẩm thực Việt mộc mạc, Cao Lầu sở hữu những quy tắc chế biến vô cùng khắt khe mà không một nơi nào ngoài Hội An có thể sao chép được.</p>

      <h2>1. Ba yếu tố thiên nhiên độc bản tạo nên sợi mì Cao Lầu</h2>
      <p>Nhiều người từng thử đem công thức Cao Lầu đi nấu ở nơi khác nhưng đều thất bại. Mới hay, sự bí ẩn của món ăn này phụ thuộc hoàn toàn vào nguồn tài nguyên thiên nhiên đặc hữu của vùng đất Quảng Nam:</p>
      <ul>
        <li><strong>Nước giếng cổ Bá Lễ:</strong> Nước dùng để nhào bột gạo phải là nước lấy từ giếng Bá Lễ – giếng nước cổ champa trăm tuổi nổi tiếng với dòng nước ngọt thanh, không phèn, không vôi.</li>
        <li><strong>Tro củi tràm Cù Lao Chàm:</strong> Bột gạo gieo trồng trên đất Quảng được ngâm trong nước tro thu hoạch từ việc đốt củi tràm ở đảo Cù Lao Chàm. Chính chất kiềm tự nhiên trong tro tràm đã tạo nên màu vàng đượm hổ泊 cùng độ dẻo giòn sần sật đặc trưng cho sợi mì.</li>
        <li><strong>Rau sống làng Trà Quế:</strong> Tô mì chỉ tròn vị khi ăn kèm bộ 12 loại rau mầm tươi ngon ngắt ngay tại làng rau húng gia truyền Trà Quế.</li>
      </ul>

      <blockquote class="editorial-quote">
        “Không có nước giếng Bá Lễ và tro tràm Cù Lao Chàm, sợi mì sẽ mất đi độ dai giòn kỳ bí. Đó là lý do Cao Lầu chỉ thực sự thuộc về Hội An.”
      </blockquote>

      <div class="highlight-stats">
        <div class="stat-item">
          <strong>Giếng Bá Lễ</strong>
          <span>Nguồn nước ngầm cổ độc nhất</span>
        </div>
        <div class="stat-item">
          <strong>Cù Lao Chàm</strong>
          <span>Tro củi tràm tạo độ dai tự nhiên</span>
        </div>
        <div class="stat-item">
          <strong>Rau Trà Quế</strong>
          <span>12 vị rau thơm dậy hương</span>
        </div>
      </div>

      <h2>2. Thưởng thức bản hòa tấu hương vị bên dòng sông Hoài</h2>
      <p>Một tô Cao Lầu chuẩn vị không nhiều nước như phở hay bún. Khi gọi món, người phục vụ chỉ rưới một thìa nước sốt thịt xá xíu đậm đà, sánh quyện lên trên lớp mì vàng ươm. Xếp cùng là những lát thịt xá xíu ướp ngũ vị hương nướng thơm xém cạnh, da heo (hoặc bột mì) chiên giòn rụm và mớ rau sống xanh mướt.</p>
      <p>Trộn đều tô mì, cắn một miếng xá xíu thơm lừng hòa quyện cùng vị sần sật của mì và vị cay nồng của ớt ỉa Quảng Nam, thực khách như đang ngược dòng thời gian trở về thời kỳ thương cảng giao thương tấp nập.</p>

      <div class="recommend-box">
        <h4>📍 Tọa độ thưởng thức Cao Lầu chuẩn vị Hội An:</h4>
        <ul>
          <li><strong>Cao Lầu Thanh:</strong> 26 Thái Phiên, Phố cổ Hội An (Quán bình dân lâu đời được giới sành ăn đánh giá chuẩn vị nhất).</li>
          <li><strong>Cao Lầu Liên:</strong> 16 Thái Phiên (Nổi tiếng với nước sốt xá xíu đậm đà, da heo chiên giòn rụm).</li>
          <li><strong>Cao Lầu Không Gian Xanh:</strong> 687 Hai Bà Trưng (Không gian cổ kính tuyệt đẹp ngay trung tâm).</li>
        </ul>
      </div>
    `
  },
  3: {
    id: 3,
    title: 'Cẩm nang thưởng thức hải sản Phú Quốc: Ăn gì, ở đâu và cách chọn đồ tươi sống',
    subtitle: 'Bỏ túi bí kíp sành ăn khi đến Đảo Ngọc: Thưởng thức ghẹ Hàm Ninh, gỏi cá trích tươi sống và ghé thăm những làng chài lâu đời phương Nam.',
    categoryName: 'Cẩm nang & Kinh nghiệm',
    publishedDate: '24/10/2026',
    readTime: '9 phút đọc',
    author: 'Chuyên gia Du lịch',
    authorRole: 'Food Critic & Senior Travel Editor',
    image: phuQuocImg,
    relatedJourneyId: 6,
    relatedJourneyName: 'Hương vị Biển đảo Phú Quốc',
    relatedJourneyDesc: 'Khám phá tour trải nghiệm ẩm thực đảo ngọc, ăn hải sản trực tiếp trên bè cá làng chài và thưởng thức bún quậy Kiến Xây trứ danh.',
    highlights: [
      'Bí kíp chọn ghẹ Hàm Ninh chắc thịt, không bị xốp hay nhiều nước.',
      'Cách thưởng thức Gỏi cá trích tươi sống an toàn và chuẩn vị miền biển.',
      'Trải nghiệm tự tay quậy tô bún tôm tươi ngon nức tiếng.'
    ],
    contentHtml: `
      <p class="drop-cap">Được thiên nhiên ưu ái dành tặng nguồn hải sản phong phú bậc nhất Việt Nam nhờ vùng biển ấm bạt ngàn, Phú Quốc là thiên đường đích thực đối với những thực khách yêu thích hương vị biển cả nguyên bản. Tuy nhiên, để trải nghiệm hải sản đúng chất "sành ăn" và tránh bẫy giá du lịch, bạn nhất định phải bỏ túi những kinh nghiệm thực tế dưới đây.</p>

      <h2>1. Top 3 Đặc sản hải sản nhất định phải thử tại Đảo Ngọc</h2>
      <p>Đến Phú Quốc mà chưa thưởng thức 3 món ăn biểu tượng này thì chuyến đi của bạn coi như chưa trọn vẹn:</p>

      <ol>
        <li><strong>Gỏi cá trích tái chanh:</strong> Món ăn biểu tượng với thịt cá trích vừa đánh bắt còn tươi rói, làm sạch thái mỏng trộn cùng dừa nạo, hành tây, đậu phụng rang và cuốn bánh tráng chấm nước mắm tỏi ớt ủ từ thùng gỗ Phú Quốc.</li>
        <li><strong>Ghẹ hấp làng chài Hàm Ninh:</strong> Ghẹ Hàm Ninh tuy không quá to nhưng thịt vô cùng săn chắc, ngọt đậm đà tự nhiên. Chỉ cần hấp sả đơn giản rồi chấm muối tiêu chanh Phú Quốc là đủ gây thương nhớ.</li>
        <li><strong>Bún quậy Kiến Xây:</strong> Tô bún tươi quậy trực tiếp từ chả tôm, chả cá thu tươi giòn, chan nước hầm hải sản thanh ngọt và tự tay thực khách pha chén nước chấm tắc ớt theo khẩu vị riêng.</li>
      </ol>

      <blockquote class="editorial-quote">
        “Cái ngon của hải sản Phú Quốc nằm ở độ tươi tuyệt đối. Cá trích hay ghẹ vừa kéo lưới lên bè là đưa ngay vào bếp, giữ trọn vị mặn mòi ngọt thanh của biển cả.”
      </blockquote>

      <div class="highlight-stats">
        <div class="stat-item">
          <strong>Làng chài Hàm Ninh</strong>
          <span>Tọa độ ghẹ tươi ngon nhất đảo</span>
        </div>
        <div class="stat-item">
          <strong>Tháng 10 - Tháng 4</strong>
          <span>Mùa hải sản Phú Quốc ngon nhất năm</span>
        </div>
        <div class="stat-item">
          <strong>Nước mắm 40° Đạm</strong>
          <span>Gia vị chấm linh hồn xứ đảo</span>
        </div>
      </div>

      <h2>2. Bí quyết chọn hải sản tươi sống tại chợ đêm & bè cá</h2>
      <p>Khi mua hải sản tại Chợ đêm Dương Đông hoặc các nhà bè ở An Thới, Rạch Vẹm, hãy áp dụng các mẹo nhỏ sau:</p>
      <ul>
        <li><strong>Chọn ghẹ chắc thịt:</strong> Bấm nhẹ vào phần yếm dưới bụng ghẹ, nếu cứng dẻo là ghẹ chắc thịt. Tránh chọn ghẹ quá to nhưng yếm mềm nhũn vì thường bị xốp và tích nhiều nước bên trong. Nên ăn ghẹ vào đầu hoặc cuối tháng âm lịch (tránh mùa trăng tròn ghẹ dễ bị ốp).</li>
        <li><strong>Thưởng thức gỏi cá trích an toàn:</strong> Chỉ chọn những quán dùng cá trích tươi đánh bắt trong ngày, thịt cá có màu hồng sáng tươi. Khi cuốn nhớ thêm nhiều dừa nạo để vị béo hòa quyện vị chua ngọt của chanh.</li>
      </ul>

      <div class="recommend-box">
        <h4>📍 Địa chỉ ăn hải sản đúng giá, tươi ngon tại Phú Quốc:</h4>
        <ul>
          <li><strong>Bè cá Làng chài Hàm Ninh:</strong> Nơi thưởng thức ghẹ tươi sống nhấc thẳng từ bè lên nồi hấp.</li>
          <li><strong>Bún quậy Kiến Xây:</strong> 28 Bạch Đằng, P. Dương Đông (Địa chỉ bún quậy chính gốc lâu đời).</li>
          <li><strong>Quán Xin Chào Phú Quốc:</strong> 66 Trần Hưng Đạo (Không gian ngắm hoàng hôn ngút ngàn bên bờ biển tuyệt đẹp).</li>
        </ul>
      </div>
    `
  },
4: {
    id: 4,
    title: 'Nhật ký Tây Bắc: Lạc bước giữa sắc màu văn hóa và ẩm thực vùng cao nguyên đá',
    subtitle: 'Hành trình săn mây đỉnh đèo, khám phá chợ phiên rực rỡ sắc màu và thưởng thức trọn vẹn hương vị mắc khén, hạt dổi đậm đà của đại ngàn Tây Bắc.',
    categoryName: 'Nhật ký trải nghiệm',
    publishedDate: '26/10/2026',
    readTime: '6 phút đọc',
    author: 'Linh Đào',
    authorRole: 'Travel Blogger & Food Explorer',
    image: tayBacImg,
    relatedJourneyId: 4,
    relatedJourneyName: 'Sắc màu Ẩm thực Tây Bắc',
    relatedJourneyDesc: 'Khám phá hương vị núi rừng hùng vĩ với các gia vị đặc trưng như mắc khén, hạt dổi và lợn mán thui rơm.',
    highlights: [
      'Trải nghiệm săn mây bình minh trên những cung đường đèo hùng vĩ.',
      'Thưởng thức trọn vẹn hương vị mắc khén, hạt dổi trong các món nướng nguyên bản.',
      'Hòa mình vào không khí nhộn nhịp, rực rỡ sắc màu thổ cẩm của chợ phiên vùng cao.'
    ],
    contentHtml: `
      <p class="drop-cap">Tây Bắc không chỉ níu chân du khách bởi những dãy núi hùng vĩ trập trùng hay những con đèo uốn lượn trong sương mù, mà còn bởi chiều sâu văn hóa ẩm thực mộc mạc nhưng đầy tinh tế của các dân tộc H’Mông, Thái, Mường.</p>

      <h2>1. Hương vị đại ngàn: Độc bản gia vị Mắc Khén và Hạt Dổi</h2>
      <p>Nói đến ẩm thực Tây Bắc là nói đến nghệ thuật tẩm ướp gia vị từ đại ngàn. Khác với vị cay nồng của ớt hay cay cay của tiêu miền xuôi, mắc khén mang lại cảm giác tê nhẹ nơi đầu lưỡi cùng hương thơm ngào ngạt của vỏ cây rừng. Khi kết hợp cùng hạt dổi nướng than hồng, cặp đôi này tạo nên "linh hồn" cho mọi món nướng nơi đây.</p>
      <p>Từ miếng thịt lợn mán thui rơm giòn bì đến gà chạy bộ nướng củi, tất cả đều đậm đà, dậy mùi quyến rũ đến lạ kỳ. Nhấp thêm ngụm rượu ngô men lá thơm nồng, cái lạnh của sương đêm vùng cao như tan biến hoàn toàn.</p>

      <blockquote class="editorial-quote">
        “Ẩm thực Tây Bắc là sự giao hòa giữa thiên nhiên hoang sơ và tình người ấm áp. Mỗi món ăn đều gói gộp cả hương đất, mùi rừng và tấm lòng mộc mạc của đồng bào vùng cao.”
      </blockquote>

      <h2>2. Nhịp sống rực rỡ sắc màu nơi chợ phiên vùng cao</h2>
      <p>Đến Tây Bắc mà bỏ qua chợ phiên thì coi như chưa trọn vẹn hành trình. Từ sớm tinh mơ, khi sương mù còn giăng kín các lối đi, người dân từ khắp các bản làng đã rủ nhau xuống chợ trong những bộ trang phục thổ cẩm rực rỡ nhất.</p>

      <div class="highlight-stats">
        <div class="stat-item">
          <strong>1.500m</strong>
          <span>Độ cao trung bình tận hưởng không khí trong lành</span>
        </div>
        <div class="stat-item">
          <strong>100% Nguyên bản</strong>
          <span>Gia vị tự nhiên thu hái trực tiếp từ rừng sâu</span>
        </div>
      </div>

      <p>Ghé lại một gian hàng nhỏ ở góc chợ, khói tỏa nghi ngút từ chảo thắng cố nóng hổi hay chõ xôi ngũ sắc thơm dẻo. Bát thắng cố thơm mùi thảo mộc, ăn kèm bánh ngô nướng nướng than hồng mang lại trải nghiệm vị giác vô cùng chân thực.</p>

      <h2>3. Lời kết cho hành trình chinh phục Tây Bắc</h2>
      <p>Chuyến đi khép lại nhưng những dư vị ngọt ngào của núi rừng vẫn đọng lại mãi. Tây Bắc luôn là điểm đến chữa lành lý tưởng cho những ai muốn tìm lại sự bình yên trong tâm hồn và khám phá những giá trị ẩm thực di sản nguyên bản.</p>

      <div class="recommend-box">
        <h4>💡 Bí kíp bỏ túi cho chuyến đi Tây Bắc:</h4>
        <ul>
          <li>Thời điểm đẹp nhất: Mùa thu hoạch lúa chín (tháng 9 - 10) hoặc mùa hoa xuân (tháng 1 - 2).</li>
          <li>Đừng quên mua một ít hạt dổi, mắc khén khô về làm quà cho người thân.</li>
        </ul>
      </div>
    `
  }
}

const article = computed(() => {
  return articlesData[articleId.value] || articlesData[1]
})

onMounted(() => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
})
</script>

<template>
  <main class="page">
    <article class="article-container container" v-if="article">

      <!-- BREADCRUMB -->
      <nav class="breadcrumb">
        <RouterLink to="/">Trang chủ</RouterLink>
        <span>/</span>
        <RouterLink to="/bai-viet">Bài viết</RouterLink>
        <span>/</span>
        <span class="active">{{ article.categoryName }}</span>
      </nav>

      <!-- ARTICLE HEADER -->
      <header class="article-header">
        <div class="header-meta">
          <span class="cat-badge">{{ article.categoryName }}</span>
          <span>•</span>
          <span>⏱ {{ article.readTime }}</span>
          <span>•</span>
          <span>📅 {{ article.publishedDate }}</span>
        </div>

        <h1 class="article-title">{{ article.title }}</h1>
        <p class="article-subtitle">{{ article.subtitle }}</p>

        <div class="author-box">
          <div class="author-avatar">✍️</div>
          <div class="author-info">
            <strong>{{ article.author }}</strong>
            <small>{{ article.authorRole }}</small>
          </div>
        </div>
      </header>

      <!-- FEATURED IMAGE -->
      <div class="article-featured-image">
        <img :src="article.image" :alt="article.title" />
      </div>

      <!-- HIGHLIGHTS / QUICK TAKEAWAYS -->
      <div v-if="article.highlights" class="highlights-box">
        <div class="highlights-title">⚡ Điểm nổi bật trong bài viết:</div>
        <ul>
          <li v-for="(item, index) in article.highlights" :key="index">{{ item }}</li>
        </ul>
      </div>

      <!-- MAIN ARTICLE CONTENT -->
      <div class="article-body" v-html="article.contentHtml"></div>

      <!-- CONVERSION CARD: ĐẶT TOUR LIÊN QUAN -->
      <section v-if="article.relatedJourneyId" class="journey-cta-card">
        <div class="cta-inner">
          <div class="cta-badge">🗺️ TRẢI NGHIỆM THỰC TẾ</div>
          <h3>{{ article.relatedJourneyName }}</h3>
          <p>{{ article.relatedJourneyDesc }}</p>
          <RouterLink :to="`/hanh-trinh/${article.relatedJourneyId}`" class="cta-btn">
            Đặt ngay hành trình này →
          </RouterLink>
        </div>
      </section>

      <!-- FOOTER NAVIGATION -->
      <div class="article-nav-footer">
        <RouterLink to="/bai-viet" class="btn-back">
          ← Quay lại danh sách bài viết
        </RouterLink>
      </div>

    </article>
  </main>
</template>

<style scoped>
.page {
  padding: var(--space-8) 0 var(--space-16);
  background: #fafafa;
}

.article-container {
  max-width: 840px;
  margin: 0 auto;
  background: #ffffff;
  padding: 40px;
  border-radius: 20px;
  border: 1px solid var(--color-border);
  box-shadow: 0 4px 20px rgba(0,0,0,0.03);
}

/* BREADCRUMB */
.breadcrumb {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: var(--color-text-muted);
  margin-bottom: 24px;
}
.breadcrumb a {
  color: var(--color-text-muted);
  text-decoration: none;
}
.breadcrumb a:hover {
  color: var(--color-primary);
}
.breadcrumb .active {
  color: var(--color-primary);
  font-weight: 600;
}

/* HEADER */
.article-header {
  margin-bottom: 32px;
}
.header-meta {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: var(--color-text-muted);
  margin-bottom: 16px;
  flex-wrap: wrap;
}
.cat-badge {
  background: #eff6ff;
  color: #2563eb;
  font-weight: 700;
  padding: 4px 12px;
  border-radius: 6px;
  font-size: 12px;
}
.article-title {
  font-size: clamp(1.8rem, 3.5vw, 2.5rem);
  line-height: 1.25;
  color: #0f172a;
  margin: 0 0 16px;
  font-weight: 800;
  letter-spacing: -0.02em;
}
.article-subtitle {
  font-size: 17px;
  line-height: 1.6;
  color: #475569;
  margin: 0 0 24px;
}

.author-box {
  display: flex;
  align-items: center;
  gap: 12px;
  padding-top: 18px;
  border-top: 1px solid #f1f5f9;
}
.author-avatar {
  width: 44px;
  height: 44px;
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
}
.author-info strong {
  display: block;
  font-size: 14px;
  color: #0f172a;
}
.author-info small {
  font-size: 12px;
  color: #64748b;
}

/* FEATURED IMAGE */
.article-featured-image {
  width: 100%;
  height: 420px;
  border-radius: 16px;
  overflow: hidden;
  margin-bottom: 32px;
}
.article-featured-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

/* HIGHLIGHTS / QUICK TAKEAWAYS */
.highlights-box {
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  border-left: 4px solid #2563eb;
  border-radius: 12px;
  padding: 20px 24px;
  margin-bottom: 36px;
}
.highlights-title {
  font-weight: 700;
  color: #1e293b;
  font-size: 15px;
  margin-bottom: 10px;
}
.highlights-box ul {
  margin: 0;
  padding-left: 20px;
  color: #475569;
  font-size: 14.5px;
  line-height: 1.6;
}
.highlights-box li {
  margin-bottom: 6px;
}

/* ARTICLE BODY TYPOGRAPHY */
.article-body {
  font-size: 16.5px;
  line-height: 1.8;
  color: #334155;
}

/* Drop Cap hiệu ứng tạp chí */
.article-body :deep(.drop-cap::first-letter) {
  font-size: 3.5rem;
  float: left;
  line-height: 0.8;
  padding-right: 12px;
  padding-top: 4px;
  font-weight: 800;
  color: #2563eb;
}

.article-body :deep(h2) {
  font-size: 22px;
  color: #0f172a;
  margin: 40px 0 16px;
  font-weight: 700;
  border-bottom: 2px solid #f1f5f9;
  padding-bottom: 8px;
}
.article-body :deep(p) {
  margin-bottom: 22px;
}
.article-body :deep(ul), .article-body :deep(ol) {
  margin: 0 0 24px;
  padding-left: 24px;
}
.article-body :deep(li) {
  margin-bottom: 10px;
}

.article-body :deep(.editorial-quote) {
  background: #f0f7ff;
  border-left: 4px solid #2563eb;
  padding: 24px 28px;
  margin: 36px 0;
  font-size: 17px;
  font-style: italic;
  color: #1e3a8a;
  border-radius: 0 12px 12px 0;
  line-height: 1.65;
}
.article-body :deep(.editorial-quote cite) {
  display: block;
  margin-top: 12px;
  font-size: 13.5px;
  font-style: normal;
  font-weight: 700;
  color: #2563eb;
}

.article-body :deep(.highlight-stats) {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
  margin: 36px 0;
}
.article-body :deep(.stat-item) {
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  padding: 18px;
  border-radius: 12px;
  text-align: center;
}
.article-body :deep(.stat-item strong) {
  display: block;
  font-size: 22px;
  color: #2563eb;
  margin-bottom: 4px;
}
.article-body :deep(.stat-item span) {
  font-size: 12.5px;
  color: #64748b;
  font-weight: 500;
}

.article-body :deep(.recommend-box) {
  background: #fdfce7;
  border: 1px solid #fef08a;
  border-radius: 12px;
  padding: 20px 24px;
  margin: 36px 0;
}
.article-body :deep(.recommend-box h4) {
  margin: 0 0 12px;
  color: #854d0e;
  font-size: 16px;
}
.article-body :deep(.recommend-box ul) {
  margin: 0;
  padding-left: 20px;
  color: #713f12;
  font-size: 14.5px;
}

/* JOURNEY CONVERSION CTA */
.journey-cta-card {
  background: #0f172a;
  color: #ffffff;
  padding: 32px;
  border-radius: 16px;
  margin: 48px 0 24px;
  box-shadow: 0 12px 30px rgba(15, 23, 42, 0.2);
}
.cta-badge {
  display: inline-block;
  background: #2563eb;
  color: #ffffff;
  font-size: 11px;
  font-weight: 800;
  padding: 4px 10px;
  border-radius: 4px;
  margin-bottom: 12px;
  letter-spacing: 0.05em;
}
.cta-inner h3 {
  font-size: 20px;
  color: #ffffff;
  margin: 0 0 8px;
}
.cta-inner p {
  color: #94a3b8;
  font-size: 14.5px;
  margin: 0 0 20px;
  line-height: 1.6;
}
.cta-btn {
  display: inline-block;
  background: #2563eb;
  color: #ffffff;
  padding: 12px 24px;
  border-radius: 8px;
  font-weight: 700;
  text-decoration: none;
  font-size: 14px;
  transition: background 0.2s;
}
.cta-btn:hover {
  background: #1d4ed8;
}

/* FOOTER NAV */
.article-nav-footer {
  border-top: 1px solid #f1f5f9;
  padding-top: 24px;
  margin-top: 36px;
}
.btn-back {
  color: #2563eb;
  font-weight: 700;
  text-decoration: none;
  font-size: 14px;
}
.btn-back:hover {
  text-decoration: underline;
}

@media (max-width: 768px) {
  .article-container {
    padding: 20px;
    border-radius: 0;
  }
  .article-featured-image {
    height: 240px;
  }
}
</style>