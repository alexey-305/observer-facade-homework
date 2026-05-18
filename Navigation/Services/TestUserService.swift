import UIKit

struct User {
    let login: String
    let fullName: String
    let avatar: UIImage
    var status: String          // ← var, а не let
}

protocol UserService {
    var user: User { get set }
    func getUser(login: String) -> User?
}

extension UserService {
    func getUser(login: String) -> User? {
        return login == user.login ? user : nil
    }
}

class TestUserService: UserService {
    var user: User
    
    init() {
        let avatarImage = UIImage(named: "avatar") ?? UIImage()
        self.user = User(
            login: "1234",
            fullName: "Hipster Cat",
            avatar: avatarImage,
            status: "Waiting for something..."
        )
    }
    
    init(user: User) {
        self.user = user
    }
}

class CurrentUserService: UserService {
    var user: User
    
    init(user: User) {
        self.user = user
    }
}
