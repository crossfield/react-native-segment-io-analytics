package com.smore.RNSegmentIOAnalytics;

import android.util.Log;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.JavaScriptModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class RNSegmentIOAnalyticsPackage implements ReactPackage {

  private RNSegmentIOAnalyticsModule.Hooks mHooks;

  public RNSegmentIOAnalyticsPackage() {
    this(null);
  }

  public RNSegmentIOAnalyticsPackage(RNSegmentIOAnalyticsModule.Hooks hooks) {
    mHooks = hooks;
  }

  @Override
  public List<NativeModule> createNativeModules(
                              ReactApplicationContext reactContext) {

    Log.d("RNSegmentIOAnalytics", "Initializing RNSegmentIOAnalyticsPackage");

    List<NativeModule> modules = new ArrayList<>();

    modules.add(new RNSegmentIOAnalyticsModule(reactContext, mHooks));

    return modules;
  }

  @Override
  public List<Class<? extends JavaScriptModule>> createJSModules() {
      return Collections.emptyList();
  }

  @Override
  public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
      return Collections.emptyList();
  }
}
