//
//  RecipesManager.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 07/06/2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
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
    // MARK: Get all recipes
    func getAllFavRecipes() -> [Recipe] {
        guard let coreDataRecipes = try? coreDataStack.viewContext.fetch(request) else {
            return []
        }
        for coreDataRecipe in coreDataRecipes {
            if let recipe = convertCoreDataRecipeToRecipe(coreDataRecipe) {
                self.recipeList.append(recipe)
            }
        }
        return recipeList
    }

    // MARK: Save a recipe in CoreData
    func addRecipesToFav(recipe: Recipe) throws {
        let coreDataRecipe = CoreDataRecipe(context: coreDataStack.viewContext)
        coreDataRecipe.uri = recipe.uri
        coreDataRecipe.label = recipe.label
        coreDataRecipe.image = recipe.image
        coreDataRecipe.source = recipe.source
        coreDataRecipe.url = recipe.url
        coreDataRecipe.ingredientLines = recipe.ingredientLines?.joined(separator: ",")
        do {
            try coreDataStack.viewContext.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }

    // MARK: Check existing recipe with url id
    func checkIfItemExist(url: String) -> Bool {
        request.predicate = NSPredicate(format: "url == %@", url)
        guard let count = try? coreDataStack.viewContext.count(for: request) else {
            return false
        }
        return count > 0
    }

    // MARK: Delete a recipe
    func deleteOneRecipes(url: String) throws {
        request.predicate = NSPredicate(format: "url == %@", url)
        if let favoriteRecipes = try? coreDataStack.viewContext.fetch(request) {
            for recipe in favoriteRecipes {
                coreDataStack.viewContext.delete(recipe)
            }
        }
        do {
            try coreDataStack.viewContext.save()
        } catch {
            throw CoreDataError.deleteFailed
        }
    }
    // MARK: Delete all recipe
    func deleteAllRecipes() throws {
        request.predicate = NSPredicate(value: true)
        if let favoriteRecipes = try? coreDataStack.viewContext.fetch(request) {
            for recipe in favoriteRecipes {
                coreDataStack.viewContext.delete(recipe)
            }
        }
        do {
            try coreDataStack.viewContext.save()
            
        } catch {
            throw CoreDataError.deleteFailed
        }
    }
//    MARK: - Helper Methods
//    Convert CoreData to Recipe
    private func convertCoreDataRecipeToRecipe(_ coreDataRecipe: CoreDataRecipe) -> Recipe? {
        guard let uri = coreDataRecipe.uri,
              let label = coreDataRecipe.label,
              let image = coreDataRecipe.image,
              let source = coreDataRecipe.source,
              let url = coreDataRecipe.url,
              let ingredientLines = coreDataRecipe.ingredientLines
        else {
            return nil
        }
        return Recipe(uri: uri,
                      label: label,
                      image: image,
                      source: source,
                      url: url,
                      ingredientLines: (ingredientLines.split(separator: ",").map { String($0) }))
        }
    }
// MARK: - CoreDataError
enum CoreDataError: Error {
    case saveFailed
    case deleteFailed
    
    var localizedDescription: String {
        switch self {
        case.saveFailed:
            return "We were unable to save the recipe."
        case.deleteFailed:
            return "We were unable to delete the recipe."
        }
    }
}
