using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using UnityEngine.UIElements;

public class UI : MonoBehaviour
{

    public WFC wfc_engine;

    private void OnEnable()
    {
        VisualElement root = GetComponent<UIDocument>().rootVisualElement;

        Button button_restart = root.Q<Button>("RestartButton");
        Button button_clear = root.Q<Button>("ClearButton");
        SliderInt slider_land_weight = root.Q<SliderInt>("LandWeight");
        SliderInt slider_water_weight = root.Q<SliderInt>("WaterWeight");
        SliderInt slider_coast_weight = root.Q<SliderInt>("CoastWeight");
        SliderInt slider_river_weight = root.Q<SliderInt>("RiverWeight");
        SliderInt slider_mountain_weight = root.Q<SliderInt>("MountainWeight");
        SliderInt slider_forest_weight = root.Q<SliderInt>("ForestWeight");
        TextField textfield_num_seeds = root.Q<TextField>("NumSeeds");

        button_restart.clicked += () => wfc_engine.initiateRestart();
        button_clear.clicked += () => wfc_engine.initiateClear();

        slider_land_weight.RegisterValueChangedCallback(LandWeightSliderCallback);
        slider_water_weight.RegisterValueChangedCallback(WaterWeightSliderCallback);
        slider_coast_weight.RegisterValueChangedCallback(CoastWeightSliderCallback);
        slider_river_weight.RegisterValueChangedCallback(RiverWeightSliderCallback);
        slider_mountain_weight.RegisterValueChangedCallback(MountainWeightSliderCallback);
        slider_forest_weight.RegisterValueChangedCallback(ForestWeightSliderCallback);


        textfield_num_seeds.RegisterValueChangedCallback(NumSeedsTextFieldCallback);
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void LandWeightSliderCallback(ChangeEvent<int> evt)
    {
        wfc_engine.setTileWeight(0, evt.newValue);
    }

    private void WaterWeightSliderCallback(ChangeEvent<int> evt)
    {
        wfc_engine.setTileWeight(6, evt.newValue);
    }

    private void CoastWeightSliderCallback(ChangeEvent<int> evt)
    {
        wfc_engine.setTileWeight(12, evt.newValue);
        wfc_engine.setTileWeight(18, evt.newValue);
        wfc_engine.setTileWeight(24, evt.newValue);
        wfc_engine.setTileWeight(30, evt.newValue);
        wfc_engine.setTileWeight(36, evt.newValue);
    }

    private void RiverWeightSliderCallback(ChangeEvent<int> evt)
    {
        wfc_engine.setTileWeight(114, evt.newValue);
        wfc_engine.setTileWeight(120, evt.newValue);
    }

    private void MountainWeightSliderCallback(ChangeEvent<int> evt)
    {
        wfc_engine.setTileWeight(42, evt.newValue);
    }

    private void ForestWeightSliderCallback(ChangeEvent<int> evt)
    {
        wfc_engine.setTileWeight(78, evt.newValue);
    }

    private void NumSeedsTextFieldCallback(ChangeEvent<string> evt)
    {
        int new_numSeeds = 5;
        if (Int32.TryParse(evt.newValue, out new_numSeeds))
        {
            wfc_engine.setSeedNumber(new_numSeeds);
        }
    }
}
