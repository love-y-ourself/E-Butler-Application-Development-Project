/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ebutler.swp.utils;

import com.ebutler.swp.dto.ConstantsDTO;
import com.ebutler.swp.dto.GoogleUserDTO;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;




/**
 *
 * @author thekh
 */
public class GoogleUtils {
    public static String getToken(final String code) throws ClientProtocolException, IOException {
        String response = Request.Post(ConstantsDTO .GOOGLE_LINK_GET_TOKEN)
                .bodyForm(Form.form().add("client_id", ConstantsDTO.GOOGLE_CLIENT_ID)
                        .add("client_secret", ConstantsDTO.GOOGLE_CLIENT_SECRET)
                        .add("redirect_uri", ConstantsDTO.GOOGLE_REDIRECT_URI).add("code", code)
                        .add("grant_type", ConstantsDTO.GOOGLE_GRANT_TYPE).build())
                .execute().returnContent().asString();
        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        String accessToken = jobj.get("access_token").toString().replaceAll("\"", "");
        return accessToken;
    }

    public static GoogleUserDTO getUserInfo(final String accessToken) throws ClientProtocolException, IOException {
        String link = ConstantsDTO.GOOGLE_LINK_GET_USER_INFO + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        GoogleUserDTO googleUser = new Gson().fromJson(response, GoogleUserDTO.class);
        return googleUser;
    }
}
