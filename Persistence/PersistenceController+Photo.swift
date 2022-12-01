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

    
    func delete(photo: Photo) {
        if let context = photo.managedObjectContext {
            context.perform {
                context.delete(photo)
                context.save(with: .deletePhoto)
            }
        }
    }
    
    func photoTransactions(from notification: Notification) -> [NSPersistentHistoryTransaction] {
        var results = [NSPersistentHistoryTransaction]()
        if let transactions = notification.userInfo?[UserInfoKey.transactions] as? [NSPersistentHistoryTransaction] {
            let photoEntityName = Photo.entity().name
            for transaction in transactions where transaction.changes != nil {
                for change in transaction.changes! where change.changedObjectID.entity.name == photoEntityName {
                    results.append(transaction)
                    break // Jump to the next transaction.
                }
            }
        }
        return results
    }
    
    func mergeTransactions(_ transactions: [NSPersistentHistoryTransaction], to context: NSManagedObjectContext) {
        context.perform {
            for transaction in transactions {
                context.mergeChanges(fromContextDidSave: transaction.objectIDNotification())
            }
        }
    }
}
