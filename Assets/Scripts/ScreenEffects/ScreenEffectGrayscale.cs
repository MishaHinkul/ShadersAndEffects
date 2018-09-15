using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ScreenEffectGrayscale : MonoBehaviour {

  public Shader curShader;

  [Range(0, 1)]
  public float grayScaleAmount = 1.0f;
  private Material curMaterial;

  private void Start() {
    if (!SystemInfo.supportsImageEffects ||
        (!curShader && !curShader.isSupported)) {
      enabled = false;
    }
  }

//OnRenderImage вызывается после завершения рендеринга для рендеринга изображения.
  private void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture) {
    if (curShader != null) {
      CurMaterial.SetFloat("_LuminosityAmount", grayScaleAmount);
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
