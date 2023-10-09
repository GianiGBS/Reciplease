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
    var favRecipes: [Recipe] = []
    private let coreDataStack: CoreDataStack
    private let request: NSFetchRequest<CoreDataRecipe> = CoreDataRecipe.fetchRequest()
    public weak var delegate: ViewDelegate?

    // MARK: - Init
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }
    // MARK: - Methods

    // MARK: Get all recipes
    func fetchFavRecipes() -> [Recipe] {
        favRecipes.removeAll()
        guard let coreDataRecipes = try? coreDataStack.viewContext.fetch(request) else {
            return []
        }
        for coreDataRecipe in coreDataRecipes {
            if let recipe = convertCoreDataRecipeToRecipe(coreDataRecipe) {
                self.favRecipes.append(recipe)
            }
        }
        return favRecipes
    }

    // MARK: - Refresh CoreData
        func refresh() {
            // Erase all Recipes form list
            favRecipes.removeAll()
            // Fetch all fav recipes from CoreData
            if let coreDataRecipes = try? coreDataStack.viewContext.fetch(request) {
                for coreDataRecipe in coreDataRecipes {
                    if let recipe = convertCoreDataRecipeToRecipe(coreDataRecipe) {
                        // Add all Recipes to list
                        favRecipes.append(recipe)
                    }
                }
            }
            delegate?.updateView()
        }

    // MARK: Save a recipe in CoreData
    func addRecipeToFav(recipe: Recipe) throws {
        if let recipeUrl = recipe.url {
            if checkIfItemExist(url: recipeUrl) {
                // If item exist delete first
                try deleteOneRecipeFromFav(url: recipeUrl)
            }
        }
        let coreDataRecipe = CoreDataRecipe(context: coreDataStack.viewContext)
        coreDataRecipe.uri = recipe.uri
        coreDataRecipe.label = recipe.label
        coreDataRecipe.image = recipe.image
        coreDataRecipe.source = recipe.source
        coreDataRecipe.url = recipe.url
        coreDataRecipe.yield = Int32(recipe.yield ?? 0)
        coreDataRecipe.ingredientLines = recipe.ingredientLines?.joined(separator: ",")
        coreDataRecipe.totalTime = Int32(recipe.totalTime ?? 0)
        do {
            try coreDataStack.viewContext.save()
        } catch {
            throw CoreDataError.saveFailed
        }
        refresh()
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
    func deleteOneRecipeFromFav(url: String) throws {
        request.predicate = NSPredicate(format: "url == %@", url)
        if let favoriteRecipes = try? coreDataStack.viewContext.fetch(request) {
            for recipe in favoriteRecipes {
                coreDataStack.viewContext.delete(recipe)
            }
        }
        do {
            try coreDataStack.viewContext.save()
            refresh()
        } catch {
            throw CoreDataError.deleteFailed
        }
        refresh()
    }
    // MARK: Delete all recipe
    func deleteAllRecipesFromFav() throws {
        request.predicate = NSPredicate(value: true)
        if let favoriteRecipes = try? coreDataStack.viewContext.fetch(request) {
            for recipe in favoriteRecipes {
                coreDataStack.viewContext.delete(recipe)
            }
        }
        do {
            try coreDataStack.viewContext.save()
            refresh()
        } catch {
            throw CoreDataError.deleteFailed
        }
    }
    // MARK: - Helper Methods
//    Convert CoreDataRecipe to Recipe
    private func convertCoreDataRecipeToRecipe(_ coreDataRecipe: CoreDataRecipe?) -> Recipe? {
        guard let coreDataRecipe = coreDataRecipe else {
            return nil
        }
        return Recipe(uri: coreDataRecipe.uri ?? "",
                      label: coreDataRecipe.label ?? "",
                      image: coreDataRecipe.image ?? "",
                      source: coreDataRecipe.source ?? "",
                      url: coreDataRecipe.url ?? "",
                      yield: Int(coreDataRecipe.yield),
                      ingredientLines: coreDataRecipe.ingredientLines?.split(separator: ",").map { String($0) },
                      totalTime: Int(coreDataRecipe.totalTime))
        }
    }
// MARK: - CoreDataError
enum CoreDataError: Error {
    case invalidRecipe
    case saveFailed
    case deleteFailed
    var localizedDescription: String {
        switch self {
        case.invalidRecipe:
            return "Recipe already exist"
        case.saveFailed:
            return "We were unable to save the recipe."
        case.deleteFailed:
            return "We were unable to delete the recipe."
        }
    }
}
