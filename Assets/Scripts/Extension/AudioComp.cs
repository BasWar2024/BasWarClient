using UnityEngine;
using UnityEngine.EventSystems;

public class AudioComp : MonoBehaviour, IPointerClickHandler
{
    public enum AudioPlayType
    {
        None = 0,
        Show = 1,
        Click = 2,
        ShowCloseBg = 3,//
    }
    public enum CompAudioType
    {
        TwoD = 1,
        ThreeD = 2,
        Follow = 3,
    }

    private AudioSource source;
    public AudioPlayType _audioPlayType = AudioPlayType.None;
    public CompAudioType _audioType = CompAudioType.TwoD;
    public float delayTime = 0f;

    private void Awake()
    {
        source = GetComponent<AudioSource>();
    }

    private void OnEnable()
    {
        if (_audioPlayType != AudioPlayType.Show && _audioPlayType != AudioPlayType.ShowCloseBg) return;

        if (_audioPlayType == AudioPlayType.ShowCloseBg)
        {
            AudioMgr.instance.PauseAudio(AudioType.BGMusic, true);
        }

        if (delayTime == 0f)
        {
            source.Play();
        }
        else
        {
            source.PlayDelayed(delayTime);
        }
    }

    private void OnDisable()
    {
        if (_audioPlayType == AudioPlayType.Show)
        {
           source.Stop();
        }
        else if (_audioPlayType == AudioPlayType.ShowCloseBg)
        {
            source.Stop();
            AudioMgr.instance.PauseAudio(AudioType.BGMusic, false);
        }
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        if (_audioPlayType != AudioPlayType.Click) return;

        if (delayTime == 0f)
        {
            source.Play();
        }
        else
        {
            source.PlayDelayed(delayTime);
        }
    }

    void OnDestroy()
    {
        if (source != null)
        {
            source.Stop();
        }
    }
}
