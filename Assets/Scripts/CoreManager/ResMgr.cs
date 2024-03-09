using System;
using System.Collections;
using System.Collections.Generic;
using GG.Tilemapping;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;
using UnityEngine.SceneManagement;
using UnityEngine.U2D;
using XLua;

namespace GG {

    public class LoadProgress
    {
        public float percent = 0;
        public float resCnt = 0;
        public Action loadComplete;
    }
    public class ResMgr : Singleton<ResMgr>
     {
        private GameObjectPool objectPool;
        //GPU INSTANCE
        public MaterialPropertyBlock propertyBlock = new MaterialPropertyBlock ();

        public void Init ()
        {
            InitObjectPool();

            EnableAtlasEvents ();
        }

        void EnableAtlasEvents () {
            SpriteAtlasManager.atlasRequested += this.RequestAtlas;
            SpriteAtlasManager.atlasRegistered += this.RegisteredAtlas;

            // Font.textureRebuilt += RequsetTextRebuilt;
        }
        void DisableRequestAtlas () {
            SpriteAtlasManager.atlasRequested -= this.RequestAtlas;
            SpriteAtlasManager.atlasRegistered -= this.RegisteredAtlas;
        }

        private void RequsetTextRebuilt (Font font) {
            Debug.LogWarning (" " + font.name + "  ");
        }
        private void RegisteredAtlas (SpriteAtlas obj) {
            // Debug.LogError (" " + obj);
        }
        //
        private void RequestAtlas (string tag, Action<SpriteAtlas> onLoaded) {
            // Debug.LogError (" " + tag);
            // SpriteAtlas sa = await Addressables.LoadAssetAsync<SpriteAtlas> (tag).Task;
            // onLoaded (sa);
            LoadAssetAsync<SpriteAtlas> (tag, (sa) => {
                onLoaded (sa);
            });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="onLoaded"></param>
        /// <param name="assetNames">id</param>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public AsyncOperationHandle<IList<T>> LoadAssetsAsync<T> (string[] assetNames, Callback<IList<T>> onLoaded) {
            var handle = Addressables.LoadAssetsAsync<T> (assetNames, null, Addressables.MergeMode.Union);
            if (onLoaded != null) {
                handle.Completed += (finish) => {
                    onLoaded (finish.Result);
                };
            }
            return handle;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="onLoaded"></param>
        /// <param name="assetName"></param>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public AsyncOperationHandle LoadAssetAsync<T> (string assetName, Callback<T> onLoaded) {
            var handle = Addressables.LoadAssetAsync<T> (assetName);
            if (onLoaded != null) {
                handle.Completed += (finish) => {
                    onLoaded (finish.Result);
                };
            }
            return handle;
        }

        public AsyncOperationHandle? LoadGameObjectAsync (string assetName, Func<GameObject, bool> onLoaded, bool useCache = false) {
            GameObject cacheGO = objectPool.SpawnGameObject(assetName);
            if (cacheGO != null)
            {
                onLoaded(cacheGO);
                return null;
            }
            else
            {
                return LoadAssetAsync<GameObject> (assetName, (asset) => {
                    GameObject go;
                     if (useCache)
                     {
                         go = objectPool.MarkGameObject(assetName, asset);
                     }
                     else
                     {
                         go = UnityEngine.GameObject.Instantiate(asset, Vector3.zero, Quaternion.identity);
                     }
                     //
                     bool ret = onLoaded(go);
                     if (!ret)
                     {
                         ReleaseAsset(go);
                     }
                });
            }
        }
        public AsyncOperationHandle LoadGameObjectsAsync (string[] assetNames, Callback<IList<GameObject>> onLoaded) {
            return LoadAssetsAsync (assetNames, onLoaded);
        }

        public LoadProgress PreLoadGameObjectsAsync (string[] assetNames, Action onLoaded) {

            LoadProgress handle = new LoadProgress();
            handle.percent = 0;
            handle.loadComplete = onLoaded;

            int loadedCnt = 0;
            int length = assetNames.Length;
            handle.resCnt = length;
            Queue<GameObject> preloadGos = new Queue<GameObject>();
            for (int i = 0; i < length; i++)
            {
                int temp = i;
                GameObject cacheGO = objectPool.SpawnGameObject(assetNames[i]);
                if (cacheGO != null)
                {
                    ++loadedCnt;
                    preloadGos.Enqueue(cacheGO);
                    ReCalcuteProgress(handle, loadedCnt, length, preloadGos);
                }
                else
                {
                    LoadAssetAsync<GameObject> (assetNames[temp], (asset) => {

                        GameObject go = objectPool.MarkGameObject(assetNames[temp], asset);
                        ++loadedCnt;

                        preloadGos.Enqueue(go);
                        ReCalcuteProgress(handle, loadedCnt, length, preloadGos);
                    });
                }
            }
            return handle;
         }
        public AsyncOperationHandle LoadSpriteAsync (string assetName, Callback<Sprite> onLoaded) {
            return LoadAssetAsync (assetName, onLoaded);
        }

        private AsyncOperationHandle _sceneHandle;
        public AsyncOperationHandle LoadSceneAsync (string assetName, Callback onLoaded, string loadMode = "Single") {
            LoadSceneMode loadSceneMode = LoadSceneMode.Single;
            if (loadMode == "Additive") {
                loadSceneMode = LoadSceneMode.Additive;
            }
            var handle = Addressables.LoadSceneAsync (assetName, loadSceneMode);
            _sceneHandle = handle;
            if (onLoaded != null) {
                handle.Completed += (finish) => {
                    var scene = SceneManager.GetSceneByName(assetName);
                    SceneManager.SetActiveScene(scene);
                    onLoaded();
                };
            }



            return handle;
        }      
        public AsyncOperationHandle UnLoadScene (string assetName, Callback onLoaded) {
            var handle = Addressables.UnloadSceneAsync (_sceneHandle);
            if (onLoaded != null) {
                handle.Completed += (finish) => {
                    onLoaded ();
                };
            }
            return handle;
        }

        public AsyncOperationHandle LoadSpritesAsync (string[] assetNames, Callback<IList<Sprite>> onLoaded) {
            return LoadAssetsAsync (assetNames, onLoaded);
        }
        public AsyncOperationHandle LoadTextureAsync (string assetName, Callback<Texture> onLoaded) {
            return LoadAssetAsync (assetName, onLoaded);
        }
        public AsyncOperationHandle LoadTexturesAsync (string[] assetNames, Callback<IList<Texture>> onLoaded) {
            return LoadAssetsAsync (assetNames, onLoaded);
        }
        public AsyncOperationHandle LoadAudioClipAsync (string assetName, Callback<AudioClip> onLoaded) {
            return LoadAssetAsync (assetName, onLoaded);
        }
        public AsyncOperationHandle LoadAudioClipsAsync (string[] assetNames, Callback<IList<AudioClip>> onLoaded) {
            return LoadAssetsAsync (assetNames, onLoaded);
        }
        public AsyncOperationHandle LoadMaterialAsync (string assetName, Callback<Material> onLoaded) {
            return LoadAssetAsync (assetName, onLoaded);
        }
        public AsyncOperationHandle LoadMaterialsAsync (string[] assetNames, Callback<IList<Material>> onLoaded) {
            return LoadAssetsAsync (assetNames, onLoaded);
        }
        public AsyncOperationHandle LoadTextAssetAsync (string assetName, Callback<TextAsset> onLoaded) {
            return LoadAssetAsync (assetName, onLoaded);
        }
        public AsyncOperationHandle LoadTextAssetsAsync (string[] assetNames, Callback<IList<TextAsset>> onLoaded) {
            return LoadAssetsAsync (assetNames, onLoaded);
        }

        public LoadProgress LoadAssetsAsync (string[] assetNames, string[] assetType, Action onLoaded) {
            LoadProgress progress = new LoadProgress();
            progress.percent = 0;
            progress.resCnt = assetNames.Length;
            progress.loadComplete = onLoaded;
            int length = assetNames.Length;
            int finishCnt = 0;

            if (length == 0) //
            {
                progress.percent = 1;

                if (progress.loadComplete != null)
                    progress.loadComplete();
                return progress;
            }

            for (int i = 0; i < length; i++)
            {
                int temp = i;
                if (assetType[temp] == "TextAsset") //
                {
                    LoadTextAssetAsync(assetNames[temp], (text) => {
                        ++finishCnt;
                        ReCalcuteProgress(progress, finishCnt, length);
                    });
                }
                else if (assetType[i] == "Materials")
                {
                    LoadMaterialAsync(assetNames[temp], (mat) => {
                        ++finishCnt;
                        ReCalcuteProgress(progress, finishCnt, length);
                    });
                }
                else if (assetType[i] == "AudioClip")
                {
                    LoadAudioClipAsync(assetNames[temp], (audio) => {
                        ++finishCnt;
                        ReCalcuteProgress(progress, finishCnt, length);
                    });
                }
                else if (assetType[temp] == "Texture")
                {
                    LoadTextureAsync(assetNames[temp], (tex) => {
                        ++finishCnt;
                        ReCalcuteProgress(progress, finishCnt, length);
                    });
                }
                else if (assetType[temp] == "Sprite")
                {
                    LoadSpriteAsync(assetNames[temp], (spr) => {
                        ++finishCnt;
                        ReCalcuteProgress(progress, finishCnt, length);
                    });
                }
                else
                {
                    ++finishCnt;
                    ReCalcuteProgress(progress, finishCnt, length);
                }
            }

            return progress;
        }

        //gopreloadGo.
        private void ReCalcuteProgress(LoadProgress progress, int finishCnt, int totalCnt, Queue<GameObject> preloadGo = null)
        {
            progress.percent = finishCnt / (float)totalCnt;

            if (finishCnt == totalCnt && progress.loadComplete != null)
            {
                if (preloadGo != null)
                {
                    int length = preloadGo.Count;
                    GameObject go;
                    for (int i = 0; i < length; i++)
                    {
                        go = preloadGo.Dequeue();
                        go.SetActive(false);
                        ReleaseAsset(go);
                    }
                }
                preloadGo.Clear();

                if (progress.loadComplete != null)
                    progress.loadComplete();
            }
        }

        //
        public void ReleaseAsset (SimpleTile asset) {
            Addressables.Release (asset);
            Resources.UnloadUnusedAssets ();
        }
        public void ReleaseAsset (GameObject asset) {
            if (asset == null)
            {
                Debug.LogError("Your should check if it is null before you destroy the object");
                return;
            }
            if (!objectPool.DespawnGameObject(asset))
            {
                GameObject.Destroy(asset);
                Addressables.ReleaseInstance (asset);
                Resources.UnloadUnusedAssets ();
            }
        }
        public void ReleaseAsset (Sprite asset) {
            Addressables.Release (asset);
            Resources.UnloadUnusedAssets ();
        }
        public void ReleaseAsset (Texture asset) {
            Addressables.Release (asset);
            Resources.UnloadUnusedAssets ();
        }
        public void ReleaseAsset (TextAsset asset) {
            Addressables.Release (asset);
            Resources.UnloadUnusedAssets ();
        }
        public void ReleaseAsset (AudioClip asset) {
            Addressables.Release (asset);
            Resources.UnloadUnusedAssets ();
        }
        public void ReleaseAsset (Material asset) {
            Addressables.Release (asset);
            Resources.UnloadUnusedAssets ();
        }

        public void ReleaseAsset<TObject> (TObject asset) {
            Addressables.Release<TObject> (asset);
            Resources.UnloadUnusedAssets ();
        }
        public void ReleaseAsset (AsyncOperationHandle handle) {
            Addressables.Release (handle);
            Resources.UnloadUnusedAssets ();
        }
        public void ReleaseAsset<TObject> (AsyncOperationHandle<TObject> handle) {
            Addressables.Release (handle);
            Resources.UnloadUnusedAssets ();
        }

        private void InitObjectPool()
        {
            GameObject root = GameObject.Find("global");
            GameObject pool = new GameObject("GameObjectPool");
            pool.transform.SetParent(root.transform);
            objectPool = pool.AddComponent<GameObjectPool>();
        }
    }
}