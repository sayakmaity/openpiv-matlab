a = imread('/Users/alex/Desktop/rontest/test_average/21042015_LLK_exp1_Scene29_1-DVR Express CLFC_0627.jpg');
b = imread('/Users/alex/Desktop/rontest/test_average/21042015_LLK_exp1_Scene29_1-DVR Express CLFC_0628.jpg');
figure, imshow([a,b],[])

[a2,rect] = imcrop(a);
b2 = imcrop(b,rect);

newrect = rect;
newrect(3:4) = newrect(3:4)*2;
newrect(1) = newrect(1) - ceil(rect(3)/2);
newrect(2) = newrect(2) - ceil(rect(4)/2);

figure, imshow(b); rectangle('position',rect);
hold on
rectangle('position',newrect)

b3 = imcrop(b,newrect);

imwrite(a2,'a2.jpg');
imwrite(b2,'b2.jpg');
imwrite(b3,'b3.jpg');