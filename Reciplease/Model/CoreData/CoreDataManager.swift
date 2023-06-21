//
//  RecipesManager.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 07/06/2023.
//

import Foundation
import CoreData

class CoreDataManager { //    TODO: covertir obj RecipeCD en Recipe
    
    // MARK: - Properties
    var coreDatarecipeList: [CoreDataRecipe] = []
    var recipeList: [Recipe] = []
    
    private let coreDataStack: CoreDataStack
    public weak var delegate: ViewDelegate?
    
    // MARK: - Init
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }
    // MARK: - Methods
    // MARK: Get a recipe
    func getRecipes() -> [Recipe] {
        let request: NSFetchRequest<CoreDataRecipe> = CoreDataRecipe.fetchRequest()
        guard let coreDataRecipes = try? coreDataStack.viewContext.fetch(request) else {
            return []
        }
        for coreDataRecipe in coreDataRecipes {
            if let uri = coreDataRecipe.uri,
               let label = coreDataRecipe.label,
               let image = coreDataRecipe.image,
               let source = coreDataRecipe.source,
               let url = coreDataRecipe.url,
               let ingredientLines = coreDataRecipe.ingredientLines
            {
                let recipe = Recipe(uri: uri,
                                    label: label,
                                    image: image,
                                    source: source,
                                    url: url,
                                    ingredientLines: (ingredientLines.split(separator: ",").map { String($0) }))
                self.recipeList.append(recipe)
            }
        }
        return recipeList
    }

    // MARK: Save a recipe in CoreData
    func addRecipes(uri: String, label: String, image: String, source: String, url: String, ingredientLines: String, completion: () -> Void) {
        let coreDataRecipe = CoreDataRecipe(context: coreDataStack.viewContext)
        coreDataRecipe.uri = uri
        coreDataRecipe.label = label
        coreDataRecipe.image = image
        coreDataRecipe.source = source
        coreDataRecipe.url = url
        coreDataRecipe.ingredientLines = ingredientLines
        do {
            try coreDataStack.viewContext.save()
            completion()
        } catch {
//            self.delegate?.presentAlert(title: "Echec de la sauvegarde",
//                                        message: "Nous n'avons pas réussi à sauvegarde votre recette.\n Veuillez réessayer.")
            print("We are unable to save \(coreDataRecipe)")
        }
        
        
    }
    // MARK: Delete a recipe
    func deleteRecipes() {
        
    }

}
