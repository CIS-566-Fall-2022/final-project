using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class CameraPostProcess : MonoBehaviour
{
    public Camera m_OrthographicCamera;
    public Material material;

    void OnRenderImage (RenderTexture source, RenderTexture destination) {
        Matrix4x4 inv_view_proj_mat = m_OrthographicCamera.projectionMatrix.inverse;
        material.SetMatrix("_InvCamProjMatrix", inv_view_proj_mat);
        material.SetVector("_CameraPos", m_OrthographicCamera.transform.position);
        Graphics.Blit(source, destination, material);
    }
}