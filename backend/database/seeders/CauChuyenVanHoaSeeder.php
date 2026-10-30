<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class CauChuyenVanHoaSeeder extends Seeder
{
    public function run(): void
    {
        $stories = [
            1 => [
                'tieu_de' => 'Phở Hà Nội – Hương vị thân quen của đất Kinh Kỳ',
                'noi_dung' => 'Nhắc đến ẩm thực Hà Nội, phở luôn là một trong những món ăn được nhớ đến đầu tiên. Một bát phở hấp dẫn bởi sự hòa quyện giữa bánh phở mềm, thịt bò hoặc thịt gà, nước dùng trong và thơm cùng các loại rau gia vị. Điểm làm nên sức cuốn hút của phở nằm ở nồi nước dùng được ninh kỹ, tạo nên vị ngọt thanh và hương thơm đặc trưng. Từ những hàng phở bình dị trên phố đến các quán ăn lâu năm, phở đã trở thành một phần quen thuộc trong nhịp sống của người Hà Nội. Thưởng thức phở không chỉ là trải nghiệm hương vị mà còn là cách cảm nhận nét tinh tế, chậm rãi của văn hóa ẩm thực Thủ đô.',
            ],
            2 => [
                'tieu_de' => 'Bún chả Hà Nội – Tinh hoa nét ẩm thực Kẻ Chợ',
                'noi_dung' => 'Bún chả là món ăn mang đậm phong vị Hà Nội, nổi bật với hương thơm của thịt nướng trên than hoa. Những miếng chả được tẩm ướp đậm đà, nướng xém cạnh, kết hợp cùng chả viên mềm thơm, bún tươi và bát nước chấm chua ngọt có vị hài hòa. Rau sống ăn kèm giúp cân bằng hương vị, tạo nên một tổng thể vừa đậm đà vừa thanh mát. Hình ảnh thực khách ngồi bên những quán bún chả nghi ngút khói đã trở nên thân thuộc trong đời sống phố phường Hà Nội. Món ăn không cầu kỳ trong cách thưởng thức nhưng lại thể hiện sự khéo léo trong lựa chọn nguyên liệu và phối hợp hương vị của người Tràng An.',
            ],
            3 => [
                'tieu_de' => 'Bánh đa cua Hải Phòng – Hương vị đậm đà của thành phố Cảng',
                'noi_dung' => 'Bánh đa cua là một trong những món ăn tiêu biểu khi nhắc đến ẩm thực Hải Phòng. Sợi bánh đa đỏ dai mềm tạo nên dấu ấn riêng, kết hợp với nước dùng cua đồng đậm vị và các thành phần ăn kèm như chả lá lốt, tôm, rau muống hoặc hành phi tùy cách chế biến. Một bát bánh đa cua hấp dẫn bởi sự hòa quyện giữa vị ngọt tự nhiên của cua, hương thơm của các nguyên liệu và màu sắc bắt mắt. Món ăn phản ánh sự gần gũi của ẩm thực vùng duyên hải Bắc Bộ, nơi nguyên liệu địa phương được tận dụng khéo léo để tạo nên những món ăn giàu bản sắc. Với người dân đất Cảng, bánh đa cua không chỉ là món ăn quen thuộc mà còn là hương vị gợi nhớ quê nhà.',
            ],
            4 => [
                'tieu_de' => 'Bánh cuốn Đồng Văn – Nét mộc mạc trong ẩm thực vùng cao',
                'noi_dung' => 'Giữa không gian núi đá và những phiên chợ vùng cao Đồng Văn, bánh cuốn nóng là món ăn mang đến trải nghiệm ẩm thực gần gũi và ấm áp. Bánh được tráng từ bột gạo thành lớp mỏng, mềm, thường ăn cùng nhân thịt, mộc nhĩ và bát nước dùng nóng. Cách thưởng thức bánh cuốn ở vùng cao tạo nên nét riêng khi thực khách có thể dùng bánh cùng nước dùng thay cho kiểu nước chấm thường gặp ở nhiều nơi khác. Trong tiết trời se lạnh của cao nguyên đá, một đĩa bánh cuốn nóng trở thành lựa chọn giản dị nhưng đầy hấp dẫn. Món ăn góp phần làm phong phú trải nghiệm khám phá đời sống và văn hóa ẩm thực địa phương của du khách khi đến Đồng Văn.',
            ],
            5 => [
                'tieu_de' => 'Bún bò Huế – Bản sắc đậm đà của ẩm thực cố đô',
                'noi_dung' => 'Bún bò Huế là món ăn nổi bật trong kho tàng ẩm thực miền Trung, gây ấn tượng bởi nước dùng đậm đà, hương thơm của sả và vị cay đặc trưng. Tô bún thường có sợi bún to, thịt bò, giò heo cùng các loại rau ăn kèm. Sự kết hợp giữa vị ngọt của nước dùng, vị thơm của gia vị và chút cay nồng tạo nên nét hấp dẫn khó nhầm lẫn. Món ăn thể hiện phong cách ẩm thực Huế với sự chú trọng đến hương vị và cách phối hợp nguyên liệu. Từ những quán ăn bình dân đến các địa chỉ ẩm thực được nhiều du khách tìm đến, bún bò Huế đã trở thành một đại diện quen thuộc khi giới thiệu văn hóa ẩm thực của vùng đất cố đô.',
            ],
            6 => [
                'tieu_de' => 'Mì Quảng – Hương vị quê nhà xứ Quảng',
                'noi_dung' => 'Mì Quảng là món ăn gắn liền với đời sống ẩm thực của người dân xứ Quảng. Khác với nhiều món mì có nhiều nước dùng, mì Quảng thường được phục vụ với lượng nước dùng vừa phải, chan đậm vào sợi mì để làm nổi bật hương vị của phần nhân. Tùy cách chế biến, món ăn có thể kết hợp với tôm, thịt heo, thịt gà hoặc các nguyên liệu khác, ăn cùng rau sống, đậu phộng rang và bánh tráng nướng. Sự phong phú trong nguyên liệu nhưng vẫn giữ được nét hài hòa tạo nên sức hấp dẫn riêng của món ăn. Mì Quảng không chỉ là một lựa chọn quen thuộc trong bữa ăn hằng ngày mà còn là biểu tượng cho sự chân chất, hào sảng trong văn hóa ẩm thực xứ Quảng.',
            ],
            7 => [
                'tieu_de' => 'Cơm tấm Sài Gòn – Hương vị bình dị giữa nhịp sống đô thị',
                'noi_dung' => 'Cơm tấm là món ăn quen thuộc trong đời sống ẩm thực Thành phố Hồ Chí Minh. Từ những hạt gạo tấm nhỏ, người chế biến tạo nên đĩa cơm thơm mềm, thường ăn cùng sườn nướng, bì, chả trứng và nước mắm pha. Miếng sườn được nướng thơm, kết hợp với vị đậm đà của nước mắm và các món ăn kèm tạo nên hương vị đặc trưng khó quên. Cơm tấm có thể được tìm thấy từ những quán ăn vỉa hè đến các cửa hàng đông khách, phục vụ nhiều đối tượng thực khách trong nhịp sống bận rộn của thành phố. Sự giản dị, tiện lợi nhưng vẫn đầy đủ hương vị đã giúp món ăn trở thành một nét thân thuộc trong văn hóa ẩm thực Sài Gòn.',
            ],
            8 => [
                'tieu_de' => 'Bánh xèo miền Tây – Hương đồng quê trong từng chiếc bánh',
                'noi_dung' => 'Bánh xèo miền Tây hấp dẫn thực khách ngay từ âm thanh xèo vui tai khi lớp bột được đổ vào chảo nóng. Chiếc bánh vàng giòn thường có nhân tôm, thịt, giá đỗ và được ăn cùng nhiều loại rau vườn, rau thơm. Người thưởng thức thường cuốn một miếng bánh với rau rồi chấm vào nước mắm chua ngọt, tạo nên sự kết hợp hài hòa giữa vị béo, giòn, tươi mát và đậm đà. Ở vùng sông nước Nam Bộ, bữa ăn với bánh xèo thường gợi lên không khí sum họp, thân tình khi mọi người cùng chuẩn bị rau, đổ bánh và thưởng thức bên nhau. Món ăn thể hiện sự phong phú của sản vật địa phương và nét phóng khoáng trong văn hóa ẩm thực miền Tây.',
            ],
            9 => [
                'tieu_de' => 'Bún cá Châu Đốc – Hương vị đặc sắc miền sông nước An Giang',
                'noi_dung' => 'Bún cá Châu Đốc là món ăn tiêu biểu của vùng đất An Giang, nơi văn hóa ẩm thực chịu ảnh hưởng từ đời sống sông nước và sự giao thoa văn hóa của nhiều cộng đồng cư dân. Món ăn thường sử dụng cá lóc, kết hợp với nước dùng có màu sắc và hương thơm đặc trưng, ăn cùng bún tươi và các loại rau như rau muống, bắp chuối hoặc rau thơm. Một số cách chế biến còn sử dụng nghệ và mắm để tạo chiều sâu cho hương vị. Sự hòa quyện giữa vị ngọt của cá, vị đậm đà của nước dùng và rau ăn kèm đem đến trải nghiệm riêng biệt. Thưởng thức bún cá Châu Đốc cũng là dịp để du khách khám phá nét phong phú trong văn hóa ẩm thực vùng sông nước miền Tây Nam Bộ.',
            ],
            10 => [
                'tieu_de' => 'Cao lầu Hội An – Dấu ấn ẩm thực giữa lòng phố cổ',
                'noi_dung' => 'Cao lầu là món ăn gắn liền với hình ảnh phố cổ Hội An, nổi bật bởi sợi mì có độ dai và màu sắc đặc trưng. Một tô cao lầu thường gồm sợi mì, thịt xá xíu, rau sống, tóp mỡ hoặc bánh chiên giòn, đi kèm một lượng nước sốt vừa đủ để tạo vị đậm đà. Khi thưởng thức, thực khách cảm nhận được sự kết hợp giữa vị thơm của thịt, độ dai của sợi mì và sự tươi mát của rau. Món ăn thường được nhắc đến cùng câu chuyện về nét giao thoa văn hóa của thương cảng Hội An xưa, nơi nhiều dòng văn hóa cùng để lại dấu ấn trong đời sống địa phương. Ngày nay, cao lầu đã trở thành một trải nghiệm ẩm thực được nhiều du khách tìm kiếm khi ghé thăm phố cổ.',
            ],
        ];

        DB::transaction(function () use ($stories) {
            foreach ($stories as $monAnId => $story) {
                DB::table('cau_chuyen_van_hoa')
                    ->where('mon_an_id', $monAnId)
                    ->update([
                        'tieu_de' => $story['tieu_de'],
                        'noi_dung' => $story['noi_dung'],
                    ]);
            }
        });
    }
}
