using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HeightMapSlider : MonoBehaviour
{
    float value = 1.5F;

    Renderer render;

    // Start is called before the first frame update
    void Start() {
        render = GetComponent<Renderer>();
        render.material.shader = Shader.Find("Custom/HillFromTexture");
    }

    void  OnGUI() {
        GUI.Label(new Rect(5, 5, 200, 20), "Height Displacement");
        value = GUI.HorizontalSlider(new Rect(5, 25, 100, 30), value, 0.0F, 5.0F);
    }
    
    void Update() {
        render.material.SetFloat("_DisplacementAmt", value);
    }
}
