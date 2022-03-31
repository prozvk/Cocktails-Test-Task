//
//  ApiManager.swift
//  Cocktails
//
//  Created by MacPro on 29.03.2022.
//

import Foundation
import Alamofire

class ApiManager {
    static let shared = ApiManager()
    
    func alamofireRequest(completion: @escaping ([Cocktail]) -> Void) -> Void {
        AF.request("https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Non_Alcoholic").responseDecodable(of: Drinks.self) { response in
            
            switch response.result {
            case .success(let drinks):
                completion(drinks.drinks)
            
            case .failure(let error):
                print(error)
            }
        }
    }
}
