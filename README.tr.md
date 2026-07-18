# QB Networks

Bootstrap yerleşim yardımcıları ve saf JavaScript (frontend framework olmadan) ile geliştirilmiş, modern ve mobil öncelikli bir tanıtım web sitesi.

## Proje Özeti

QB Networks; sarı, mor, gri ve beyaz renk kimliğine odaklanan tek sayfalık bir web sitesidir. Hafif, duyarlı (responsive) ve bakımı kolay olacak şekilde tasarlanmıştır.

Bu projede bilinçli olarak frontend framework kullanılmamıştır ve aşağıdaki teknolojiler tercih edilmiştir:

- Yapı için HTML5
- Özel stil ve görsel efektler için CSS3
- Duyarlı grid/yardımcı sınıflar için Bootstrap 5 (CDN)
- Etkileşimler ve animasyonlar için Vanilla JavaScript

## Temel Özellikler

- Mobil, tablet ve masaüstü için duyarlı düzen
- Kaydırmaya göre görsel durumu değişen yapışkan üst menü
- Küçük ekranlar için mobil menü aç/kapa davranışı
- IntersectionObserver ile bölüm görünme animasyonları
- LibreJS uyumlu JavaScript lisans bildirimi düzeni
- Kaynak dosyalara AGPLv3-or-later lisans bildirimi eklenmiş olması

## Teknoloji Yığını

- HTML: index.html
- CSS: styles.css
- JavaScript: script.js
- Arayüz yardımcıları: Bootstrap 5.3.3 (CDN)

## Proje Yapısı

- index.html: Ana sayfa işaretleme yapısı, bölümler ve LibreJS için lisans tablosu
- styles.css: Renk sistemi, düzen iyileştirmeleri, responsive kurallar ve bileşen stilleri
- script.js: Menü davranışı, scroll/görünme efektleri ve form mantığı
- LICENSE: GNU Affero General Public License v3 tam metni

## Renk ve Tasarım Yönü

Arayüz şu renk yaklaşımı üzerine kuruludur:

- Vurgu ve çağrı butonları için sarı
- Marka derinliği ve hiyerarşi için mor
- Metin dengesi ve nötr destek için gri
- Kontrast ve okunabilirlik için beyaz

Görsel stil tarafında modern bir açılış sayfası görünümü için yumuşak gradyanlar, bulanık arka plan şekilleri, yükseltilmiş kartlar ve yuvarlatılmış kontroller kullanılmıştır.

## Erişilebilirlik ve UX Notları

- Form ve gezinmede anlamsal bölümler ile etiketler kullanılmıştır
- Form geri bildirimi için `aria-live` kullanılmıştır
- Hareket hassasiyeti olan kullanıcılar için `prefers-reduced-motion` CSS kuralları eklenmiştir
- Küçük cihazlarda okunabilirlik ve dokunmatik kullanım dikkate alınmıştır

## Yerel Geliştirme

Bu projeyi herhangi bir statik HTTP sunucusu ile çalıştırabilirsiniz.

Python ile örnek:

```bash
cd /home/hwpplayer1/Public/demo/webdemos/zerodemo
python -m http.server 5500
```

Ardından açın:

- [http://localhost:5500](http://localhost:5500)
- [http://127.0.0.1:5500](http://127.0.0.1:5500)

## Üretim (Production) Notları

- Bootstrap şu an CDN üzerinden yüklenmektedir. Daha sıkı dağıtım kontrolü için bağımlılıkları sabitleyip yerelden sunabilirsiniz.
- Sayfa artık temaya uygun bir PSD Hackathon e-posta listesi bölümü ve `hackathon@procyberian.xyz` adresini gösterir.

## License

QB Networks - modern and mobile-friendly promotional website.
Copyright (C) 2026 QB Networks

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.

## Bakım Kontrol Listesi

- Tüm kaynak dosyalarda lisans başlıklarının bulunduğunu koruyun
- Hukuki inceleme olmadan LICENSE dosyasını değiştirmeyin
- UI güncellemelerinden sonra responsive davranışı tekrar test edin
- Bölüm kimlikleri veya sınıf adları değişirse JS davranışını yeniden kontrol edin

## Son Güncellemeler (2026-07-19)

- index.html, ethics.html ve coc.html üzerindeki lisans bölümlerine orijinal dilde lisans bağlantıları eklendi.
- QB Networks logosu kaynağını tüm genel sayfalarda tutarlı biçimde belirtmek için Public Domain lisans bağlantısı eklendi.
- Ethics sayfasında çift yönlü referans yapısı eklendi: alıntı işaretleri `[1]..[10]` ilgili referansa gider, referans bağlantıları da ilgili ilke kartına geri döner.
- Ethics referans metinleri, profil README yapısı ve "Back to reference N" tarzına uyumlu olacak şekilde güncellendi.
- Bağlantı dönüş hedefleri yalnızca alıntı satırına değil, tam ilke kartına yönlendirildi (başlık + paragraf + alıntı).
- Sayfa içi gezinme görünürlüğü için CSS tarafında `scroll-margin-top` ve `:target` vurgusu eklendi.
- İlkelere dönüşte daha fazla içerik görünmesi için üst gezinme çubuğunun boyutu küçültüldü.
- Lisans notları güncellenerek QB Networks logosunun Public Domain olduğu ve kaynağının Openclipart olduğu açıkça belirtildi:
	https://openclipart.org/detail/62191/semantic-social-network

## Son Güncellemeler (2026-07-19 script düzeltmesi)

- scripts/publish-release.sh, etiket parametresi verilmediğinde en güncel git etiketini otomatik kullanacak şekilde güncellendi.
- `--tag` seçeneğine ek olarak konumsal etiket desteği eklendi (`./scripts/publish-release.sh v20260719`).
- Doğrudan token verme seçenekleri eklendi: `--github-token` ve `--codeberg-token`.
- Token çözümleme akışı; CLI seçenekleri, ortam değişkenleri, git config değerleri ve gizli terminal istemi (fallback) olacak şekilde genişletildi.
- Yardım/usage çıktısı, parametresiz kullanım ve token arama sırası net olacak şekilde iyileştirildi.
