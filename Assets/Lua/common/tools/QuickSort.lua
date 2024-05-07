QuickSort = QuickSort or {}

--""
function QuickSort.quickSort(temp, args, left, right, up)
    if left >= right then
        return
    end
    local l =left
    local r =right
    local key = temp[l][args]
    if up then
        while l < r do
            while l < r and key <= temp[r][args] do
                r = r - 1
            end
            local swi = temp[r]
            temp[r] = temp[l]
            temp[l] = swi
            while l < r and key >= temp[l][args] do
                l = l + 1
            end
            local swi = temp[r]
            temp[r] = temp[l]
            temp[l] = swi
        end
    else
        while l < r do
            while l < r and key >= temp[r][args] do
                r = r - 1
            end
            local swi = temp[r]
            temp[r] = temp[l]
            temp[l] = swi
            while l < r and key <= temp[l][args] do
                l = l + 1
            end
            local swi = temp[r]
            temp[r] = temp[l]
            temp[l] = swi
        end
    end

    QuickSort.quickSort(temp, args, left, l - 1, up)
    QuickSort.quickSort(temp, args, l + 1, right, up)
end

return QuickSort