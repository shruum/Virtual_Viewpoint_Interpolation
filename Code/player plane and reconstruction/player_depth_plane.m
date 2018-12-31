function [v r1 r2]= player_depth_plane(x,y,z,r,theta,rz)

% calculates the plane for the player at every angle

format long

i1=imread('image1(2)');
i2=imread('image2(2)');
load cam1.mat
load cam2.mat
rz=-rz;

Point1=[x ;y; z];

Point2=[x ;y; rz ];

Point3=three_points_for_plane(Point1,r,theta);     % select 3 points around the player box to put a plane

[r1 r2]=player_region(Point1,Point2,Point3,r,theta);

v=plane_from_3points(Point1,Point2,Point3);                  % v represents the coefficients of the plane
                                                            % v=[a b c d] for a plane ax+by+cz+d
                                                           
                                                         
                                                          

