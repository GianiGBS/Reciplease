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
    var recipeList: [Recipe] = []
    
    private let coreDataStack: CoreDataStack
    private let request: NSFetchRequest<CoreDataRecipe> = CoreDataRecipe.fetchRequest()
    public weak var delegate: ViewDelegate?
    
    // MARK: - Init
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }
    // MARK: - Methods
    // MARK: Get a recipe
    func getRecipes() -> [Recipe] {
//        let request: NSFetchRequest<CoreDataRecipe> = CoreDataRecipe.fetchRequest()
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
    func addRecipesToFav(recipe: Recipe) {
        let coreDataRecipe = CoreDataRecipe(context: coreDataStack.viewContext)
        coreDataRecipe.uri = recipe.uri
        coreDataRecipe.label = recipe.label
        coreDataRecipe.image = recipe.image
        coreDataRecipe.source = recipe.source
        coreDataRecipe.url = recipe.url
        coreDataRecipe.ingredientLines = recipe.ingredientLines?.joined(separator: ",")
        do {
            try coreDataStack.viewContext.save()
//            completion()
        } catch {
            print("We are unable to save \(coreDataRecipe)")
        }
    }
    // MARK: Check existing recipe with url id
    func checkIfItemExist(url: String) -> Bool {
//        let request: NSFetchRequest<CoreDataRecipe> = CoreDataRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)
        guard let count = try? coreDataStack.viewContext.count(for: request) else {
            return false
        }
        return count > 0
    }
    // MARK: Delete a recipe
    func deleteOneRecipes(url: String) {
//        let request: NSFetchRequest<CoreDataRecipe> = CoreDataRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)
        if let favoriteRecipes = try? coreDataStack.viewContext.fetch(request) {
            for recipe in favoriteRecipes {
                coreDataStack.viewContext.delete(recipe)
            }
        }
        do { try coreDataStack.viewContext.save() }
        catch { print("We are unable to save ") }
    }
    // MARK: Delete all recipe
    func deleteAllRecipes() {
//        let request: NSFetchRequest<CoreDataRecipe> = CoreDataRecipe.fetchRequest()
        request.predicate = NSPredicate(value: true)
        if let favoriteRecipes = try? coreDataStack.viewContext.fetch(request) {
            for recipe in favoriteRecipes {
                coreDataStack.viewContext.delete(recipe)
            }
        }
        do { try coreDataStack.viewContext.save() }
        catch { print("We are unable to save ")}
    }

}
