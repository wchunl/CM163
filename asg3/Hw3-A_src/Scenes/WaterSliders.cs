using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterSliders : MonoBehaviour
{
    float noise = 0.69F;
    float distortion = 0.27F;
    float reflection = 1.0F;

    Renderer render;
    public GUIStyle style = null;

    // Start is called before the first frame update
    void Start() {
        render = GetComponent<Renderer>();
        render.material.shader = Shader.Find("Custom/ToonWater");
    }

    void  OnGUI() {
        GUI.Label(new Rect(25, 25, 200, 20), "Settings", style);
        GUI.Label(new Rect(5, 45, 200, 20), "Water Noise Level", style);
        noise = GUI.HorizontalSlider(new Rect(5, 65, 100, 30), noise, 0.0F, 1.0F);
        GUI.Label(new Rect(5, 85, 200, 20), "Water Distortion", style);
        distortion = GUI.HorizontalSlider(new Rect(5, 105, 100, 30), distortion, 0.0F, 1.0F);
        GUI.Label(new Rect(5, 125, 200, 20), "Water Brightness", style);
        reflection = GUI.HorizontalSlider(new Rect(5, 145, 100, 30), reflection, 0.0F, 2.0F);
    }
    
    void Update() {
        render.material.SetFloat("_SurfaceNoiseCutoff", noise);
        render.material.SetFloat("_SurfaceDistortionAmount", distortion);
        render.material.SetFloat("_WaterTransparency", reflection);
    }
}