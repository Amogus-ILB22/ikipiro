/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A SwiftUI view that manages a photo collection.
*/

import SwiftUI
import CoreData
import CloudKit

//enum TokoActiveSheet: Identifiable, Equatable {
//    #if os(iOS)
//    case photoPicker // Unavailable in watchOS.
//    #elseif os(watchOS)
//    case photoContextMenu(Photo) // .contextMenu is deprecated in watchOS, so use action list instead.
//    #endif
//    case cloudSharingSheet(CKShare)
//    case managingSharesView
//    case sharePicker(Photo)
//    case taggingView(Photo)
//    case ratingView(Photo)
//    case participantView(CKShare)
//    /**
//     Use the enumeration member name string as the identifier for Identifiable.
//     In the case where an enumeration has an associated value, use the label, which is equal to the member name string.
//     */
//    var id: String {
//        let mirror = Mirror(reflecting: self)
//        if let label = mirror.children.first?.label {
//            return label
//        } else {
//            return "\(self)"
//        }
//    }
//}
//
//enum TokoActiveCover: Identifiable, Equatable {
//    case fullImageView(Photo)
//    /**
//     Use the enumeration member name string as the identifier for Identifiable.
//     In the case where an enumeration has an associated value, use the label, which is equal to the member name string.
//     */
//    var id: String {
//        let mirror = Mirror(reflecting: self)
//        if let label = mirror.children.first?.label {
//            return label
//        } else {
//            return "\(self)"
//        }
//    }
//}

struct TokoGridView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.namaPemilik)],
                  animation: .default
    ) private var tokos: FetchedResults<Toko>
//
//    @State private var tokoActiveSheet: TokoActiveSheet?
//    @State private var tokoActiveCover: TokoActiveCover?

    /**
     The next active sheet to present after dismissing the current sheet.
     ManagingSharesView uses this variable to switch to UICloudSharingController or participant view.
     */
//    @State private var nextSheet: TokoActiveSheet?
    
    @State var openAddToko: Bool = false
    @State var openDetailToko: Bool = false
    @State var currentToko = Toko()

    
    @StateObject var tokoModel: TokoViewModel = .init()
    
    private let persistenceController = PersistenceController.shared
    private let kGridCellSize = CGSize(width: 118, height: 118)

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    if tokos.isEmpty {
                        Text("Tap the add (+) button on the iOS app to add a Toko.").padding()
                        Spacer()
                    } else {
//                        LazyVGrid(columns: [GridItem(.adaptive(minimum: kGridCellSize.width))]) {
                                ForEach(tokos, id: \.self) { toko in
                                    NavigationLink(destination: DetailTokoView(tokoModel: tokoModel)) {
                                        VStack{
                                            Text(toko.namaToko ?? "Nama Toko").foregroundColor(.white)
                                            Text(toko.namaPemilik ?? "Nama Pemilik").foregroundColor(.white)
                                            
                                        }.background(.blue)
                                            .padding()
                                    }
                                        .simultaneousGesture(TapGesture().onEnded{
                                            tokoModel.selectedToko = toko
                                        })
                                    // gridItemView(photo: photo, itemSize: kGridCellSize)
                                }
                            
//                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { openAddToko.toggle() }) {
                        Label("Add Item", systemImage: "plus").labelStyle(.iconOnly)
                    }
                }
            }
            .navigationTitle("Tokos")
//            .sheet(item: $tokoActiveSheet, onDismiss: sheetOnDismiss) { item in
//                sheetView(with: item)
//            }
            .fullScreenCover(isPresented: $openAddToko){
                
            } content: {
                AddTokoView()
            }
            .sheet(isPresented: $openDetailToko, content: {
                DetailTokoView(tokoModel: tokoModel)
//                DetailTokoView()
            })

        }
        .navigationViewStyle(.stack)
        
        .onReceive(NotificationCenter.default.storeDidChangePublisher) { notification in
            processStoreChangeNotification(notification)
        }
    }
    
//    @ViewBuilder
//    private func gridItemView(photo: Photo, itemSize: CGSize) -> some View {
//        #if os(iOS)
//        PhotoGridItemView(photo: photo, itemSize: kGridCellSize)
//            .contextMenu {
//                PhotoContextMenu(activeSheet: $tokoActiveSheet, nextSheet: $nextSheet, photo: photo)
//            }
//            .onTapGesture {
//                tokoActiveCover = .fullImageView(photo)
//            }
//        #elseif os(watchOS)
//        PhotoGridItemView(photo: photo, itemSize: kGridCellSize)
//            .onTapGesture {
//                activeSheet = .photoContextMenu(photo)
//            }
//        #endif
//    }

//    @ToolbarContentBuilder
//    private func toolbarItems() -> some ToolbarContent {
//        #if os(iOS)
//        ToolbarItem(placement: .navigationBarTrailing) {
//            Button(action: { activeSheet = .photoPicker }) {
//                Label("Add Item", systemImage: "plus").labelStyle(.iconOnly)
//            }
//        }
//        ToolbarItem(placement: .bottomBar) {
//            Button("Manage Shares") { activeSheet = .managingSharesView }
//        }
//        #elseif os(watchOS)
//        ToolbarItem(placement: .automatic) {
//            Button("Manage Shares") { activeSheet = .managingSharesView }
//        }
//        #endif
//    }

//    @ViewBuilder
//    private func sheetView(with item: TokoActiveSheet) -> some View {
//        switch item {
//        #if os(iOS)
//        case .photoPicker:
//            PhotoPicker(activeSheet: $activeSheet)
//        #elseif os(watchOS)
//        case .photoContextMenu(let photo):
//            PhotoContextMenu(activeSheet: $activeSheet, nextSheet: $nextSheet, photo: photo)
//        #endif
//
//        case .cloudSharingSheet(_):
//            /**
//             Reserve this case for something like CloudSharingSheet(activeSheet: $activeSheet, share: share).
//             */
//            EmptyView()
//        case .managingSharesView:
//            ManagingSharesView(activeSheet: $activeSheet, nextSheet: $nextSheet)
//
//        case .sharePicker(let photo):
//            AddToExistingShareView(activeSheet: $activeSheet, photo: photo)
//
//        case .taggingView(let photo):
//            TaggingView(activeSheet: $activeSheet, photo: photo)
//
//        case .ratingView(let photo):
//            RatingView(activeSheet: $activeSheet, photo: photo)
//
//        case .participantView(let share):
//            ParticipantView(activeSheet: $activeSheet, share: share)
//        }
//    }
//
//    /**
//     Present the next active sheet, if necessary.
//     Dispatch asynchronously to the next run loop so the presentation occurs after the current sheet's dismissal.
//     */
//    private func sheetOnDismiss() {
//        guard let nextActiveSheet = nextSheet else {
//            return
//        }
//        switch nextActiveSheet {
//        case .cloudSharingSheet(let share):
//            DispatchQueue.main.async {
//                persistenceController.presentCloudSharingController(share: share)
//            }
//        default:
//            DispatchQueue.main.async {
//                activeSheet = nextActiveSheet
//            }
//        }
//        nextSheet = nil
//    }
//
//    @ViewBuilder
//    private func coverView(with item: TokoActiveCover) -> some View {
//        switch item {
//        case .fullImageView(let photo):
//            FullImageView(activeCover: $activeCover, photo: photo)
//        }
//    }
    
    /**
     Merge the transactions, if any.
     */
    private func processStoreChangeNotification(_ notification: Notification) {
        let transactions = persistenceController.photoTransactions(from: notification)
        if !transactions.isEmpty {
            persistenceController.mergeTransactions(transactions, to: viewContext)
        }
    }
}
