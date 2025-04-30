math.randomseed(os.time())

local haritaBakmaSayisi = 0

local oyuncu = {
    can = 3,
    envanter = {},
    bolum = 1,
    harita = {}
}

local function esyaEkle(esya)
    if not oyuncu.envanter[esya] then
        oyuncu.envanter[esya] = true
        print("-> '" .. esya .. "' envantere eklendi.")
    end
end

local function esyaVar(esya)
    return oyuncu.envanter[esya] == true
end

local function bolumEkle(ad)
    oyuncu.harita[ad] = true
end

local function sans()
    return math.random() < 0.5
end

local bolumler = {
    [1] = {
        ad = "Orman Girisi",
        metin = "Ormanda uyaniyorsun. Gizemli bir kutu var. Kutuyu acmak icin '1', acmadan ierlemek icin '2'.",
        secimler = {
            ["1"] = function()
                if not esyaVar("sopa") then
                    print("-> Kutudan 'sopa' cikti. Tebrikler cnm. Ilerliyorusss...")
                    esyaEkle("sopa")
                else
                    print("-> Zaten sopan var. Ilerliyorsun...")
                end
                return 2  -- otomatik olarak kulubeye gitsin
            end,
            ["2"] = function()
                     print("-> Kutuda 'sopa' vardi slk kacirdin. Ilerliyoruz...")
                return 2
            end
        }
    },
    
   [2] = {
    ad = "Kulube",
    metin = "Bir kulübeye geldin. İçeride yaşlı bir adam var. Konuşmak için '1', geçmek için 'banane moruq'. yaz",
    secimler = {
        ["1"] = function()
            if konusmaYapildi then
                return 3  -- artık bir sonraki bölüme geç
            else
                konusmaYapildi = true
                print("Yaşlı Adam: 'Eğer kılıcı bulursan, tapınağı açabilirsin.'")
                return 3  -- ilk defa konuştuysan tekrar bu bölüme dön
            end
        end,
        ["banane moruq"] = function()
            if konusmaYapildi then
                return 3
            elseif not uyarildi then
                print("Yerinde olsam bu ipucunu kaçırmazdım cmm. Sana bir şans daha veriyorum.")
                uyarildi = true
                return 2
            else
                return 3
            end
        end
    }
},

    
    [3] = {
        ad = "Magara",
        metin = "Magarada canavar var! Onu yenersen kilici alabilirsin. Saldir icin '1', kacmak icin '2'.",
        secimler = {
            ["1"] = function()
    
                if esyaVar("sopa") and sans() then
                    print("Canavari yendin ve kilici aldin, müq bir savascisin!")
                    esyaEkle("kilic")
                    return 4
                else
                    oyuncu.can = oyuncu.can - 1
                    print("Canavar cok guclu cnm! Yaralandin! Kalan can: " .. oyuncu.can)
                    return oyuncu.can > 0 and 3 or 0  -- Eğer can biterse oyun biter
                end
            end,
            ["2"] = function()
                print("Evine dön, görevin bitti, seni korkak!")
                return 1  
            end
        }
    },
    

    


[4] = {
    ad = "Tapinak Kapisi",
    metin = "Tapinaga geldin. Girmek icin '1', haritayi gormek icin '2'.",
    secimler = {
        ["1"] = function()
            if esyaVar("kilic") then
                return 6
            else
                return 7
            end
        end,
        ["2"] = function()
            haritaBakmaSayisi = haritaBakmaSayisi + 1
            
            if haritaBakmaSayisi <1.1 then
            print("Gezdiğin yerler:")
            for yer in pairs(oyuncu.harita) do
                print("- " .. yer)
            end
        end

            if haritaBakmaSayisi > 1 and haritaBakmaSayisi < 2.1 then
                print("   KAPİYİ AC ARTİK!!!!")
                end
            if haritaBakmaSayisi>2 then
                print("   Bunu sen istedin slk")
                return 0
            end

            return 4
        end
        }
    },

    [6] = {
        ad = "TEBRİKLEEER",
        metin = "Kutsal tasi buldun. Kralligi kurtardin! Tebrikler guclu kahramanim!",
        secimler = {}
    },
    [7] = {
        ad = "BECERİKSİZSİN",
        metin = "Hazirliksizdin ve tapinakta tuzaklara yakalandin. GO AWAY!",
        secimler = {}
    },
    [0] = {
        ad = "THE END",
        metin = "Oyun bitti cnm. Sorryyy",
        secimler = {}
    }
}

local function oyun()
        while true do
            local b = oyuncu.bolum
            local bolum = bolumler[b]
    
            bolumEkle(bolum.ad)  -- 🔹 Yeni bölüme girildiğinde haritaya ekle
    
            print("\n📍 " .. bolum.ad)
            print(bolum.metin)
    
            if next(bolum.secimler) == nil then
                break
            end
    
            print("Secenekler:")
            local secenekler = {}
            for sec in pairs(bolum.secimler) do
                table.insert(secenekler, sec)
            end
            table.sort(secenekler)  -- alfabetik/rakam sırası
            
            for _, sec in ipairs(secenekler) do
                print("- " .. sec)
            end
            
            io.write("Seciminiz: ")
            local input = io.read()
    
            local secimFonks = bolum.secimler[input]
            if secimFonks then
                oyuncu.bolum = secimFonks()
            else
                print("Gecersiz secim.")
            end
        end
    end
    


oyun()
