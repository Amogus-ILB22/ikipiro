/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A SwiftUI view that picks an existing share.
*/

import SwiftUI
import CoreData
import CloudKit

struct SharePickerView<ActionView: View>: View {
    @Binding private var activeSheet: ShareSheet?
    @Binding private var selection: String?
    
    private let actionView: ActionView
    @State private var shareTitles = PersistenceController.shared.shareTitles()

    init(activeSheet: Binding<ShareSheet?>, selection: Binding<String?>, @ViewBuilder actionView: () -> ActionView) {
        _activeSheet = activeSheet
        _selection = selection
        self.actionView = actionView()
    }

    var body: some View {
        NavigationView {
            VStack {
               if shareTitles.isEmpty {
                   Text("Anda belum membagikan data, silakan tambahkan pembagian yang baru").padding()
                   Spacer()
               } else {
                   Form {
                       Section(header: Text("Pilih Pembagian Data")) {
                           ShareListView(selection: $selection, shareTitles: $shareTitles)
                       }
                       Section {
                           actionView
                       }
                   }
               }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        activeSheet = nil
                    }, label: {
                        Text("Batal")
                    })
                    .foregroundColor(Color("sunray"))
                }
            }
            .listStyle(.plain)
            .navigationTitle("Pembagian Data")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onReceive(NotificationCenter.default.storeDidChangePublisher) { notification in
            processStoreChangeNotification(notification)
        }
    }
    
    /**
     Update the share list, if necessary. Ignore the notification in the following cases:
     - The notification isn't relevant to the private database.
     - The notification transaction isn't empty. When a share changes, Core Data triggers a store remote change notification with no transaction.
     */
    private func processStoreChangeNotification(_ notification: Notification) {
        guard let storeUUID = notification.userInfo?[UserInfoKey.storeUUID] as? String,
              storeUUID == PersistenceController.shared.privatePersistentStore.identifier else {
            return
        }
        guard let transactions = notification.userInfo?[UserInfoKey.transactions] as? [NSPersistentHistoryTransaction],
              transactions.isEmpty else {
            return
        }
        shareTitles = PersistenceController.shared.shareTitles()
    }

}

private struct ShareListView: View {
    @Binding var selection: String?
    @Binding var shareTitles: [String]

    var body: some View {
        List(shareTitles, id: \.self) { shareTitle in
            HStack {
                Text(shareTitle)
                Spacer()
                if selection == shareTitle {
                    Image(systemName: "checkmark")
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selection = (selection == shareTitle) ? nil : shareTitle
            }
        }
    }
}

