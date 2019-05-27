using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraRotation : MonoBehaviour
{
    float speed = 10.0F;
    public GUIStyle style = null;

void  OnGUI() {
        GUI.Label(new Rect(5, 165, 200, 20), "Camera Speed", style);
        speed = GUI.HorizontalSlider(new Rect(5, 185, 100, 30), speed, 10.0F, 50.0F);
    }
    // Update is called once per frame
    void Update()
    {
        transform.Rotate(0, speed * Time.deltaTime, 0);
    }
}
