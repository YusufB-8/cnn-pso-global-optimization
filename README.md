# cnn-pso-global-optimization
CNN tabanlı vekil modelleme ve Parçacık Sürü Optimizasyonu ile global optimizasyon sistemi (MATLAB)
# CNN Tabanlı Global Optimizasyon Sistemi (CNN + PSO)

Bu proje, sezgisel optimizasyon yöntemleri ile derin öğrenme modellerini birleştirerek karmaşık matematiksel fonksiyonların global minimum ve maksimum noktalarını bulmayı amaçlamaktadır.

## Proje Amacı

Klasik optimizasyon yöntemleri karmaşık yüzeylerde yerel minimumlara takılabilir.  
Bu çalışmada:

- CNN modeli fonksiyon davranışını öğrenir (Surrogate Model)
- PSO algoritması öğrenilen yüzey üzerinde global arama yapar

Böylece optimizasyon süresi ciddi şekilde azaltılır.

---

## Kullanılan Teknolojiler

- MATLAB
- Deep Network Designer
- Convolutional Neural Networks (CNN)
- Particle Swarm Optimization (PSO)
- Surrogate Modeling

---

## Sistem Mimarisi

1. Kullanıcı matematiksel denklem girer
2. Sistem veri üretir
3. CNN modeli eğitilir
4. Eğitilen ağ PSO algoritmasına bağlanır
5. Global optimum grafik üzerinde gösterilir

---

## Uygulama Adımları

```matlab
run main.m
