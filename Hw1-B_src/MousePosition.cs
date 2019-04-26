using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MousePosition : MonoBehaviour
{
    Renderer render;

    // Start is called before the first frame update
    void Start()
    {
        render = GetComponent<Renderer>();

        render.material.shader = Shader.Find("Custom/Sharpen");
    }

    // Update is called once per frame
    void Update()
    {
        float avg = (Input.mousePosition.x + Input.mousePosition.y)/2;
        render.material.SetFloat("_Amount", avg/100);
    }
}
