//
//  Comment.swift
//  Flickr
//
//  Created by Maxim Nasakin on 22/06/16.
//  Copyright © 2016 Maxim Nasakin. All rights reserved.
//

import Foundation

struct Comment {
	let authorName: String
	let authorID: String
	let content: String
	
	let buddyIconURL: NSURL
}

extension Comment {
	init?(dictionary: JSONDictionary) {
		guard let
			authorName = dictionary["authorname"] as? String,
			content = dictionary["_content"] as? String,
			author = dictionary["author"] as? String else { return nil }
		
		if let iconServer = dictionary["iconserver"] as? String,
			iconFarm = dictionary["iconfarm"] as? Int where iconFarm > 0 {
			self.buddyIconURL = FlickrURL.getBuddyiconURL(iconFarm, iconServer: iconServer, nsid: author)
		} else {
			self.buddyIconURL = FlickrURL.defaultBuddyIconURL
		}
		
		self.authorName = authorName
		self.authorID = author
		self.content = content
	}
}

extension Comment {
	static func all(url: NSURL) -> Resource<[Comment]> {
		return Resource<[Comment]>(url: url) { json in
			guard let
				jsonComments = json["comments"] as? JSONDictionary,
				dictionaries = jsonComments["comment"] as? [JSONDictionary] else { return nil }
			
			return dictionaries.flatMap(Comment.init)
		}
	}
}
