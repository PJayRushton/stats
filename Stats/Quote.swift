//
//  Quote.swift
//  Stats
//
//  Created by Parker Rushton on 5/10/17.
//  Copyright © 2017 AppsByPJ. All rights reserved.
//

import Foundation
import Firebase
import Marshal

struct Quote: Identifiable, Equatable {
    
    var id: String
    var text: String
    var source: String
    
    var ref: FIRDatabaseReference {
        return StatsRefs.quotesRef.child(id)
    }
    
}

extension Quote: Unmarshaling {
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: idKey)
        text = try object.value(for: textKey)
        source = try object.value(for: sourceKey)
    }
    
}

extension Quote: Marshaling {
    
    func marshaled() -> JSONObject {
        var json = JSONObject()
        json[idKey] = id
        json[textKey] = text
        json[sourceKey] = source
        
        return json
    }
    
}

/*
let quote1 = Quote(id: StatsRefs.quotesRef.childByAutoId().key, text: "Love is the most important thing in the world, but baseball is pretty good, too.", source: "Yogi Berra")
let quote2 = Quote(id: StatsRefs.quotesRef.childByAutoId().key, text: "Little League baseball is a very good thing because it keeps the parents off the streets.", source: "Yogi Berra")
let quote3 = Quote(id: StatsRefs.quotesRef.childByAutoId().key, text: "You could be a kid for as long as you want when you play baseball.", source: "Cal Ripkin Jr.")
let quote4 = Quote(id: StatsRefs.quotesRef.childByAutoId().key, text: "I'd walk through hell in a gasoline suit to play baseball.", source: "Pete Rose")
let quote5 = Quote(id: StatsRefs.quotesRef.childByAutoId().key, text: "There are only two seasons - winter and Baseball.", source: "Bill Veeck")
let quote6 = Quote(id: StatsRefs.quotesRef.childByAutoId().key, text: "There are three things you can do in a baseball game. You can win, or you can lose, or it can rain.", source: "Casey Stengel")
let quote7 = Quote(id: StatsRefs.quotesRef.childByAutoId().key, text: "Baseball is like a poker game. Nobody wants to quit when he's losing; nobody wants you to quit when you're ahead.", source: "Jackie Robinson")
let quote8 = Quote(id: StatsRefs.quotesRef.childByAutoId().key, text: "I just want to play baseball.", source: "David Ortiz")

let allQuotes = [quote1, quote2, quote3, quote4, quote5, quote6, quote7, quote8]
*/
