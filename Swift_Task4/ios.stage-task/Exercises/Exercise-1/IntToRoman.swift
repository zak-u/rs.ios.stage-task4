import Foundation

public extension Int {
    
    var roman: String? {
        var intValue = self;
        if(intValue > 0 && intValue < 4000){
            let dictionary = ["1":"I", "5": "V", "10":"X","50":"L", "100": "C", "500":"D", "1000": "M"];
            var roman = "";
            var currentValue : Int;
            var currentRoman = "";
            var category = 1;
            
            while(intValue>0){
                currentValue = (intValue % 10)*category;
                switch currentValue {
                    case 1*category..<4*category:
                        currentRoman = dictionary[String(category)]!
                        var i = 1;
                        while( currentValue != category * i) {
                            currentRoman = currentRoman + dictionary[String(category)]!
                            i = i+1
                        }
                    case 4*category:
                        currentRoman = dictionary[String(category)]! + dictionary[String(category*5)]!
                    case 5*category..<9*category:
                        currentRoman = dictionary[String(category*5)]!
                        var i = 5;
                        while( currentValue != category * i) {
                            currentRoman = currentRoman + dictionary[String(category)]!
                            i = i+1
                        }
                    case 9*category:
                        currentRoman = dictionary[String(category)]!+dictionary[String(category*10)]!
                    default: currentRoman = ""
                }
                roman = currentRoman+roman;
                intValue = intValue/10;
                category = category * 10;
            }
            return roman
        }else{
            return nil
        }
    }
}
