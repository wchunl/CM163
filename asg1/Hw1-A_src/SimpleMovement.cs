using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleMovement : MonoBehaviour
{
    private Vector3 _startPos;
    public float _DistanceX = 20;
    public float _DistanceY = 20;
    // Start is called before the first frame update
    void Start()
    {
        _startPos = transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        transform.position = _startPos + new Vector3(Mathf.Sin(Time.time) * _DistanceX, 
                                                    Mathf.Sin(Time.time) * _DistanceY, 0.0f);
        // transform.position = _startPos + new Vector3(0.0f, Mathf.Sin(Time.time) * 20, 0.0f);
        // transform.Translate(mathf.Sin(Time.deltaTime * 100));
    }
}
