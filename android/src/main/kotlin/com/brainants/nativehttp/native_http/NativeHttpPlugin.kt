package com.brainants.nativehttp.native_http

import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject
import java.io.IOException


/** NativeHttpPlugin */
public class NativeHttpPlugin : FlutterPlugin, MethodCallHandler {
    var client = OkHttpClient()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

        val channel = MethodChannel(flutterPluginBinding.flutterEngine.dartExecutor, "native_http")
        channel.setMethodCallHandler(NativeHttpPlugin())
    }

    companion object {

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "native_http")
            channel.setMethodCallHandler(NativeHttpPlugin())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "native_http/request") {
            val url = call.argument<String>("url")!!
            val method = call.argument<String>("method")!!
            var headers = call.argument<HashMap<String, Any>>("headers")
            var body = call.argument<HashMap<String, Any>>("body")
            if (headers == null) headers = HashMap()
            if (body == null) body = HashMap()
            sendRequest(url, method, headers, body, result)
        } else {
            result.notImplemented()
        }
    }

    val JSON: MediaType = "application/json; charset=utf-8".toMediaType()

    fun sendRequest(url: String, method: String, headers: HashMap<String, Any>, body: HashMap<String, Any>, @NonNull result: Result) {
        val requestBody: RequestBody = JSONObject(body).toString().toRequestBody(JSON)
        var requestBuilder: Request.Builder = Request.Builder()
                .url(url)
        headers.entries.forEach {
            requestBuilder = requestBuilder.addHeader(it.key, it.value as String)
        }

        if (method != "GET")
            requestBuilder = requestBuilder.method(method, requestBody)

        val request = requestBuilder.build()
        val mHandler = Handler(Looper.getMainLooper())
        client.newCall(request).enqueue(
                object : Callback {

                    override fun onFailure(call: Call, e: IOException) {
                        mHandler.post {
                            result.error(e.message, e.localizedMessage, null)
                        }
                    }

                    override fun onResponse(call: Call, r: Response) {
                        val response = HashMap<String, Any>()
                        response["code"] = r.code
                        response["body"] = r.body!!.string()
                        mHandler.post {
                            result.success(response)
                        }
                    }
                }
        )
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }
}
