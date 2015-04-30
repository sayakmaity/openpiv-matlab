a = imread('a2.jpg');
b = imread('b2.jpg');
lb = imread('b3.jpg');


a2 = a;
b2 = b;

figure, imshow(imadjust([a2,b2]))

figure, imshow(imadjust([medfilt2(a2,[5 5]),medfilt2(b2,[5 5])]))

cc = normxcorr2(b2,a2);
figure, mesh(cc)

fastpeakfind_plot(cc);


% filter, subtract the mean

a2 = medfilt2(a,[5 5]);
b2 = medfilt2(b,[5 5]);

cc = normxcorr2(a2-mean2(a2),b2-mean2(b2));
figure, mesh(cc)

out = fastpeakfind_plot(cc);

% for search in a large window

% filter, subtract the mean

a2 = medfilt2(a,[15 15]);
b3 = medfilt2(lb,[15 15]);

cc = normxcorr2(a2-mean2(a2),b3-mean2(b3));
figure, mesh(cc)

fastpeakfind_plot(cc);



% fast template matching based on SSD

% Find maximum response
%    I = im2double(imread('lena.jpg'));
%   % Template of Eye Lena
%    T=I(124:140,124:140,:);
%   % Calculate SSD and NCC between Template and Image
%    [I_SSD,I_NCC]=template_matching(T,I);
%   % Find maximum correspondence in I_SDD image
%    [x,y]=find(I_SSD==max(I_SSD(:)));
%   % Show result
%    figure, 
%    subplot(2,2,1), imshow(I); hold on; plot(y,x,'r*'); title('Result')
%    subplot(2,2,2), imshow(T); title('The eye template');
%    subplot(2,2,3), imshow(I_SSD); title('SSD Matching');
%    subplot(2,2,4), imshow(I_NCC); title('Normalized-CC');
% T = a2; I = b3;
% [I_SSD,I_NCC]=template_matching(T,I);
% [x,y]=find(I_SSD==max(I_SSD(:)));
% % Show result
% figure,
% subplot(2,2,1), imshow(I); hold on; plot(y,x,'r*'); title('Result')
% subplot(2,2,2), imshow(T); title('The eye template');
% subplot(2,2,3), imshow(I_SSD); title('SSD Matching');
% subplot(2,2,4), imshow(I_NCC); title('Normalized-CC');

% highly reduced resolution to remove the mean shift
% T = medfilt2(a2,[15 15]); I = medfilt2(b3,[15 15]);
% [I_SSD,I_NCC]=template_matching(T,I);
% [x,y]=find(I_SSD==max(I_SSD(:)));
% % Show result
% figure,
% subplot(2,2,1), imshow(I); hold on; plot(y,x,'r*'); title('Result')
% subplot(2,2,2), imshow(T); title('The eye template');
% subplot(2,2,3), imshow(I_SSD); title('SSD Matching');
% subplot(2,2,4), imshow(I_NCC); title('Normalized-CC');

% highly reduced resolution to remove the mean shift
% H = fspecial('unsharp',0.8);
% T = imfilter(a2,H); I = imfilter(b3,H);
% [I_SSD,I_NCC]=template_matching(T,I);
% [x,y]=find(I_SSD==max(I_SSD(:)));
% % Show result
% figure,
% subplot(2,2,1), imshow(I); hold on; plot(y,x,'r*'); title('Result')
% subplot(2,2,2), imshow(T); title('The eye template');
% subplot(2,2,3), imshow(I_SSD); title('SSD Matching');
% subplot(2,2,4), imshow(I_NCC); title('Normalized-CC');

