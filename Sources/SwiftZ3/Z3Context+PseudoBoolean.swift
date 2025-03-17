import CZ3

public extension Z3Context {
    // MARK: - Pseudo-Boolean

    /**
     Create constraint for at most k true variables.
     args[0] + args[1] + ... + args[n] <= k
    
     - Parameters:
       - arguments: An array of `Z3Bool` representing the boolean variables.
       - k: The maximum number of true variables allowed.
    
     - SeeAlso: ``makeAtLeast(_:k:)``
    */
    func makeAtMost(_ arguments: [Z3Bool], k: Int32) -> Z3Bool {
        preparingArgsAst(arguments) { count, args in
            Z3Bool(context: self, ast: Z3_mk_atmost(context, count, args, UInt32(k)))
        }
    }
    
    /**
     Create constraint for at least k true variables.
     args[0] + args[1] + ... + args[n] >= k
    
     - Parameters:
       - arguments: An array of `Z3Bool` representing the boolean variables.
       - k: The minimum number of true variables required.
    
     - SeeAlso: ``makeAtMost(_:k:)``
    */
    func makeAtLeast(_ arguments: [Z3Bool], k: Int32) -> Z3Bool {
        preparingArgsAst(arguments) { count, args in
            Z3Bool(context: self, ast: Z3_mk_atleast(context, count, args, UInt32(k)))
        }
    }
    
    /**
     Create constraint for sum of coefficients being less than or equal to k.
     coeffs[0]\*args[0] + coeffs[1]\*args[1] + ... + coeffs[n]\*args[n] <= k
    
     - Parameters:
       - arguments: An array of `Z3Bool` representing the boolean variables.
       - coefficients: An array representing the coefficients for each variable.
       - k: The maximum value of the sum.
    
     - Precondition: The number of arguments must be equal to number of coefficients.
    
     - SeeAlso: ``makePbGe(_:coefficients:k:)``
     - SeeAlso: ``makePbEq(_:coefficients:k:)``
    */
    func makePbLe(_ arguments: [Z3Bool], coefficients: [Int32], k: Int32) -> Z3Bool {
        precondition(arguments.count == coefficients.count)
        
        return preparingArgsAst(arguments) { count, args in
            Z3Bool(context: self, ast: Z3_mk_pble(context, count, args, coefficients, k))
        }
    }
    
    /**
     Create constraint for sum of coefficients being greater than or equal to k.
     coeffs[0]\*args[0] + coeffs[1]\*args[1] + ... + coeffs[n]\*args[n] >= k
    
     - Parameters:
       - arguments: An array of `Z3Bool` representing the boolean variables.
       - coefficients: An array representing the coefficients for each variable.
       - k: The minimum value of the sum.
    
     - Precondition: The number of arguments must be equal to number of coefficients.
    
     - SeeAlso: ``makePbLe(_:coefficients:k:)``
     - SeeAlso: ``makePbEq(_:coefficients:k:)``
    */
    func makePbGe(_ arguments: [Z3Bool], coefficients: [Int32], k: Int32) -> Z3Bool {
        precondition(arguments.count == coefficients.count)
        
        return preparingArgsAst(arguments) { count, args in
            Z3Bool(context: self, ast: Z3_mk_pbge(context, count, args, coefficients, k))
        }
    }
    
    /**
     Create constraint for sum of coefficients being equal to k.
     coeffs[0]\*args[0] + coeffs[1]\*args[1] + ... + coeffs[n]\*args[n] = k
    
     - Parameters:
       - arguments: An array of `Z3Bool` representing the boolean variables.
       - coefficients: An array representing the coefficients for each variable.
       - k: The exact value of the sum.
    
     - Precondition: The number of arguments must be equal to number of coefficients.
    
     - SeeAlso: ``makePbLe(_:coefficients:k:)``
     - SeeAlso: ``makePbGe(_:coefficients:k:)``
    */
    func makePbEq(_ arguments: [Z3Bool], coefficients: [Int32], k: Int32) -> Z3Bool {
        precondition(arguments.count == coefficients.count)
        
        return preparingArgsAst(arguments) { count, args in
            Z3Bool(context: self, ast: Z3_mk_pbeq(context, count, args, coefficients, k))
        }
    }
}
