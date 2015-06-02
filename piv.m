function  [res,no_filt_res,filt_res,numrows,numcols] = piv(a1,b1,ittWidth,ittHeight,ovlapHor,ovlapVer,s2ntype,s2nl,origin,outl,sclt,dt,hObject)
% runs all the openpiv stuff

[verSize,horSize]= size(a1);

% Prepare the results storage;
numcols = floor((horSize-ittWidth)/ovlapHor+1);
numrows = floor((verSize-ittHeight)/ovlapVer+1);
res = zeros(numcols*numrows,5);
resind = 0;

NfftWidth = 2*ittWidth;
NfftHeight = 2*ittHeight;


for m = 1:ovlapVer:verSize - ittHeight + 1 % vertically
    for k = 1:ovlapHor:horSize-ittWidth+1 % horizontally
        if (get(hObject,'UserData') == 1)
            a2 = a1(m:m+ittHeight-1,k:k+ittWidth-1);
            b2 = b1(m:m+ittHeight-1,k:k+ittWidth-1);
            
            %                         a2 = prepfun(a2);
            %                         b2 = prepfun(b2);
            
            c = cross_correlate_rect(a2,b2,NfftHeight,NfftWidth);
            % c = cross_correlate_rect(a2,b2,Nfftx,Nffty);
            if ~any(c(:)), % completely "black"
                u = 0;
                v = 0;
                y = origin(2) + m + ittHeight/2 - 1;
                x = origin(1) + k + ittWidth/2 -  1;
                resind = resind + 1;
                s2n = 0;
                res(resind,:) = [x y u v s2n];
                continue
            end
            
            [peak1,peak2,pixi,pixj] = find_displacement_rect(c,s2ntype);
            
            [peakVer,peakHor,s2n] = sub_pixel_velocity_rect(c,pixi,pixj,peak1,peak2,s2nl,ittWidth,ittHeight);
            
            % Scale the pixel displacement to the velocity
            u = (ittWidth-peakHor);
            v = (ittHeight-peakVer);
            y = origin(2) + m + ittHeight/2-1;
            x = origin(1) + k + ittWidth/2-1;
            
            resind = resind + 1;
            res(resind,:) = [x y u v s2n];
            % quiver(x+cropvec(1),y+cropvec(2),u,v,'y');
            if u ~= 0 || v ~= 0
                %                             quiver(x,y,u,v,5,'y','Linewidth',1);
                %                             drawnow;
                plotarrow(x,y,u,v,'g',10);
                % drawnow
            end
        end
    end
end



% NO_FILT_RES will be stored in '.._noflt.txt' file at the end of program
no_filt_res = res;



% Reshape U and V matrices in two-dimensional grid and produce
% velocity vector in U + i*V form (real and imaginary parts):

u = reshape(res(:,3), numrows,numcols);
v = reshape(res(:,4), numrows,numcols);
vector = u + sqrt(-1)*v;

% Remove outlayers - GLOBAL FILTERING
vector(abs(vector)>mean(abs(vector(vector~=0)))*outl) = 0;
u = real(vector);
v = imag(vector);

% Adaptive Local Median filtering

kernel = [-1 -1 -1; -1 8 -1; -1 -1 -1];
tmpv = abs(conv2(v,kernel,'same'));
tmpu = abs(conv2(u,kernel,'same'));

% WE HAVE TO DECIDE WHICH LIMIT TO USE:
% 1. Mean + 3*STD for each one separately OR
% 2. For velocity vector length (and angle)
% 3. OR OTHER.

lmtv = mean(tmpv(tmpv~=0)) + 3*std(tmpv(tmpv~=0));
lmtu = mean(tmpu(tmpu~=0)) + 3*std(tmpu(tmpu~=0));

u_out = find(tmpu>lmtu);
v_out = find(tmpv>lmtv);

% Let's throw the outlayers out:
u(u_out) = 0; u(v_out) = 0;
v(v_out) = 0; v(u_out) = 0;
vector = u + sqrt(-1)*v;

res(:,3) = reshape(real(vector),numrows*numcols,1);
res(:,4) = reshape(imag(vector),numrows*numcols,1);

% Filtered results will be stored in '.._flt.txt' file
filt_res = res;

vector = fill_holes(vector,numrows,numcols);
res(:,3) = reshape(real(vector),numrows*numcols,1);
res(:,4) = reshape(imag(vector),numrows*numcols,1);


