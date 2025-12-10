-- Insert Dummy Trash Bins (Telkom University Area)
INSERT INTO public.trashbin (location_name, latitude, longitude, capacity, type) VALUES
('Gedung Bangkit (TULT)', -6.9730, 107.6295, 'empty', 'organic'),
('Gedung Bangkit (TULT)', -6.9731, 107.6296, 'half', 'inorganic'),
('GKU 1 (Gedung Tokong Nanas)', -6.9755, 107.6305, 'full', 'organic'),
('GKU 1 (Gedung Tokong Nanas)', -6.9756, 107.6306, 'empty', 'inorganic'),
('Asrama Putra', -6.9765, 107.6285, 'half', 'organic'),
('Asrama Putri', -6.9725, 107.6315, 'empty', 'organic'),
('Kantin Engineering', -6.9740, 107.6320, 'full', 'inorganic'),
('Rectorate Building', -6.9744, 107.6303, 'empty', 'organic'),
('Gate 1', -6.9720, 107.6280, 'half', 'inorganic'),
('Gate 2', -6.9770, 107.6330, 'empty', 'organic');

-- Insert Dummy Education Content
INSERT INTO public.education (title, body, image) VALUES
('Cara Memilah Sampah Organik', 'Sampah organik adalah sampah yang berasal dari sisa mahkluk hidup yang mudah terurai secara alami tanpa proses campur tangan manusia untuk dapat terurai. Contohnya adalah sisa makanan, kulit buah, dan daun kering. Sampah ini sebaiknya dikubur atau dijadikan kompos.', 'https://images.unsplash.com/photo-1595278069441-2cf29f525a3c?auto=format&fit=crop&q=80&w=800'),
('Bahaya Sampah Plastik', 'Sampah plastik membutuhkan waktu ratusan tahun untuk terurai. Plastik yang dibuang sembarangan dapat mencemari tanah dan laut, serta membahayakan hewan. Kurangi penggunaan plastik sekali pakai dengan membawa tas belanja sendiri dan botol minum.', 'https://images.unsplash.com/photo-1618477461853-581335fc063f?auto=format&fit=crop&q=80&w=800'),
('Mengenal 3R (Reduce, Reuse, Recycle)', '3R adalah prinsip utama dalam pengelolaan sampah. Reduce berarti mengurangi segala sesuatu yang mengakibatkan sampah. Reuse berarti menggunakan kembali sampah yang masih dapat digunakan untuk fungsi yang sama ataupun fungsi lainnya. Recycle berarti mengolah kembali (daur ulang) sampah menjadi barang atau produk baru yang bermanfaat.', 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?auto=format&fit=crop&q=80&w=800'),
('Tips Mengompos di Rumah', 'Kompos adalah pupuk organik buatan manusia yang dibuat dari proses pembusukan sisa-sisa buangan makhluk hidup (tanaman maupun hewan). Anda bisa membuat kompos sendiri di rumah menggunakan ember bekas dan sisa sayuran dapur.', 'https://images.unsplash.com/photo-1589335607062-1065c71b6973?auto=format&fit=crop&q=80&w=800');
