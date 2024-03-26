UiTweenUtil = UiTweenUtil or {}

UiTweenUtil.OPEN_VIEW_TYPE_SCALE = "playViewOpenScale"
UiTweenUtil.OPEN_VIEW_TYPE_FADE = "playViewFade"

UiTweenUtil.OPEN_VIEW_TYPE_DOWN_2_UP = "playViewDown2Up"
UiTweenUtil.OPEN_VIEW_TYPE_LEFT_2_RIGHT = "playViewLeft2Right"
UiTweenUtil.OPEN_VIEW_TYPE_RIGHT_2_LEFT = "playViewRight2Left"

function UiTweenUtil.playTweenByType(funcName, window, ...)
    if UiTweenUtil[funcName] and type(UiTweenUtil[funcName]) == "function" then
        UiTweenUtil[funcName](window, ...)
    end
end

-- ""
function UiTweenUtil.playViewOpenScale(window)
    local transform = window.pnlTransform
    transform.localScale = Vector3(0.3, 0.3, 0)
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Append(transform:DOScale(Vector3(1, 1, 1), 0.3):SetEase(CS.DG.Tweening.Ease.Linear))

    -- local rect = view:getRectTransfrom()
    -- local rect = transform:GetComponent(typeof(UnityEngine.RectTransform))
    --transform.localScale = Vector3(0, 0, 0)
    -- sequence:Append(transform:DOScale(Vector3(2, 2, 1), 0.1))
    --sequence:SetDelay(1)
    -- sequence:AppendCallback(function ()
    --     view.transform.localScale = Vector3(0, 0, 0)
    -- end)
    -- sequence:SetLoops(100)
    -- UiTweenUtil.view.transform:DOScale(Vector3(5, 5, 0), 2)
end

-- ""
function UiTweenUtil.playViewFade(window)
    if window.canvasGroup then
        window.canvasGroup.alpha = 0
        window.canvasGroup:DOFade(1, 0.2):SetEase(CS.DG.Tweening.Ease.Linear)
    end
end

--""
function UiTweenUtil.playViewDown2Up(window)
    local transform = window.pnlTransform
    local targetPos = transform.localPosition
    local beginPos =  transform.localPosition
    beginPos.y = beginPos.y - UnityEngine.Screen.height
    transform.localPosition = beginPos
    transform:DOLocalMove(targetPos, 0.4):SetEase(CS.DG.Tweening.Ease.OutElastic)
end

--""
function UiTweenUtil.playViewLeft2Right(window)
    local transform = window.pnlTransform
    local targetPos = transform.localPosition
    local beginPos =  transform.localPosition
    beginPos.x = beginPos.x - UnityEngine.Screen.width
    transform.localPosition = beginPos
    transform:DOLocalMove(targetPos, 0.2):SetEase(CS.DG.Tweening.Ease.Linear)
end

--""
function UiTweenUtil.playViewRight2Left(window)
    local transform = window.pnlTransform
    local targetPos = transform.localPosition
    local beginPos =  transform.localPosition
    beginPos.x = beginPos.x + UnityEngine.Screen.width
    transform.localPosition = beginPos
    transform:DOLocalMove(targetPos, 0.2):SetEase(CS.DG.Tweening.Ease.Linear)
end