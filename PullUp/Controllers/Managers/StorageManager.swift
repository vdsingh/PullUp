//
//  StorageManager.swift
//  PullUp
//
//  Created by Vikram Singh on 5/2/22.
//

import Foundation
import FirebaseStorage

public typealias UploadPictureCompletion = (Result<String,Error>) -> Void

final class StorageManager {
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
    public func uploadProfilePicture(data: Data, fileName: String, completion: @escaping (Result<String,Error>) -> Void){
        storage.child("images/\(fileName)").putData(data, metadata: nil) { metadata, error in
            guard error == nil else{
                //failed
                print("ERROR: failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else{
                    print("ERROR: failed to get download URL")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString
                print("LOG: download URL return: \(urlString)")
                completion(.success(urlString))
            }
            
        }
    }
    
//    public static func downloadImage(profilePictureURL: String) -> UIImage{
//        let url = URL(string: profilePictureURL)
//        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//        if data == nil {
//            print("ERROR: data was nil when trying to download image")
//            return UIImage(systemName: "person") ?? UIImage()
//        }
//        return UIImage(data: data!)!
//    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadURL
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        
        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadURL))
                return
            }
            
            completion(.success(url))
        })
    }
}
