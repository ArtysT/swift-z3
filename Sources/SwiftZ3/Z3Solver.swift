import CZ3

public class Z3Solver {
    var context: Z3Context
    var solver: Z3_solver
    
    init(context: Z3Context, solver: Z3_solver) {
        self.context = context
        self.solver = solver

        Z3_solver_inc_ref(context.context, solver)
    }

    deinit {
        Z3_solver_dec_ref(context.context, solver)
    }

    /// Return a string describing all solver available parameters.
    ///
    /// - seealso: `getParamDescrs`
    /// - seealso: `setParams`
    public func getHelp() -> String {
        return String(cString: Z3_solver_get_help(context.context, solver))
    }

    /// Set this solver using the given parameters.
    ///
    /// - seealso: `getHelp`
    /// - seealso: `getParamDescrs`
    public func setParams(_ params: Z3Params) {
        Z3_solver_set_params(context.context, solver, params.params)
    }

    /// Return the parameter description set for this solver object.
    public func getParamDescrs() -> Z3ParamDescrs {
        let descrs = Z3_solver_get_param_descrs(context.context, solver)

        return Z3ParamDescrs(context: context, descr: descrs!)
    }

    /// Solver local interrupt.
    ///
    /// Normally you should use `Z3Context.interrupt()` to cancel solvers because
    /// only one solver is enabled concurrently per context.
    /// However, per GitHub issue #1006, there are use cases where it is more
    /// convenient to cancel a specific solver. Solvers that are not selected
    /// for interrupts are left alone.
    public func interrupt() {
        Z3_solver_interrupt(context.context, solver)
    }

    /// Create a backtracking point.
    ///
    /// The solver contains a stack of assertions.
    ///
    /// - seealso: `getNumScopes()`
    /// - seealso: `pop()`
    public func push() {
        Z3_solver_push(context.context, solver)
    }

    /// Backtrack `n` backtracking points.
    ///
    /// - precondition: `n <= getNumScopes()`
    /// - seealso: `getNumScopes()`
    /// - seealso: `push()`
    public func pop(_ n: UInt32) {
        Z3_solver_pop(context.context, solver, n)
    }

    /// Remove all assertions from the solver.
    ///
    /// - seealso: `assert()`
    /// - seealso: `assertAndTrack()`
    public func reset() {
        Z3_solver_reset(context.context, solver)
    }

    /// Return the number of backtracking points.
    ///
    /// - seealso: `push()`
    /// - seealso: `pop()`
    public func getNumScopes() -> UInt32 {
        return Z3_solver_get_num_scopes(context.context, solver)
    }
    
    /// Retrieve the model for the last `check()` or `checkAssumptions()`
    ///
    /// The error handler is invoked if a model is not available because the
    /// commands above were not invoked for the given solver, or if the result
    /// was `Z3_L_FALSE`.
    public func getModel() -> Z3Model? {
        if let ptr = Z3_solver_get_model(context.context, solver) {
            return Z3Model(context: context, model: ptr)
        }
        
        return nil
    }
    
    /// Assert a constraint into the solver.
    ///
    /// The methods `check` and `checkAssumptions` should be used to check whether
    /// the logical context is consistent or not.
    public func assert(_ exp: Z3Bool) {
        Z3_solver_assert(context.context, solver, exp.ast)
    }

    /// Assert a constraint `a` into the solver, and track it (in the unsat) core
    /// using the Boolean constant `p`.
    ///
    /// This API is an alternative to `checkAssumptions` for extracting unsat
    /// cores.
    /// Both APIs can be used in the same solver. The unsat core will contain a
    /// combination of the Boolean variables provided using `assertAndTrack` and
    /// the Boolean literals provided using `checkAssumptions`.
    ///
    /// - precondition: `a` must be a Boolean expression
    /// - precondition: `p` must be a Boolean constant (aka variable).
    /// - seealso: `assert()`
    /// - seealso: `reset()`
    public func assertAndTrack(_ a: Z3Bool, _ p: Z3Bool) {
        Z3_solver_assert_and_track(context.context, solver, a.ast, p.ast)
    }

    /// Load solver assertions from a file.
    ///
    /// - seealso: `fromString()`
    /// - seealso: `toString()`
    public func fromFile(_ fileName: String) {
        Z3_solver_from_file(context.context, solver, fileName)
    }

    /// Load solver assertions from a string.
    ///
    /// - seealso: `fromFile()`
    /// - seealso: `toString()`
    public func fromString(_ s: String) {
        Z3_solver_from_string(context.context, solver, s)
    }
    
    /// Asserts a series of constraints into the solver.
    ///
    /// The methods `check` and `checkAssumptions` should be used to check whether
    /// the logical context is consistent or not.
    public func assert(_ expressions: [Z3Bool]) {
        for exp in expressions {
            assert(exp)
        }
    }
    
    /// Check whether the assertions in a given solver are consistent or not.
    ///
    /// The method `getModel()` retrieves a model if the assertions is satisfiable
    /// (i.e., the result is `Z3_L_TRUE`) and model construction is enabled.
    ///
    /// Note that if the call returns `Z3_L_UNDEF`, Z3 does not ensure that calls
    /// to `getModel()` succeed and any models produced in this case are not
    /// guaranteed to satisfy the assertions.
    ///
    /// The function `getProof()` retrieves a proof if proof generation was enabled
    /// when the context was created, and the assertions are unsatisfiable
    /// (i.e., the result is `Z3_L_FALSE`).
    public func check() -> Z3_lbool {
        return Z3_solver_check(context.context, solver)
    }
    
    /// Check whether the assertions in the given solver and optional assumptions
    /// are consistent or not.
    ///
    /// The function #Z3_solver_get_unsat_core retrieves the subset of the
    /// assumptions used in the unsatisfiability proof produced by Z3.
    public func checkAssumptions(_ assumptions: [AnyZ3Ast]) -> Z3_lbool {
        return preparingArgsAst(assumptions) { count, assumptions in
            Z3_solver_check_assumptions(context.context, solver, count, assumptions)
        }
    }

    /// Convert a solver into a string.
    ///
    /// - seealso: `fromFile()`
    /// - seealso: `fromString()`
    public func toString() -> String {
        return String(cString: Z3_solver_to_string(context.context, solver))
    }

    /// Convert a solver into a DIMACS formatted string.
    ///
    /// - seealso: `Z3_goal_to_diamcs_string` for requirements.
    public func toDimacsString() -> String {
        return String(cString: Z3_solver_to_dimacs_string(context.context, solver))
    }
}
