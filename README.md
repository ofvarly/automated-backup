# automated-backup
## SSH Kurulumu ve Etkinleştirilmesi
Bu başlık altında anlatılan SSH kurulumu hem Host hem de Server
olarak kullanılan iki bilgisayarda da yapılmalıdır.

SSH Kurulumu için önce sistemdeki paketlerin güncellemesi `sudo
apt update` komutu ile yapılmaktadır.

SSH’ın kurulumu için güncelleme yapıldıktan sonra `sudo apt
install openssh-server` komutu ile OpenSSH’ın kurulumu
yapılır.

![SSH Kontrolü (İnaktif)](https://github.com/user-attachments/assets/605bec77-381c-4f1f-b4f5-36855507546a)


SSH’ın kurulumu yapıldıktan sonra “sudo systemctl status
ssh” komutu ile SSH’ın aktiflik durumu kontrol edilir. Eğer
**ssh.service** başlığının altında **Active** kısmı **inactive (dead)** ise SSH
aktif değildir. Aktifleştirilmesi gerekir.

![SSH Başlatma ve SSH Kontrolü (Aktif)](https://github.com/user-attachments/assets/cdc7db7b-6b49-40df-9241-fd393a182743)


Kurulumu yapılan SSH’ı aktifleştirmek için `sudo systemctl
start ssh` komutu kullanılır. Bu komutla SSH aktifleşmiş olur.
Aktifleştirildikten sonra yeniden `sudo systemctl status ssh`
komutu ile SSH’ın aktiflik durumu kontrol edilirse, **ssh.service**
başlığının altında yer alan **Active** kısmının **active (running)** olduğu
görülecektir. Bu da demektir ki SSH aktif bir şekilde çalışıyor.

## Güvenlik Duvarına SSH 22 Portunun Eklenmesi
Bu başlık altında anlatılan güvenlik duvarına SSH 22 portunun
eklenmesi hem Host hem de Server olarak kullanılan iki bilgisayarda da
yapılmalıdır.

![Güvenlik Duvarı Kontrolü](https://github.com/user-attachments/assets/132db32a-e32b-4861-bb13-8d38393e0f6e)


Öncelikle güvenlik duvarının durumu kontrol edilmelidir. Bunun için
`sudo ufw status` komutu kullanılır. Bu komut UFW
(Uncomplicated Firewall) yani güvenlik duvarının durumunu kontrol
etmeye yarar. Bu komudun çıktısı **Status: inactive** ise UFW aktif
değildir. Aktifleştirilmesi gerekir ve SSH portunun (22) güvenlik
duvarına kural olarak eklenip izin verilmesi gerekmektedir.

![Güvenlik Duvarının Aktifleştirilmesi](https://github.com/user-attachments/assets/14760feb-d5be-4936-9a0b-e94ac3f93e6a)


`sudo ufw enable` komutu ile güvenlik duvarı aktifleştirildi.
Bu aşamadan sonra geriye SSH portunun kural olarak eklenmesi kaldı.

![Güvenlik Duvarına SSH Portunun Eklenmesi](https://github.com/user-attachments/assets/f8029d3c-b9f4-4342-b829-975dda98768c)


`sudo ufw allow ssh` komutu ile güvenlik duvarına SSH’ın
kullanmış olduğu 22 portu kural olarak eklendi. Artık güvenlik duvarı 22
portu üzerinden gerçekleşen trafiğe izin verecek duruma getirildi. Eğer
ki daha sonra bu port kapatılmak istenirse `sudo ufw deny ssh`
komutu kullanılır. Bu komut SSH için eklenen kuralları kaldırır.

## SSH Private ve Public Key Oluşturulması
SSH Private ve Public Key oluşturmak için yapılacak işlemler eğer
Host bilgisayardan Server bilgisayara bir yedekleme işlemi yapılacaksa
Host bilgisayardan yapılmalıdır.

SSH key oluşturmak için:

- `ssh-keygen -t rsa`

![SSH Anahtarlarının Oluşturulması](https://github.com/user-attachments/assets/79a04cbd-6e05-4b8f-89e9-edb981470360)


`ssh-keygen -t rsa` komutu ile RSA algoritmasıyla
şifrelenen bir private key ve public key çifti oluşturulur. Komut
çalıştığında anahtarın kaydedileceği dosya yolu gösterilir. Gösterilen
dosya yolu onaylanırsa ENTER tuşuna basılır. Sonraki aşamada
anahtarların güvenlik seviyesini artırmak için kullanıcıdan “passphrase”
girişi istenir. Eğer belirlenmek istenmezse direkt olarak ENTER tuşuna
basılıp geçilebilir. En son aşamada key için bir **fingerprint** ve
**randomart image** da oluşturulduktan sonra anahtar oluşturma kısmı
tamamlanır.

![**.ssh** Klasörünün Oluşumu](https://github.com/user-attachments/assets/45942dab-f161-4a9d-b5e8-816f29f375de)


Anahtar çifti oluşturulduktan sonra `ls -al` komutu ile detaylı
olarak bulunan dizindeki dosya ve klasörler görüntülendiğinde **.ssh**
isimli bir klasör olduğu görülür. Bu klasör az önce RSA algoritması ile
oluşturulan anahtar çiftinin bulunduğu klasördür.

![**.ssh** Klasöründeki Anahtarların Oluşumu](https://github.com/user-attachments/assets/f9382766-55a5-4161-995f-9866f22ffd8a)


Klasörün içine girilip yeniden `ls -al` komutu ile
görüntülendiğinde görülecektir ki **id_rsa** ve **id_rsa.pub** adında iki
adet dosya var. Bu dosyalardan ilki yani **id_rsa** dosyası, private key
dosyasıdır. Diğeri de uzantısından da anlaşılacağı gibi public key
dosyasıdır.

## Public Key’in Server Cihaza Kopyalanması
Public key’in oluşturulduktan sonra hedef cihaza kopyalanması
gerekir.
Oluşturulan public key’i hedef cihaza konfigüre etmek için öncelikle
hedef cihazın IP adresinin bilinmesi gerekmektedir.

Hedef cihazın IP adresini öğrenmek için hedef cihazda `ifconfig`
komutu kullanılabilir.

Public key’i hedef cihaza konfigüre etmek için `ssh-copy-id`
komutu kullanılır. Komut çalıştığında kullanıcıdan bağlanılmak
istendiğine dair bir doğrulama istenir. Bu doğrulamaya **yes**, **no** ya
da anahtarlar oluşturulurken oluşturulan fingerprint ile cevap verilebilir.
Sonrasında da kullanıcıdan hedef cihazın şifresi istenir. Bu işlem
yapılırken hedef cihazın şifresinin de bilinmesi gerekir.

![Public Key’in Hedef Cihaza Kopyalanması](https://github.com/user-attachments/assets/b9630128-3b63-4e83-94ea-a33338c8d722)


İşlem gerçekleştikten sonra hedef cihazda **.ssh** klasörü içinde
bulunan **authorized_keys** dosyasının içine bakıldığında Host cihazdaki
public key olduğu görülür.

Public key, Server cihazda doğrulama için konfigüre edildiğinde,
hedef cihaz kullanıcı tarafından sağlanan private key ile eşleşen bir
private key ile eşleşip eşleşmediğini kontrol eder. Eğer eşleşirse, kimlik
doğrulaması başarılı olur ve kullanıcı hedef cihaza erişebilir.

## Host ve Hedef Cihazda Yedekleme Klasörlerinin Oluşturulması
Host cihazdan hedef cihaza yedekleme yapılacağından host cihazında
yedeklenecek dosyaların bulunduğu bir klasör, hedef cihazda ise
dosyaların yedekleneceği bir klasör bulunması gerekir. Öncelikle host
cihazda:

- `mkdir directory-ismi`
komutu ile bir directory oluşturulur. Aynı işlem hedef
cihazda da gerçekleştirilir.

Host cihazda yedeklenmesi istenen dosyalar belirlenen klasörün
içinde oluşturulur ya da o klasöre taşınır.

## rsync ile SSH Üzerinden Backup Scriptinin Oluşturulması
Gereken klasörler ve yedeklenmesi istenen dosyalar uygun duruma
getirildikten sonra `rsync` komutu ile bu dosyaların hedef cihazda
remote olarak yedeklenmesi için bir script yazılır.

Öncelikle incremental backup için `nano backup_script.sh`
komutu ile bir script dosyası oluşturulur ve düzenleme moduna girilir.

**backup-script.sh** scriptinin içinde **full_backup** ve
**incremental_backup** olmak üzere 2 adet fonksiyon var. Bu
fonksiyonlardan **full_backup** olan adından da anlaşılacağı üzere bütün
dosyaları yedekler. Diğer fonksiyon da **incremental** yani sadece
değişen dosyaları hedef cihaza yedekler.

Full Backup için kullanılan komut:
- `rsync -avzP --delete-e “ssh -i ~/.ssh/id_rsa”
backup/ hedef-kullanici-adi@hedef-ip:backup-server/`

Bu komut satırında rsync’in aldığı opsiyonlar şu şekildedir:
- **-a:** Arşiv modu.
- **-v:** Ayrıntıları görüntüleme.
- **-z:** Dosyaları sıkıştırma.
- **-P:** İşlemi ekranda gösterme
- **--delete:** Kaynak dizinindeki dosyaların veya dizinlerin
artık mevcut olmadığı durumlarda, hedef dizinden bu dosyaların
veya dizinlerin de silinmesini sağlar. Yani, eğer kaynak
dizininde bir dosya silinirse, rsync bu dosyayı hedef dizinden de
siler.

Incremental Backup için kullanılan komut:
- `rsync -avzP --delete -e –-link-
dest=”hedef-kullanici-adi@hedef-ip:full-backup-
server/” “ssh -i ~/.ssh/id_rsa” backup/
hedef-kullanici-adi@hedef-ip:backup-server/`

Bu komut satırında rsync ’in aldığı parametreler şu şekildedir:
- **--link-dest:**
Yedeklemeyi yaparken **hedef-kullanici-adi@hedef-ip:full-backup-server/** dizinini referans alır.
Bu sayede, sadece önceki tam yedekleme ile değişen veya eklenen
dosyaların kopyalanmasını sağlar, böylece disk alanından ve
işlemci kaynaklarından daha verimli bir şekilde yararlanır.

Full Backup komutu çalıştıktan sonra ekrana gelen çıktı:
![Full Backup Scriptinin Çalıştırılması](https://github.com/user-attachments/assets/a2deaa8f-fa2b-4a5b-bd1a-79209b8bd888)


![Incremental Backup Scriptinin Çalıştırılması](https://github.com/user-attachments/assets/3d236edd-27b6-4cde-ad71-7d3c06796ad1)


Bu script **full** ve **inc** olmak üzere iki farklı parametre ile anlık
olarak çalıştırılabilir. Bu işlem zaman ayarlı olarak yapılmak istenirse
cron kullanılabilir.

## cron ve crontab ile Yedekleme İşleminin Zamana Göre Gerçekleştirilmesi

Yedekleme işleminin cron ile zaman ayarlı olarak gerçekleşmesi için
crontab üzerinde düzenlemeler yapılmalıdır. crontab’e erişmek için
`crontab -e` komutu kullanılır.

![Scriptlerin crontab’e Eklenmesi ve Zamana Bağlı Çalıştırılması](https://github.com/user-attachments/assets/51238c92-1602-4d9c-b43f-1d18be3cc169)


Zamana bağlı olarak çalıştırılması istenen komutlar bu tablonun sonuna
eklenir. Burada çalıştırılacak olan script az önce oluşturulan
**backup_script.sh** dosyası. cron ile zamana bağlı olarak
çalıştırmak için:

- `*/5 * * * * ./backup_script.sh full`
- `* * * * * ./backup_script.sh inc`

komutları kullanılır. buradaki asterisk işaretleri zaman dilimlerini ifade
eder. Sırasıyla:

- Dakika
- Saat
- Ayın günü
- Ay
- Haftanın günü

şeklindedir. Eğer asteriskler yerine herhangi bir sayı yazılmazsa (ilk
satırda olduğu gibi) script her dakikada çalışır. İkinci satırda yazan “*/5”
ifadesi de scriptin her 5 dakikada bir çalışacağını ifade eder.

## Alınan Yedeklerin Farklı Klasörlere Yazılması ve Log Dosyasının Oluşturulması

Yukarıda gösterilen örnekte alınan tam ve artımlı (full ve backup)
dosya yedekleri tek bir klasöre yazılır. Bu durumda yeni alınan dosya
yedeği önceki yedeğin üzerine yazılır. Böyle bir durum söz konusu
olduğunda önceki yedeklere ulaşmak imkansızdır. Bunun önüne geçmek
için çözümlerden biri her alınan tam ve artımlı yedeği tarihlerini
belirterek farklı klasörlere almaktır.

Bir başka karşılaşılacak sorun da eğer bu yedeklemeler “crontab” ile
zamana bağlı olarak alınıyorsa -ki burada öyle alınıyor- zamanı
geldiğinde yedekleme scripti çalıştığı zaman terminal ekranına herhangi
bir çıktı gelmez. Bu durumda yedeklemenin bir sorun oluştuğu ve
gerçekleşmediği durumda olaydan haberdar olunamaz. Bilgilendirme
için yapılan işlemlerin kayıtlarının (log) tutulması gerekmektedir.
Bahsedilen sorunların çözümleri önceki scripte ekleme yapılarak sağlanmıştır.

Kodun temiz görünmesi açısından bazı değişkenler tanımlandı. Bu
değişkenler şunlardır:

- **LOGFILE:** İşlemlerin gerçekleşip gerçekleşmediğini, herhangi
bir sorunla karşılaşıldığında oluşan sonucun yazıldığı kayıt
dosyası.
- **TIMESTAMP:** Yedekleme gerçekleştiği andaki zaman. (Yıl-
Ay-Gün-Saat-Dakika-Saniye formatında)
- **REMOTE_DIR:** Hedef cihazda yedeklemenin yapılacağı
klasör. Yedekleme türüne göre **full_ZAMAN** veya **inc_ZAMAN**
şeklinde klasörler isimlendirilir.
- **LATEST_FULL_BACKUP:** Artımlı (incremental) yedekleme
yapılacağı zaman referans gösterilecek son tam (full) yedeklemenin
yapıldığı klasör.
Burada yedeklemenin gerçekleşip gerçekleşmediği **if condition** ile
kontrol edilir. Kullanılan koşul:

- `if [ $? -eq 0 ];`

**$?** ifadesi shell’de en son çalıştırılan
komutun başarı ile çalışıp çalışmadığını gösterir. Eğer ki **$?**
komutunun çıktısı 0 ise bir önceki komut başarı ile çalışmış, 0’dan farklı
bir değer ise başarısız bir şekilde çalışmış demektir.

Eğer bir önceki komut yani “rsync” komutu başarılı bir şekilde
çalıştıysa:

- `echo ${TIMESTAMP}: X backup başarıyla
tamamlandı.`

Burada yukarıda tanımlanan değişken **${}** ifadesinin içine
yerleştirilerek yerine yazıldı. Böylelikle o andaki zaman çekilmiş oldu.
Bu komutla da eğer backup gerçekleştiyse komutun sonundaki `>>
$LOGFILE` ifadesiyle bu metin log dosyasına eklenmiş oldu.

![Komutlar çalıştıktan sonraki durumların log dosyasında gösterilmesi.](https://github.com/user-attachments/assets/3f89a9c6-a378-4ecd-bf92-2220840aa543)

Burada komut çalıştıktan sonra **log.txt** dosyasına aktarılmış örnek
bir çıktı verilmiştir.

Aksi durumda, yani `rsync` komutu çalışırken bir hata meydana
geldiyse **log.txt** dosyasına komutun çalıştırıldığı zaman ve
`${TIMESTAMP}: X backup HATA!` metni eklenir.

Yedekleme alınırken aynı zamanda `mkdir -p
${REMOTE_DIR}` ile hedef cihazda belirlenen bir dizin içinde her bir
yedekleme için bir dizin oluşturulur. Böylelikle her yedekleme farklı bir
klasöre alınır ve gerektiği durumda önceki yedeklemelere de ulaşılabilir.

Artımlı (incremental) yedeklemede **LATEST_FULL_BACKUP**
değişkeni hedef cihazda alınan son tam (full) yedeklemeyi belirtir. Son
tam yedeklemeyi de bulmak için hedef cihazda:
- `ls -t $HOME/full-backup-server/full_* | head -1`
Komutu kullanılır. Burada ls -t ile dosyalar en son değişiklik yapılan
en başta olacak şekilde dosyaların listelenmesi sağlanır. Listelenen
dosayalarda **full_*** ifadesi ile bütün tam yedeklemeler listelenir. `head
-1` komutu ile de en başta bulunan yani en son yapılan tam yedekleme
klasörünü seçer.

## Veri Tabanlarının Dump’ının Alınması ve Yedeklenmesi
Veri tabanlarının yedeklerinin alınması için önce dump’larının
alınması gerekir. Dump veri tabanının dosyada tutulan haline denir.
Dosya yedekleme scriptinde olduğu gibi burada da alınan her tam ve
artımlı yedek farklı klasörlere yazılır ve oluşan sonuçlar bir log
dosyasında tutulur.

Önceki scripte ek olarak veri tabanlarının dump’ının alınması
eklenmiştir. Dump almak için `mysqldump` komutu kullanılır. Alınan
dumplar **DUMP_DIR** değişkeninde tanımlanan dizinde tutulur ve
uzantıları **.sql** şeklindedir. Bu işlemleri gerçekleştirebilmek için
terminalde MySQL’in kurulu olması gerekmektedir. Bunun için de
`sudo apt install mysql` komutu kullanılabilir. Dump
dosyasının isimlendirilmesi için de **veri_tabanı_adı_ZAMAN.sql**
formatında bir isimlendirme yapılır. Dump almak için kullanılan komut:

- `mysqldump -u $DB_USER $DB_NAME > $DUMP_FILE`

şeklindedir. Dump alındıktan sonra önceki işlemlerde olduğu gibi “if
condition” kullanarak “$?” ifadesi ile önceki işlemin başarı ile çalışıp
çalışmadığı kontrol edilir. Duruma göre log dosyasına oluşan sonucun
çıktısı yazılır.

Bütün bu işlemler dışında kalan her şey önceki scriptlerle aynıdır. Eğer
ki bu işlemler de zamana bağlı olarak çalıştırılıp tamamen otomatik bir
sistem yapılmak istenirse aynı şekilde crontab kullanılıp şu şekilde
yazılabilir:

- Öncelikle `crontab -e`

Sonrasında ise:
-  `*/5 * * * * ./backup_script.sh full`

- `* * * * * ./backup_script_db.sh inc`
