namespace GypsyMagic.FrameAnimation
{
    class LoopClipPlayer
    {
        private FrameClip _clip = default;
        private float _currentAnimationTime = default;

        public bool IsPlaying { get; private set; } = false;
        public int CurrentFrameIndex { get; private set; } = 0;

        public LoopClipPlayer() { }

        public LoopClipPlayer(FrameClip clip)
        {
            SetClip(clip);
        }

        public void SetClip(FrameClip clip)
        {
            _clip = clip;
            Stop();
        }

        public void Play(int frameIndex = 0)
        {
            Rewind(frameIndex);
            IsPlaying = true;
        }

        public void Rewind(int frameIndex)
        {
            CurrentFrameIndex = frameIndex % _clip.Frames.Length;
            _currentAnimationTime = CurrentFrameIndex * (1f / _clip.FrameRate);
        }

        public void Pause()
        {
            IsPlaying = false;
        }

        public void Stop()
        {
            IsPlaying = false;
            CurrentFrameIndex = 0;
            _currentAnimationTime = 0f;
        }

        public void UpdateFrame(float deltaTime)
        {
            if (!IsPlaying)
            {
                return;
            }
            _currentAnimationTime = (_currentAnimationTime + deltaTime) % (_clip.Frames.Length * (1f / _clip.FrameRate));
            var index = (int)(_currentAnimationTime / (1f / _clip.FrameRate));
            if (index != CurrentFrameIndex)
            {
                CurrentFrameIndex = index;
            }
        }
    }
}
