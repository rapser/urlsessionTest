//
//  ViewController.swift
//  webserviceTest
//
//  Created by miguel tomairo on 8/16/20.
//  Copyright © 2020 rapser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let user = "test"
    let password = "1234"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }


    func getData() {
        
        guard let url = URL(string: "http://app-puntos-285220.uc.r.appspot.com/token") else {
            print("Invalid URL")
            return
        }

        guard let encoded = try? JSONEncoder().encode(tokenRequest(user: user, password: password)) else {
            print("Failed to encode data")
         return()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encoded

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
               print("error \(httpResponse.statusCode)")
            }
            
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Token.self, from: data) {
                    // we have good data – go back to the main thread
                    print("token: \(decodedResponse.access_token)")
                    DispatchQueue.main.async {
                        // update our UI
//                        self.results = decodedResponse.loginResults
                    }

                    return
                }

            }
            
            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
}

struct Token: Codable {
    let access_token: String
}

struct serverResponse: Codable {
    var loginResults: [loginResult]
}

struct loginResult: Codable {
    var correctCredentials: Bool
    var message: String
}

struct tokenRequest: Codable {
    var user: String
    var password: String
}
