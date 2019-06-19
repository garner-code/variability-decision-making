function doorIdx = check_doors(doorRects, x, y)

% this function takes the coordinates x and y, and checks whether they 
% lie within any of the door locations
% returns either a 0 (no door) or the idx of the door
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