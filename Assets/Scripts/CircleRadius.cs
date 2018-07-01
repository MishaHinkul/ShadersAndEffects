﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CircleRadius : MonoBehaviour {
  public Material radiusMaterial;
  public float radius = 1;
  public Color color = Color.white;

  private void Update() {
    radiusMaterial.SetVector("_Center", transform.position);
    radiusMaterial.SetFloat("_Radius", radius);
    radiusMaterial.SetColor("_RadiusColor", color);
  }

}
