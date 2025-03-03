
using UnityEngine;

public class GalaxyCell : MonoBehaviour {
    public int ul = 0;
    public int l = 0;
    public int dl = 0;
    public int dr = 0;
    public int r = 0;
    public int ur = 0;

    private Material material;

    // Start is called before the first frame update
    void Start() {
        //if(material == null)
        //    material = transform.GetComponent<MeshRenderer>().material;

    }

    public void SetGalaxyCell(int dir, int value) {
        if (material == null)
            material = transform.GetComponent<MeshRenderer>().material;

        switch (dir) {
            case 0:
                material.SetInt("_UpLeft", value);
                break;
            case 1:
                material.SetInt("_Left", value);
                break;
            case 2:
                material.SetInt("_DownLeft", value);
                break;
            case 3:
                material.SetInt("_DownRight", value);
                break;
            case 4:
                material.SetInt("_Right", value);
                break;
            case 5:
                material.SetInt("_UpRight", value);
                break;
        }
    }

    private void OnDisable() {
        material = null;
    }
}
