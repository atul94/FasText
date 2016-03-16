myDir = 'C:/Users/Atul Agarwal/Desktop/btp1/papers/1/MRRCTrainImages/';
myDir2 = 'C:/Users/Atul Agarwal/Desktop/btp1/papers/1/MRRCTestImages/';
ext_img = '*.JPG';
a = dir([myDir ext_img]);
nfile = max(size(a)) ;
b = dir([myDir2 ext_img]);
nfile2 = max(size(b));
for i=1:nfile
  my_img(i).img = imread([myDir a(i).name]);
end

for i=1:nfile2
  my_img2(i).img = imread([myDir2 b(i).name]);
end