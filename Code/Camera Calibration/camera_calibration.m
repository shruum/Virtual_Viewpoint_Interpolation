function camera_calibration(varargin)
 
%  function type: camera_calibration('balance',[1 4 1], 'black level',[190 990 50],'gain',[190 690 50],'gamma',[1 3 1])
% this function performs camera calibration for four paramteres, the input vector given should be the parameter name and the vector containing the values of the paramter.    
% Example:  camera_calibration('name',[min max stepsize]) 
%

 
mynargin=nargin/2;
save('mynargin.mat','mynargin');
    
            for i=0:nargin/2-1
            a(i+1)=varargin(1+2*i);
            end
             i=1;
             name= {a{i};a{i+1};a{i+2};a{i+3}};
             for i=1:nargin/2
             b(i)=varargin(2*i);
             end
 
             for i=1:nargin/2
             vec=b{i};
             vect(i,1)=vec(1);
             vect(i,2)=vec(2);
             vect(i,3)=vec(3);
             end
            diff1=(vect(1,2)-vect(1,1))/vect(1,3);
            diff2=(vect(2,2)-vect(2,1))/vect(2,3);
            diff3=(vect(3,2)-vect(3,1))/vect(3,3);
            diff4=(vect(4,2)-vect(4,1))/vect(4,3);
 
             for k=0:diff4
                for j=0:diff3
                     for i=0:diff2      
                       param((diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+1: (diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+(diff1+1),1)=vect(1,1):vect(1,3):vect(1,2);
                       param((diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+1: (diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+(diff1+1),2)=vect(2,3)*i+vect(2,1);
                       param((diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+1: (diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+(diff1+1),3)=vect(3,3)*j+vect(3,1);
                       param((diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+1: (diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+(diff1+1),4)=vect(4,3)*k+vect(4,1);
                     end
                end
             end
                  param(~any(param,2),:)=[];       % param contains all the possible combinations of the four given parameters
 
            save('param.mat','param');
            save('name.mat','name');
            save('vect.mat','vect');
            mycell=zeros(size(param,1),1);          % mycell will hold all the error values for each iteration (each paramter set)
            save('mycellmat.mat','mycell')
            
% elseif nargin/2==5
%     
%             for i=0:nargin/2-1
%             a(i+1)=varargin(1+2*i);
%             end
%              i=1;
%              name= {a{i};a{i+1};a{i+2};a{i+3}};
%              for i=1:nargin/2
%              b(i)=varargin(2*i);
%              end
%  
%              for i=1:nargin/2
%              vec=b{i};
%              vect(i,1)=vec(1);
%              vect(i,2)=vec(2);
%              vect(i,3)=vec(3);
%              end
%             diff1=(vect(1,2)-vect(1,1))/vect(1,3);
%             diff2=(vect(2,2)-vect(2,1))/vect(2,3);
%             diff3=(vect(3,2)-vect(3,1))/vect(3,3);
%             diff4=(vect(4,2)-vect(4,1))/vect(4,3);
%             diff5=(vect(5,2)-vect(5,1))/vect(5,3);
%  
%           for l=0:diff5  
%              for k=0:diff4
%                 for j=0:diff3
%                      for i=0:diff2      
%                        param((diff1+1)*(diff2+1)*(diff3+1)*(diff4+1)*l+(diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+1: (diff1+1)*(diff2+1)*(diff3+1)*(diff4+1)*l+(diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+(diff1+1),1)=vect(1,1):vect(1,3):vect(1,2);
%                        param((diff1+1)*(diff2+1)*(diff3+1)*(diff4+1)*l+(diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+1: (diff1+1)*(diff2+1)*(diff3+1)*(diff4+1)*l+(diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+(diff1+1),2)=vect(2,3)*i+vect(2,1);
%                        param((diff1+1)*(diff2+1)*(diff3+1)*(diff4+1)*l+(diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+1: (diff1+1)*(diff2+1)*(diff3+1)*(diff4+1)*l+(diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+(diff1+1),3)=vect(3,3)*j+vect(3,1);
%                        param((diff1+1)*(diff2+1)*(diff3+1)*(diff4+1)*l+(diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+1: (diff1+1)*(diff2+1)*(diff3+1)*(diff4+1)*l+(diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+(diff1+1),4)=vect(4,3)*k+vect(4,1);
%                        param((diff1+1)*(diff2+1)*(diff3+1)*(diff4+1)*l+(diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+1: (diff1+1)*(diff2+1)*(diff3+1)*(diff4+1)*l+(diff1+1)*(diff2+1)*(diff3+1)*k+(diff1+1)*(diff2+1)*j+(diff1+1)*i+(diff1+1),5)=vect(5,3)*l+vect(5,1);
%                      end
%                 end
%              end
%           end
%                   param(~any(param,2),:)=[];
%  
%             save('param.mat','param');
%             save('name.mat','name');
%             save('vect.mat','vect');
%             mycell=zeros(size(param,1),1);
%            save('mycellmat.mat','mycell')    
%         
% end
   
           varargout = MatlabViewer;       % the camera to matlab interface function


