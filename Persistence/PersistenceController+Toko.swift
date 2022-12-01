/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An extension that wraps the related methods for managing photos.
*/

import Foundation
import CoreData

// MARK: - Convenient methods for managing photos.
//
extension PersistenceController {
    func addToko(namaToko: String, namaPemilik: String, context: NSManagedObjectContext) {
        context.perform {
            let toko = Toko(context: context)
            toko.namaToko = namaToko
            toko.namaPemilik = namaPemilik
            
            context.save(with: .addToko)
        }
    }

    func deleteToko(toko: Toko) {
        
        
        if let context = toko.managedObjectContext {
            context.perform {
                context.delete(toko)
                context.save(with: .deleteToko)
            }
        }
    }

    func tokoTransactions(from notification: Notification) -> [NSPersistentHistoryTransaction] {
        var results = [NSPersistentHistoryTransaction]()
        if let transactions = notification.userInfo?[UserInfoKey.transactions] as? [NSPersistentHistoryTransaction] {
            let tokoEntityName = Toko.entity().name
            for transaction in transactions where transaction.changes != nil {
                for change in transaction.changes! where change.changedObjectID.entity.name == tokoEntityName {
                    results.append(transaction)
                    break // Jump to the next transaction.
                }
            }
        }
        return results
    }

    func tokoMergeTransactions(_ transactions: [NSPersistentHistoryTransaction], to context: NSManagedObjectContext) {
        context.perform {
            for transaction in transactions {
                context.mergeChanges(fromContextDidSave: transaction.objectIDNotification())
            }
        }
    }
}
