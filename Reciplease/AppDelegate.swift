//
//  AppDelegate.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 21/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer ?? NSPersistentContainer()
    }

    static var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func application(
        _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [
        UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Reciplease")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

    static func saveCurrentState(withCoder coder: NSCoder) {
        coder.encodeCInt(Int32(RecipesService.shared.selectedRow), forKey: "SelectedRowService")
        coder.encodeCInt(Int32(CDRecipe.selectedRow), forKey: "SelectedRowFavorites")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(RecipesService.shared.getRecipes()) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedRecipes")
        }
        if let encoded = try? encoder.encode(UserIngredients.shared) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "UserIngredients")
        }
    }

    static func restoreCurrentState(withCoder coder: NSCoder) {
        RecipesService.shared.selectedRow = Int(coder.decodeInt32(forKey: "SelectedRowService"))
        CDRecipe.selectedRow = Int(coder.decodeInt32(forKey: "SelectedRowFavorites"))
        let defaults = UserDefaults.standard
        if let savedRecipes = defaults.object(forKey: "SavedRecipes") as? Data {
            let decoder = JSONDecoder()
            if let loadedRecipes = try? decoder.decode(Recipes.self, from: savedRecipes) {
                RecipesService.shared.setRecipes(withRecipes: loadedRecipes)
            }
        }
        if let savedUserIngredients = defaults.object(forKey: "UserIngredients") as? Data {
            let decoder = JSONDecoder()
            if let loadedUserIngredients = try? decoder.decode(UserIngredients.self, from: savedUserIngredients) {
                UserIngredients.shared = loadedUserIngredients
            }
        }
    }

}
