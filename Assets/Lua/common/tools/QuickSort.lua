QuickSort = QuickSort or {}

--
function QuickSort:quickSort(temp, left, right, up)
    if left >= right then
        return
    end
    local l =left
    local r =right
    local key = temp[l].sort
    if up then
        while l < r do
            while l < r and key <= temp[r].sort do
                r = r - 1
            end
            local swi = temp[r]
            temp[r] = temp[l]
            temp[l] = swi
            while l < r and key >= temp[l].sort do
                l = l + 1
            end
            local swi = temp[r]
            temp[r] = temp[l]
            temp[l] = swi
        end
    else
        while l < r do
            while l < r and key >= temp[r].sort do
                r = r - 1
            end
            local swi = temp[r]
            temp[r] = temp[l]
            temp[l] = swi
            while l < r and key <= temp[l].sort do
                l = l + 1
            end
            local swi = temp[r]
            temp[r] = temp[l]
            temp[l] = swi
        end
    end

    self:quickSort(temp, left, l - 1, up)
    self:quickSort(temp, l + 1, right, up)
end

return QuickSort