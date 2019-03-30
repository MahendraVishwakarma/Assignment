import Foundation

public enum Result<T, U> where U:Error{
    case success(T)
    case failure(U)
}

public enum APIError:Error{
    
    case failedRequest(String?)
}

