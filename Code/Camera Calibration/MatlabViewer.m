function varargout = MatlabViewer(varargin)
% MATLABVIEWER M-file for MatlabViewer.fig
 
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MatlabViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @MatlabViewer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
 
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
  
% --- Executes just before MatlabViewer is made visible.
function MatlabViewer_OpeningFcn(hObject, eventdata, handles)
 
handles.output = hObject;
guidata(hObject, handles);
 
global xcursor;
global ycursor;
global count;
global i;
global j;
global rgb_means_ref;                 % the rgb values of the original color checker chart
global mybox;                         % the area of the segmented boxes
global mysorted;                      % the order of the color squares in the checker chart
global mycell;                        % stores the error each time
global param;                         % has all the paramter combinations
global step1;                         % paramteres downsampled to step1
global step2;                         % paramteres further downsampled to step2 around the found minima 
global myend
global err1

% err1=0;
xcursor=0;
ycursor=0;
count=1;
step1=32;
step2=2;
i=0;
j=-floor(step1/step2);
myend=1;
load rgb_means_ref_new
mybox=zeros(24,4);
mysorted=zeros(24,1);
load mycellmat
load param
 
handles.activex1.Camera=0;
handles.activex1.ExposureAuto='Once';
handles.activex1.GainAuto = 'Continuous';
handles.activex1.BlackLevelRaw=64;
handles.activex.Gamma=1;
 
handles.BalanceRatioSelector='Red';
handles.activex1.BalanceRatioAbs=2;
handles.activex1.ScrollBars=true;
handles.activex1.AcquisitionMode='Continuous';
handles.activex1.Acquire=true;
 
% --- Outputs from this function are returned to the command line.
function varargout = MatlabViewer_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;
 
% --------------------------------------------------------------------
 
 
function activex1_FrameAcquired(hObject, eventdata, handles)
 
        tic;
        tstart=tic;

        global count;
        global i;
        global j;
        global mycell;
        global param;
        global mybox
        global mysorted
        global step1
        global step2
        global xcursor;
        global ycursor;
        global myend
        global err1

        sizex=handles.activex1.SizeX;
        sizey=handles.activex1.SizeY;
       %% graphs in the gui 
        w=48;   %3d-window size
        Z=zeros(w,w);
        maxpix=pow2(handles.activex1.GetBitsPerChannel());
        x=0:sizex-1;
        y=0:sizey-1;
        RGB=handles.activex1.GetRGBPixel(xcursor,ycursor);
            set( handles.rValue, 'String', RGB(1));
            set( handles.gValue, 'String', RGB(2));
            set( handles.bValue, 'String', RGB(3));
            %retreiving and plotting r,g and b values in line
            datar=handles.activex1.GetComponentLine(ycursor,1);
            datag=handles.activex1.GetComponentLine(ycursor,2);
            datab=handles.activex1.GetComponentLine(ycursor,3);
        %     plot(handles.axes1,x,datar,'r', x,datag,'g',x,datab,'b');
            imagematrix=handles.activex1.GetImageWindow(xcursor-w/2,ycursor-w/2,w,w);
                 for m=1:w
                        for n=1:w
                         Z(m,n)=imagematrix(m*3,n);
                        end
                 end
        %     mesh(handles.axes2,Z);
            xlim(handles.axes1,[0,sizex]);
            ylim(handles.axes1,[0,maxpix]);
            zlim(handles.axes2,[0,maxpix]);
            set(handles.axes1,'YGrid','on')
%% camera calibration code

% after finding the best paramteres, the camera is calibrated to
% these paramters
            if myend==2
                handles.activex1.AcquisitionMode='SingleFrame';
               load mycellmat
                m=mycell;
                m(~m)=nan;
                q1= find(m==min(m));
            %     i=q1-1;
                 handles.activex1.BalanceRatioAbs=param(q1,1);
                 handles.activex1.ExposureTimeRaw=param(q1,4);
                 handles.activex1.GainRaw=param(q1,3);
                 handles.activex1.BlackLevelRaw=param(q1,2);
            end

%% downsampled paramter space to step1

if i<floor(size(param,1)/step1)

       % when count=1,i.e in the beginning, the segmentation is performed (only once)
                  if count==1             
                          mymat=handles.activex1.GetImageWindow(0,0,sizex,sizey);        
                          m=mymat';
                          a=zeros(492,658,3);
                           for i1=1:658
                           a(:,i1,3)=m(:,3*i1-2);
                           a(:,i1,2)=m(:,3*i1-1);
                           a(:,i1,1)=m(:,3*i1);
                           end     
                           [mybox mysorted]=K2_segmentation(a);   % segmentation function
                           mybox=mybox;
                           mysorted=mysorted;
                           save('mybox.mat','mybox');     
                           save('mysorted.mat','mysorted');     
                           count= count+1;
                   end  
              
              handles.activex1.GainAuto = 'Off';
%               handles.activex1.ExposureAuto='Off';
              handles.activex1.BalanceRatioAbs=param(step1*i+1,1);
              handles.activex1.BlackLevelRaw=param(step1*i+1,2);
              handles.activex1.GainRaw=param(step1*i+1,3);
              handles.activex1.Gamma=param(step1*i+1,4);
                 

                mymat=handles.activex1.GetImageWindow(0,0,sizex,sizey);
                m=mymat';
                a=zeros(492,658,3);
                for i1=1:658
                a(:,i1,3)=m(:,3*i1-2);
                a(:,i1,2)=m(:,3*i1-1);
                a(:,i1,1)=m(:,3*i1);
                end
                      
                  err=error(a);    % error function to evaluate the difference between the image and the original chart
                  err1=[err1 err];
                  graph1=subplot(1,2,1);
                  set(graph1,'position',[0.1300    0.1100    0.3347    1-0.11]),imshow(uint8(a),[]);
                  graph2=subplot(1,2,2);
                  set(graph2,'position',[0.13+0.3347+0.17   0.36   0.3    0.3])
                  plot(err1),ylabel('error');
                  mycell(step1*i+1,1)=err;
                  save('mycellmat.mat','mycell');      
                  disp(['parameter index : ',num2str(i*step1)])
                  i=i+1;
        else
              load mycellmat
                   m=mycell;
                   m(~m)=nan;
                   q= find(m==min(m));
                   q2=q+step2*j;
                   if q2<=0 || q2> size(param,1)
                     q2=q;
                    end
                   if j==-16
                     save('q2.mat','q');
                   end
 %% after finding the minima, search the space around it with size step2 
  
                    if j<16           
                               load q2;
                                handles.activex1.BalanceRatioAbs=param(q2,1);
                                handles.activex1.BlackLevelRaw=param(q2,2);
                                handles.activex1.GainRaw=param(q2,3);
                                handles.activex1.Gamma=param(q2,4);
                              
                                mymat=handles.activex1.GetImageWindow(0,0,sizex,sizey);
                                m=mymat';
                                a=zeros(492,658,3);
                                for i=1:658
                                a(:,i,3)=m(:,3*i-2);
                                a(:,i,2)=m(:,3*i-1);
                                a(:,i,1)=m(:,3*i);
                                end
                                err=error(a);
                                err1=[err1 err];
                                  graph1=subplot(1,2,1);
                                  set(graph1,'position',[0.1300    0.1100    0.3347    1-0.11]),imshow(uint8(a),[]);
                                  graph2=subplot(1,2,2);
                                  set(graph2,'position',[0.13+0.3347+0.17   0.36   0.3    0.3])
                                  plot(err1),ylabel('error');
                  
                               mycell(q+step2*j,1)=err;
                               save('mycellmat.mat','mycell');
                               disp(['parameter index : ',num2str(j+q)])
                               j=j+1;
                       else
                                myend=myend+1;
                                load mycellmat
                                m=mycell;
                                m(~m)=nan;
                                q1= find(m==min(m));       

        %                         str = [' best parameters = ' num2str(param(q1,:))]
                                  str = [' best white balance=' num2str(param(q1,1))]
                                  str = [' best black level=' num2str(param(q1,2))]
                                  str = [' best gain=' num2str(param(q1,3))]
                                  str = [' best Gamma=' num2str(param(q1,4))] 
                                  
                       end

                   if myend==3

                             mymat=handles.activex1.GetImageWindow(0,0,sizex,sizey);
                             m=mymat';
                             a=zeros(492,658,3);
                             for i=1:658
                             a(:,i,3)=m(:,3*i-2);
                             a(:,i,2)=m(:,3*i-1);
                             a(:,i,1)=m(:,3*i);
                             end
                           
                              handles.activex1.Acquire=false;  
                end

end
 
 
%  telapsed=toc(tstart)
 
% --- Executes on button press in pushbutton1.
 
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.activex1.ShowProperties();
 
 
% --------------------------------------------------------------------
function activex1_FormatChanged(hObject, eventdata, handles)
% hObject    handle to activex1 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)
set(handles.axes1, 'xlim', [0,handles.activex1.SizeX]);
set(handles.axes1, 'ylim', [0,pow2(handles.activex1.GetBitsPerChannel())]);
 
 
% --------------------------------------------------------------------
function activex1_MouseMove(hObject, eventdata, handles)
% hObject    handle to activex1 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)
global xcursor;
global ycursor;
xcursor=eventdata.x;
ycursor=eventdata.y;
if(xcursor<0) 
    xcursor=0;
end
if(ycursor<0) 
    ycursor=0;
end
if(xcursor>=handles.activex1.SizeX)
    xcursor=handles.activex1.SizeX-1;
end
if(ycursor>=handles.activex1.SizeY)
    ycursor=handles.activex1.SizeY-1;
end
set( handles.xValue, 'String', xcursor);
set( handles.yValue, 'String', ycursor);
 
% segmentation function
function [mybox mysorted]= K2_segmentation(a)
 
i=a;
% i=imresize(i, [397 572]);
 
nColors=24;
 
nrows = size(i,1);
ncols = size(i,2);
 
rgb=double(i);
rgb = reshape(rgb,nrows*ncols,3);
 
[ind centr]=kmeans(rgb,nColors,'Replicates',2,'EmptyAction', 'singleton');
 
pixel_labels = reshape(ind,nrows,ncols);
% 
 
% segmented_images = cell(1,nColors);
segmented_images = repmat(uint8(0),[size(i), nColors]);
rgb_label = repmat(pixel_labels,[1 1 3]);
 
for k = 1:nColors
    color = i;
    color(rgb_label ~= k) = 0;
    segmented_images(:,:,:,k) = color;
end
 
% for z=1:nColors
% figure(2),subplot(4,7,z) ; imshow(segmented_images(:,:,:,z));
% end
% 
for z=1:nColors
    se=strel('disk',5);
    segmented_images(:,:,:,z)=imopen(segmented_images(:,:,:,z),se);
end
 
for z=1:nColors
figure(3), subplot(4,7,z) ; imshow(segmented_images(:,:,:,z));
end
% 
% 
%  for z=1:nColors
%     segmented_bw1(:,:,z)=im2bw(segmented_images(:,:,:,z),0.01);
%     xy=bwlabel(segmented_bw1(:,:,z));
%     s=regionprops(segmented_bw1(:,:,z));
%     area_values = [s.Area];
%     idx = find((area_values >= 4000));
%     segmented_bw1(:,:,z) = ismember(xy, idx);
% figure(4), subplot(4,7,z) ; imshow(segmented_bw1(:,:,z));
% end
 
cent1=zeros(nColors,2);
cent2=zeros(nColors,2);
cent3=zeros(nColors,2);
 
 
box1=zeros(nColors,4);
box2=zeros(nColors,4);
box3=zeros(nColors,4);
 
 
for z=1:nColors
    segmented_bw1(:,:,z)=im2bw(segmented_images(:,:,:,z),0.01);
    xy=bwlabel(segmented_bw1(:,:,z));
    s=regionprops(xy);
    area_values = [s.Area];
    idx = find((area_values >= 2000));
    segmented_bw1(:,:,z) = ismember(xy, idx);
    xy1=bwlabel(segmented_bw1(:,:,z));
       s=regionprops(xy1);
       
    siz=size(s,1);
    if siz==0
        cent1(z,:)=0;
        box1(z,:)=0;
    elseif siz==1
        cent1(z,:)=s.Centroid;
        box1(z,:)=s.BoundingBox;
    elseif siz==2
        [a b]=s.Centroid;
        cent1(z,:)=a;
        cent2(z,:)=b;
        [x y]=s.BoundingBox;
        box1(z,:)=x;
        box2(z,:)=y;
    else
        [a b c]=s.Centroid;
        cent1(z,:)=a;
        cent2(z,:)=b;
        cent3(z,:)=c;
        [x y y1]=s.BoundingBox;
        box1(z,:)=x;
        box2(z,:)=y;
        box3(z,:)=y1;
    end
 
end
 
cent1(all(cent1==0,2),:)=[];
cent2(all(cent2==0,2),:)=[];
cent3(all(cent3==0,2),:)=[];
cent=[cent1; cent2; cent3];
 
 
box1(all(box1==0,2),:)=[];
box2(all(box2==0,2),:)=[];
box3(all(box3==0,2),:)=[];
 
mybox=[box1; box2; box3];
 
gridSize=[size(cent,1) 1];
 
        sortedPositions = zeros(gridSize);
        [q, sorted_indexes_y] = sort(cent(:, 2)); % Sort the rows
 
        for w=1:4
 
            current_indexes = sorted_indexes_y(6*(w-1)+1:w*6); % Isolate each row
            temporal_positions = cent(sorted_indexes_y(6*(w-1)+1:w*6));
            [q, sorted_indexes_x] = sort(temporal_positions(:,1));  % Sort the columns of the isolated row
            sortedPositions(6*(w-1)+1:w*6) = current_indexes(sorted_indexes_x)';
        end
 
        mysorted = sortedPositions;
 


function err=error(a)
% 
global rgb_means_ref
global mybox
global mysorted
 
load mybox
load mysorted
 
ncols=572;
nrows=397;
 mybox=round(mybox);
 
for z=1:24
 c1=mybox(mysorted(z),1);
 c2=mybox(mysorted(z),2); 
 c3=mybox(mysorted(z),3);
 c4=mybox(mysorted(z),4);
 c11=c1+c3;
 c22=c2+c4;
 
 if c11>ncols || c22>nrows
     c11=ncols;
     c22=nrows;
 end
rgb_means_rec(z,:)= (sum(sum(a(c2:c22,c1:c11,:))))/(c3*c4);
end
 
for z=1:24
    err(z)=(sqrt(((rgb_means_ref(z,1)-rgb_means_rec(z,1)).^2)+((rgb_means_ref(z,2)-rgb_means_rec(z,2)).^2)+((rgb_means_ref(z,3)-rgb_means_rec(z,3)).^2)));
end
 
err=sum(err);
