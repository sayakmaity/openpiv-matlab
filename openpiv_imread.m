function im = openpiv_imread(handles,filenum)
% openpiv_imread encapsulates all the image reading functions
% that can be imread for 'jpg','bmp', etc. or 'tiffread2' for TIFF
% images from Insight (tm) 
% Usage:
% >>  im = openpiv_imread(handles,file_number);
% >>  imshow(im);

try 
    im = imread(fullfile(handles.path,handles.files{filenum}));
catch
    tmp = tiffread2(fullfile(handles.path,handles.files{filenum}));
    im = im2double(tmp.data);
end

if length(size(im)) == 3
    im = rgb2gray(im);
end

% Custom pre-processing of images, default = 'imadjust'
preprocess = get(handles.checkbox_preprocess,'Value');
if preprocess
    prepfun = str2func(handles.preprocess);
else
    prepfun = inline('medfilt2(x)'); %default is none 
    % previous default was:
    % inline('imadjust(x)'); % default is to stretch the image
end
im = prepfun(im);