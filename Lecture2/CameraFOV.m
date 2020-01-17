function [ FOVx, FOVy ] = CameraFOV( sensorwidth, sensorheight, b)
%Computes camera field of view.
    %Input: sensorwidth, sensorheight, f (focal length)
    
 FOVx = 2 * atand(sensorwidth/(2*b));
 FOVy = 2 * atand(sensorheight/(2*b));


end

