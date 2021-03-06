//: Playground - noun: a place where people can play

import Foundation
import XCPlayground
import reddift

guard #available(iOS 9, OSX 10.10, *) else { abort() }

func getCAPTCHA(session: Session) {
    do {
        try session.getCAPTCHA({ (result) -> Void in
            switch result {
            case .Failure(let error):
                print(error)
            case .Success(let captchaImage):
                captchaImage
            }
        })
    } catch { print(error) }
}

func getReleated(session: Session) {
    do {
        try session.getDuplicatedArticles(Paginator(), thing: Link(id: "37lhsm")) { (result) -> Void in
            switch result {
            case .Failure(let error):
                print(error)
            case .Success(let listing1, let listing2):
                listing1.children.flatMap { $0 as? Link }.forEach { print($0.title) }
                listing2.children.flatMap { $0 as? Link }.forEach { print($0.title) }
            }
        }
    } catch { print(error) }
}

func getProfile(session: Session) {
    do {
        try session.getUserProfile("sonson_twit", completion: { (result) -> Void in
            switch result {
            case .Failure(let error):
                print(error)
            case .Success(let account):
                print(account.name)
            }
        })
    } catch { print(error) }
}

func getLinksBy(session: Session) {
    do {
        let links: [Link] = [Link(id: "37ow7j"), Link(id: "37nvgu")]
        try session.getLinksById(links, completion: { (result) -> Void in
            switch result {
            case .Failure(let error):
                print(error)
            case .Success(let listing):
                listing.children.flatMap { $0 as? Link }.forEach { print($0.title) }
            }
        })
    } catch { print(error) }
}

func searchSubreddits(session: Session) {
    do {
        try session.getSubredditSearch("apple", paginator: Paginator(), completion: { (result) -> Void in
            switch result {
            case .Failure(let error):
                print(error)
            case .Success(let listing):
                listing.children.flatMap { $0 as? Subreddit }.forEach { print($0.title) }
            }
        })
    } catch { print(error) }
}

func searchContents(session: Session) {
    do {
        try session.getSearch(nil, query: "apple", paginator: Paginator(), sort: .New, completion: { (result) -> Void in
            switch result {
            case .Failure(let error):
                print(error)
            case .Success(let listing):
                listing.children.flatMap { $0 as? Link }.forEach { print($0.title) }
            }
        })
    } catch { print(error) }
}

func getAccountInfoFromJSON(json: [String:String]) -> (String, String, String, String)? {
    if let username = json["username"], password = json["password"], client_id = json["client_id"], secret = json["secret"] {
        return (username, password, client_id, secret)
    }
    return nil
}

func getSubreddits(session: Session) {
    do {
        try session.getSubreddit(.New, paginator: nil, completion: { (result) in
            switch result {
            case .Failure(let error):
                print(error)
            case .Success(let listing):
                let _ = listing.children.flatMap({ $0 as? Subreddit })
            }
        })
    } catch { print(error) }
}

if let (username, password, clientID, secret) = (NSBundle.mainBundle().URLForResource("test_config.json", withExtension:nil)
    .flatMap { NSData(contentsOfURL: $0) }
    .flatMap { try! NSJSONSerialization.JSONObjectWithData($0, options:NSJSONReadingOptions()) as? [String:String] }
    .flatMap { getAccountInfoFromJSON($0) }) {
        do {
            try OAuth2AppOnlyToken.getOAuth2AppOnlyToken(username: username, password: password, clientID: clientID, secret: secret, completion:({ (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let token):
                    let session = Session(token: token)
//                    getSubreddits(session)
//                    getLinksBy(session)
//                    getReleated(session)
//                    getCAPTCHA(session)
//                    searchContents(session)
//                    searchSubreddits(session)
                }
            }))
        } catch { print(error) }
}

let anonymouseSession = Session()
getSubreddits(anonymouseSession)
getLinksBy(anonymouseSession)

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

    
