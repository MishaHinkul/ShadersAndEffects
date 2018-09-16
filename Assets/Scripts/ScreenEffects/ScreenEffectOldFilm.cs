using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenEffectOldFilm : MonoBehaviour {

  public Shader oldFilmShader;

  public float OldFilmEffectAmount = 1.0f;

  [Header("Sepia:")]
  public Color sepiaColor = Color.white;
  public Texture2D vignetteTexture;
  public float vignetteAmount = 1.0f;

  [Header("Scratches:")]
  public Texture2D scratchesTexture;
  public float scratchesYSpeed = 10.0f;
  public float scratchesXSpeed = 10.0f;

  [Header("Dust:")]
  public Texture2D dustTexture;
  public float dustYSpeed = 10.0f;
  public float dustXSpeed = 10.0f;

  private Material curMaterial;
  private float randomValue;

  private void Start() {
    if (!SystemInfo.supportsImageEffects ||
        (!oldFilmShader && !oldFilmShader.isSupported)) {
      enabled = false;
    }
  }

//OnRenderImage вызывается после завершения рендеринга для рендеринга изображения.
  private void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture) {
    if(oldFilmShader != null) {
      CurMaterial.SetColor("_SepiaColor", sepiaColor);
      CurMaterial.SetFloat("_VignetteAmount", vignetteAmount);
      CurMaterial.SetFloat("_EffectAmount", OldFilmEffectAmount);

      if(vignetteTexture) {
        CurMaterial.SetTexture("_VignetteTex", vignetteTexture);
      }
      if(scratchesTexture) {
        CurMaterial.SetTexture("_ScratchesTex", scratchesTexture);
        CurMaterial.SetFloat("_ScratchesYSpeed", scratchesYSpeed);
        CurMaterial.SetFloat("_ScratchesXSpeed", scratchesXSpeed);
      }
      if(dustTexture) {
        CurMaterial.SetTexture("_DustTex", dustTexture);
        CurMaterial.SetFloat("_dustYSpeed", dustYSpeed);
        CurMaterial.SetFloat("_dustXSpeed", dustXSpeed);
        CurMaterial.SetFloat("_RandomValue", randomValue);
      }

      Graphics.Blit(sourceTexture, destTexture, CurMaterial);
    }
    else {
      Graphics.Blit(sourceTexture, destTexture);
    }
  }

  private void Update() {
    vignetteAmount = Mathf.Clamp01(vignetteAmount);
    OldFilmEffectAmount = Mathf.Clamp(OldFilmEffectAmount, 0f, 1.5f);
    randomValue = Random.Range(-1f,1f);
  }

  private void OnDisable() {
    if(curMaterial) {
      DestroyImmediate(curMaterial);
    }
  }

  Material CurMaterial {
    get {
      if (curMaterial == null) {
        curMaterial = new Material(oldFilmShader);
        curMaterial.hideFlags = HideFlags.HideAndDontSave;
      }

      return curMaterial;
    }
  }
}
