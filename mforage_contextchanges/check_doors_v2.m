function doorIdx = check_doors(dist_Mat, r)

% this function takes the distmat, and checks whether the 
% lie within any of the door locations
% returns an array of 
nDoors  = size(doorRects, 2);
doorIdx = zeros(1, nDoors);

for check = 1:nDoors
    
    if x >= doorRects(1, check) && x <= doorRects(3, check)
        if y >= doorRects(2, check) && y <= doorRects(4, check)
            
            doorIdx(check) = 1;
        end
    end  
end
end