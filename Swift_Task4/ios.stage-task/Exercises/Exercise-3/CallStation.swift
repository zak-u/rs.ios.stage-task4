import Foundation

final class CallStation {
    var usersArray : [User] = []
    var callsArray : [Call] = []
}

extension CallStation: Station {
    func users() -> [User] {
        return usersArray;
    }
    
    func add(user: User) {
        if (!usersArray.contains(user)){
            usersArray.append(user)
        }

    }
    
//    func remove(user: User) {
//
//        if let i = usersArray.firstIndex(of: user) {
//            usersArray.remove(at: i)
//        }
//
//    }
    
    func calls() -> [Call] {
        return callsArray;
    }
    
    func calls(user: User) -> [Call] {
        
        if(usersArray.contains(user)){
            var usersCalls = [Call]()
            for call in callsArray {
                if(call.incomingUser == user || call.outgoingUser == user){
                    usersCalls.append(call)
                    }
            }
            return usersCalls
        }else {
            return  []
        }
    }
    
    func remove(user: User) {
        if let i = usersArray.firstIndex(of: user) {
            for call in calls(user: user) {
                if(call.status == .talk || call.status == .calling){
                    if let callIndex = callsArray.firstIndex(where: { $0.id == call.id }){
                        callsArray[callIndex].status = .ended(reason: .error)
                    }
                }
            }
            usersArray.remove(at: i)
        }

    }
    
    func call(id: CallID) -> Call? {
        for call in callsArray{
            if(call.id == id){
                return call
            }
        }
        return nil
    }
    
    func currentCall(user: User) -> Call? {
        for call in callsArray{
            if((call.status == .calling) &&
                (call.incomingUser == user || call.outgoingUser == user)){
                        return call
                }
            }
        return nil
    }
    func execute(action: CallAction) -> CallID? {
        switch action {
        case let .start(from,to):
            let newCall : Call
            if(usersArray.contains(from) && usersArray.contains(to)){
                for userCall in calls(user:to) {
                    if(userCall.status == .talk || userCall.status == .calling){
                        newCall = Call(id: UUID(), incomingUser: from, outgoingUser: to, status: .ended(reason: .userBusy))
                        callsArray.append(newCall)
                        return newCall.id
                    }
                }
                newCall = Call(id: UUID(), incomingUser: from, outgoingUser: to, status: CallStatus.calling)
                callsArray.append(newCall)
                return newCall.id
            }else if(usersArray.contains(from) && !usersArray.contains(to)){
                newCall = Call(id: UUID(), incomingUser: from, outgoingUser: to, status: .ended(reason: .error))
                callsArray.append(newCall)
                return newCall.id
            }else {
                return nil
            }
        case let .answer(from):
            if(usersArray.contains(from)){
                if let call = currentCall(user: from){
                    if let callIndex = callsArray.firstIndex(where: { $0.id == call.id }){
                        callsArray[callIndex].status = .talk
                        return call.id
                    }else{
                        return nil
                    }
                }else{
                    return nil
                }
            }else {
                return nil
            }
        case let .end(from):
            if(usersArray.contains(from)){
                for call in calls(user: from){
                    if(call.status == .talk || call.status == .calling){
                        if let callIndex = callsArray.firstIndex(where: { $0.id == call.id }){
                            if(call.status == .talk){
                                callsArray[callIndex].status = .ended(reason: .end)
                            }else if(call.status == .calling){
                                callsArray[callIndex].status = .ended(reason: .cancel)
                            }
                            return call.id
                        }else{
                            return nil
                        }
                        }
                    }
                return nil
            }else {
                return nil
            }
    }
}
}
