using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using SimpleJSON;

public class ProductEngine : MonoBehaviour
{
		private static ProductEngine _productEngine;
		public static List<Product> productList;
		public delegate void Callback ();

		private Callback callback;

		public static ProductEngine instance {
				get {
						if (_productEngine == null) {
								GameObject productEngineObject = GameObject.Instantiate (Resources.Load ("Prefabs/ProductEngine")) as GameObject;
								DontDestroyOnLoad (productEngineObject);
								_productEngine = productEngineObject.GetComponent<ProductEngine> ();
						}
						return _productEngine;
				}
		}

		public void RetrieveProducts ()
		{
				RetrieveProducts (new Callback (InitProduct));
		}

		public void RetrieveProducts (Callback callback, string product_model = null)
		{
				LogManager.Log ("Retrieve Products");
				WWWForm form = new WWWForm ();

				productList = new List<Product> ();
				string url = CommonConfig.API_URL + "route=game/product/products";

				if (product_model != null) {
						form.AddField ("product_model", product_model);
				}

				this.callback = callback;
				StartCoroutine (ServerEngine.PostData (url, form, new ServerEngine.Callback (CreateProductList)));
		}

		public static Product getProduct (string product_model)
		{
				foreach (Product product in productList) {
						if (product.model == product_model) {
								return product;
						}
				}

				return null;
		}

		private void CreateProductList (JSONNode data)
		{
				if (data != null) {

						JSONArray productArray = data ["product"].AsArray;

						foreach (JSONNode productNode in productArray) {
								Product product = new Product (
									productNode ["product_id"].Value,
									productNode ["name"].Value,
									productNode ["model"].Value,
									productNode ["price"].AsFloat
								);
						
								productList.Add (product);
						}
				}

				if (callback != null) {
						callback ();
				}
		}
	
		private void InitProduct ()
		{
				#if UNITY_IPHONE
				if (productList.Count > 0) {
						foreach (Product product in productList) {
							iOSPaymentEngine.addProduct (product.productId.ToString ());
						}
						InAppPurchaseManager.instance.loadStore ();
				}
				#endif
		
				#if UNITY_ANDROID
				if (productList.Count > 0) {
						foreach (Product product in productList) {
							AndroidInAppPurchaseManager.instance.addProduct(product.productId.ToString());
						}
						AndroidInAppPurchaseManager.instance.loadStore (CommonConfig.GOOGLE_PUBLIC_KEY);
				}
				#endif
		
				#if UNITY_WEBPLAYER
				#endif
		}
}
