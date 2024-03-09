using Spine.Unity;
using Battle;
using System;
using UnityEngine;

public static partial class SpineExtension
{
    public static void SpineAnimPlay(this SkeletonAnimation anim, string animName, bool loop, int trackIndex = 0)
    {
        if (anim == null)
            return;

        anim.AnimationState.SetAnimation(trackIndex, animName, loop);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="anim"></param>
    /// <param name="entity"></param>
    /// <param name="animName"></param>
    /// <param name="loop"></param>
    /// <param name="owerride"></param>
    /// <param name="trackIndex"></param>
    public static void SpineAnimPlayAuto8Turn(this SkeletonAnimation anim, EntityBase entity, string animName, bool loop, int trackIndex = 0)
    {
        if (anim == null)
            return;

        string directionAnimName;
        var rotationY = entity.AngleY;
        var spineAnimNum = Math.Round(rotationY / 45, 0);
        var dir = 1;

        if (spineAnimNum == 4)
        {
            spineAnimNum = 2;
            dir = -1;
        }
        else if (spineAnimNum == 5)
        {
            spineAnimNum = 1;
            dir = -1;
        }
        else if (spineAnimNum == 6)
        {
            spineAnimNum = 0;
            dir = -1;
        }
        else if (spineAnimNum >= 8)
        {
            spineAnimNum = 0;
        }

        directionAnimName = $"{animName}_{spineAnimNum}";

        if (anim.AnimationName == directionAnimName)
            return;

        entity.SpineTrans.localScale = new UnityEngine.Vector3(dir, 1, 1);

        anim.AnimationState.SetAnimation(trackIndex, directionAnimName, loop);

        if (!loop)
        {
            anim.AnimationState.AddAnimation(trackIndex, $"idle_{spineAnimNum}", true, 0);
            //anim.AnimationState.Complete -= delegate { anim.PlayDefaultAnim(spineAnimNum); };
            //anim.AnimationState.Complete += delegate { anim.PlayDefaultAnim(spineAnimNum); };
        }
    }

    public static void SpineAnimPlayAuto30Turn(this SkeletonAnimation anim, EntityBase entity, string animName, bool loop, int trackIndex = 0)
    {
        if (anim == null)
            return;

        string directionAnimName;
        var rotationY = entity.AngleY;
        var spineAnimNum = Math.Round(rotationY / 12, 0);

        if (spineAnimNum >= 30)
        {
            spineAnimNum = 0;
        }

        directionAnimName = $"{animName}_{spineAnimNum}";

        if (anim.AnimationName == directionAnimName)
            return;

        anim.AnimationState.SetAnimation(trackIndex, directionAnimName, loop);

        if (!loop)
        {
            anim.AnimationState.AddAnimation(trackIndex, $"idle_{spineAnimNum}", true, 0);
            //anim.AnimationState.Complete -= delegate { anim.PlayDefaultAnim(spineAnimNum); };
            //anim.AnimationState.Complete += delegate { anim.PlayDefaultAnim(spineAnimNum); };
        }
    }

    //
    private static void PlayDefaultAnim(this SkeletonAnimation anim, double spineAnimNum, int trackIndex = 0)
    {
        anim.AnimationState.SetAnimation(trackIndex, $"idle_{spineAnimNum}", true);
    }
}
