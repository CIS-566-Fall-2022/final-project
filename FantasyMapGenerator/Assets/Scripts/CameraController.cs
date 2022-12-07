using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public Camera   m_OrthographicCamera;
    public bool     m_user_is_dragging;
    public Vector3  m_dragging_position;
    public bool     isFreeCameraActive = false;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyUp(KeyCode.C))
        {
            isFreeCameraActive = !isFreeCameraActive;
        }

        if (isFreeCameraActive)
        {
            // Middle Mouse Scroll Wheel -- Zoom
            float scroll_wheel_change = Input.GetAxis("Mouse ScrollWheel");
            if (scroll_wheel_change != 0)
            {
                float zoom_change = scroll_wheel_change * 20.0f;
                float camera_current_zoom = m_OrthographicCamera.orthographicSize;
                m_OrthographicCamera.orthographicSize = camera_current_zoom + zoom_change;
            }


            if (Input.GetMouseButtonDown(2))
            {
                m_dragging_position = m_OrthographicCamera.ScreenToWorldPoint(Input.mousePosition);
                m_user_is_dragging = true;
            }
            if (Input.GetMouseButton(2) && m_user_is_dragging)
            {
                Vector3 diff = m_dragging_position - m_OrthographicCamera.ScreenToWorldPoint(Input.mousePosition);
                diff.y = 0.0f;
                m_OrthographicCamera.transform.position += diff;
            }
            if (Input.GetMouseButtonUp(2))
            {
                m_user_is_dragging = false;
            }
        }

    }
}
