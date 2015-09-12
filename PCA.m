%This program is find the prinicipal components of images in a dataset and
%creating them using lesser vectors, and therefore saving space.
%clear previous variables

clear all;
close all;
clc;
numimg=12;
numrows= 300;
numcols= 400;
totalpixels = numrows*numcols;
imgs=zeros(totalpixels,numimg);
dataset =input('Choose dataset (toy / chair / flower) :','s');
imageformat = input('Enter image format (jpg / png):','s');
imageformat = strcat('.',imageformat);
figure(1);
hold on
for i=1:numimg
   readpath = strcat(strcat(dataset,num2str(i)),imageformat);
   rawimg=imread(strcat('imagedatasets/',readpath));
   img=imresize(rawimg, [numrows numcols]);
   img=rgb2gray(img);
   
   subplot(3,4,i), imshow(img);
   title(strcat(dataset, num2str(i)));
   imgs(:,i)=reshape(img,1,totalpixels)';
end
hold off
imgtorecons = str2num(input('Enter which image to reconstruct (1..12)','s'));
impeigvecs= str2num(input('Enter no of essential eigen vectors','s'));

meanimg=mean(imgs,2);
meandiffimg=imgs-repmat(meanimg,1,numimg);
covar = meandiffimg'*meandiffimg;
[evec1 eval1] = eig(covar);
[sortedevec sortedeval] = sortem(evec1,eval1);
basisvec1 = meandiffimg * sortedevec;
basisvec=zeros(numrows*numcols,numimg);
for j=1:numimg
   basisvec(:,j)=basisvec1(:,j)/ norm(basisvec1(:,j));
end


origimg= meandiffimg(:,imgtorecons);

numeigvecs = [1 11 impeigvecs];

figure(2);
hold on


originalimage = reshape(imgs(:,imgtorecons),numrows,numcols);
mse =[ 0, 0 ,0 , 0];
for counter=1:3
coeff=zeros(numimg,1);
coeff(1:numeigvecs(counter))= basisvec(:,1:numeigvecs(counter))' * origimg;
tempimg = basisvec*coeff;
tempimg = tempimg + meanimg;
maxval = max(tempimg);
minval = min(tempimg);
tempimg = 255 * ((tempimg - minval)/(maxval - minval));

reimg = reshape(tempimg,numrows,numcols);
%error = originalimage - reimg;
%mse(counter) = (sum(sum(error.*error))) / totalpixels;
reconsimg = uint8(reimg);

subplot(2,2,counter), imshow(reconsimg);
title(strcat(strcat('image using  ',num2str(numeigvecs(counter))),' eigen vectors'));
end

originalimage=uint8(originalimage);
subplot(2,2,4), imshow(originalimage);
title('Original Image');
hold off

