import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Random "mo:base/Random";
import Nat8 "mo:base/Nat8";
// import Char "mo:base/chars";

// import Text "mo:base/Text";
// import Nat "mo:base/Nat";
import Int "mo:base/Int";
// import Random "mo:base/Random";
import Buffer "mo:base/Buffer";
import Char "mo:base/Char";
actor {

// import Random "mo:base/Random";


public shared func generatePassword() : async Text {
    let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
    let length = 12; 
    let charsArray = Buffer.fromArray<Char>(Iter.toArray(chars.chars()));
    var password = "";
    
    // Create entropy source
    let entropy = await Random.blob();
    let rand = Random.Finite(entropy);
    
    // Generate password
    var i = 0;
    while (i < length) {
        switch (rand.byte()) {
            case null { 
                // If we run out of entropy, break the loop
                i := length;
            };
            case (?b) {
                let index = Int.abs(Nat8.toNat(b)) % charsArray.size();
                password := password # Text.fromChar(charsArray.get(index));
                i += 1;
            };
        };
    };

    return password;
};


 public shared func generatePin() : async Text {
    var pin = "";
    let entropy = await Random.blob();
    let rand = Random.Finite(entropy);
    
    for (i in Iter.range(0, 3)) {
        switch (rand.byte()) {
            case null {
                // If we run out of entropy, get a new source
                let newEntropy = await Random.blob();
                let newRand = Random.Finite(newEntropy);
                switch (newRand.byte()) {
                    case null { pin := pin # "0" };  // Fallback to 0 if still null
                    case (?b) {
                        let digit = Int.abs(Nat8.toNat(b)) % 10;
                        pin := pin # Nat.toText(digit);
                    };
                };
            };
            case (?b) {
                let digit = Int.abs(Nat8.toNat(b)) % 10;
                pin := pin # Nat.toText(digit);
            };
        };
    };
    
    return pin;
};

};
