/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import okhttp3.*;
import org.json.JSONObject;
import java.util.concurrent.TimeUnit;

public class AIQueryConverter {
    private static final String API_URL = "https://api.cohere.ai/v1/generate";
    private static final String API_KEY = "Bearer Ezgv1Uw8SRTzY6jhyCRaaIs24n6KWXMCL5TBdHL6";

    public static String convertToSQL(String userQuery, String tableName, String columns) throws Exception {
        OkHttpClient client = new OkHttpClient.Builder()
                .connectTimeout(30, TimeUnit.SECONDS)
                .readTimeout(30, TimeUnit.SECONDS)
                .writeTimeout(30, TimeUnit.SECONDS)
                .build();

        String prompt = "The user query is in Vietnamese or in English.\n"
                + "Convert this natural language query into an accurate SQL query using the correct schema:\n"
                + "Table: " + tableName + " (Columns: " + columns + ")\n"
                + "Query: " + userQuery + "\n"
                + "Rules:\n"
                + "- Only apply filters explicitly requested in the query.\n"
                + "- Return ONLY the SQL query, nothing else.";

        JSONObject json = new JSONObject();
        json.put("model", "command");
        json.put("prompt", prompt);

        RequestBody body = RequestBody.create(MediaType.parse("application/json"), json.toString());
        Request request = new Request.Builder()
                .url(API_URL)
                .addHeader("Authorization", API_KEY)
                .addHeader("Content-Type", "application/json")
                .post(body)
                .build();

        Response response = client.newCall(request).execute();
        String jsonResponse = response.body().string();
        JSONObject responseObject = new JSONObject(jsonResponse);
        System.out.println("JSON từ Cohere:\n" + jsonResponse);

        return responseObject.getJSONArray("generations").getJSONObject(0).getString("text").trim();
    }
}

