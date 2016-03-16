function [my_img,my_img2] = read_images(mDir,myDir2,ext_img)

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