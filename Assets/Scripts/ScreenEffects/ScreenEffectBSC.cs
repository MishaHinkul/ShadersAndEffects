using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ScreenEffectBSC : MonoBehaviour {

  public Shader curShader;

  [Range(0, 2)]
  public float brightnessAmount = 1.0f;
  [Range(0, 2)]
  public float saturationAmount = 1.0f;
  [Range(0, 3)]
  public float contrastAmount = 1.0f;
  private Material curMaterial;

  private void Start() {
    if (!SystemInfo.supportsImageEffects ||
        (!curShader && !curShader.isSupported)) {
      enabled = false;
      return;
    }
    Camera.main.depthTextureMode = DepthTextureMode.Depth;
  }

  //OnRenderImage вызывается после завершения рендеринга для рендеринга изображения.
  private void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture) {
    if (curShader != null) {
      CurMaterial.SetFloat("_BrightnessAmount", brightnessAmount);
      CurMaterial.SetFloat("_satAmount", saturationAmount);
      CurMaterial.SetFloat("_conAmount", contrastAmount);

      Graphics.Blit(sourceTexture, destTexture, CurMaterial); //Копирует исходную текстуру в исходную текстуру с помощью шейдера.
    }
    else {
      Graphics.Blit(sourceTexture, destTexture);
    }
  }

  private void OnDisable() {
    if(curMaterial) {
      DestroyImmediate(curMaterial);
    }
  }

  Material CurMaterial {
    get {
      if (curMaterial == null) {
        curMaterial = new Material(curShader);
        curMaterial.hideFlags = HideFlags.HideAndDontSave;
      }

      return curMaterial;
    }
  }
}
