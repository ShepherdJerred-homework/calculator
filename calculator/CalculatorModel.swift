import Foundation

class DivideByZeroError: Error {
}

enum Operation {
    case ADD;
    case SUBTRACT;
    case MULTIPLY;
    case DIVIDE;
    case SIN;
    case COS;
}

func append(src: Int, dest: Double) -> Double {
    let isDestInt = dest.isInt;

    if isDestInt {
        return Double(String(Int(dest)) + String(src))!;
    } else {
        return Double(String(dest) + String(src))!;
    }
}

func doOp(op: Operation?, left: Double, right: Double?) throws -> Double {
    switch (op ?? .ADD) {
    case .ADD:
        return left + (right ?? left);
    case .SUBTRACT:
        return left - (right ?? left);
    case .MULTIPLY:
        return left * (right ?? left);
    case .DIVIDE:
        if right == 0 {
            throw DivideByZeroError();
        } else {
            return left / (right ?? left);
        }
    case .SIN:
        // TODO
        return -1;
    case .COS:
        // TODO
        return -1;
    }
}

protocol State {
    var display: Double { get }

    func enterEqual() -> State;
    func enterOperation(_ op: Operation) -> State;
    func enterDigit(_ num: Int) -> State;
    func enterPoint() -> State;
}

class InitialState: State {
    var left: Double;
    var right: Double?;
    var display: Double;
    var pendingOperation: Operation?;

    init(display: Double, left: Double, right: Double?, pendingOperation: Operation?) {
        self.display = display;
        self.left = left;
        self.right = right;
        self.pendingOperation = pendingOperation;
    }

    func enterEqual() -> State {
        do {
            left = try doOp(op: pendingOperation, left: left, right: right);
        } catch {
            return ErrorState(display: 0.0, left: 0.0, right: 0.0, pendingOperation: nil);
        }
        return self;
    }

    func enterOperation(_ op: Operation) -> State {
        return ComputeState(display: display, left: left, right: right, pendingOperation: op);
    }

    func enterDigit(_ num: Int) -> State {
        let numDouble = Double(num);
        return AccumState(display: numDouble, left: numDouble, right: nil, pendingOperation: nil);
    }

    func enterPoint() -> State {
        return PointState(display: 0.0, left: 0.0, right: nil, pendingOperation: nil);
    }
}

class AccumState: State {
    var left: Double;
    var right: Double?;
    var display: Double;
    var pendingOperation: Operation?;

    init(display: Double, left: Double, right: Double?, pendingOperation: Operation?) {
        self.display = display;
        self.left = left;
        self.right = right;
        self.pendingOperation = pendingOperation;
    }

    func enterEqual() -> State {
        do {
            left = try doOp(op: pendingOperation, left: left, right: right);
            return InitialState(display: left, left: left, right: right, pendingOperation: pendingOperation);
        } catch {
            return ErrorState(display: 0.0, left: 0.0, right: 0.0, pendingOperation: nil);
        }
    }

    func enterOperation(_ op: Operation) -> State {
        if pendingOperation != nil {
            do {
                left = try doOp(op: pendingOperation!, left: left, right: right)
            } catch {
                return ErrorState(display: 0.0, left: 0.0, right: 0.0, pendingOperation: nil);
            }
        }
        return InitialState(display: left, left: left, right: nil, pendingOperation: pendingOperation);
    }

    func enterDigit(_ num: Int) -> State {
        if pendingOperation == nil && right == nil {
            left = append(src: num, dest: left);
            display = left;
        } else {
            if (right == nil) {
                right = Double(num);
            } else {
                right = append(src: num, dest: right!);
            }
            display = right!;
        }
        return AccumState(display: display, left: left, right: right, pendingOperation: nil);
    }

    func enterPoint() -> State {
        return PointState(display: display, left: left, right: right, pendingOperation: nil);
    }
}

class PointState: State {
    var left: Double;
    var right: Double?;
    var display: Double;
    var pendingOperation: Operation?;

    init(display: Double, left: Double, right: Double?, pendingOperation: Operation?) {
        self.display = display;
        self.left = left;
        self.right = right;
        self.pendingOperation = pendingOperation;
    }

    func enterEqual() -> State {
        return InitialState(display: left, left: left, right: right, pendingOperation: pendingOperation);
    }

    func enterOperation(_ op: Operation) -> State {
        return ComputeState(display: left, left: left, right: right, pendingOperation: op)
    }

    func enterDigit(_ num: Int) -> State {
        let s = AccumState(display: display, left: left, right: right, pendingOperation: pendingOperation);
        s.enterDigit(num);
        return s;
    }

    func enterPoint() -> State {
        return self;
    }
}

class ComputeState: State {
    var left: Double;
    var right: Double?;
    var display: Double;
    var pendingOperation: Operation?;

    init(display: Double, left: Double, right: Double?, pendingOperation: Operation?) {
        self.display = display;
        self.left = left;
        self.right = right;
        self.pendingOperation = pendingOperation;
    }

    func enterEqual() -> State {
        do {
            left = try doOp(op: pendingOperation, left: left, right: right)
        } catch {
            return ErrorState(display: 0.0, left: 0.0, right: 0.0, pendingOperation: nil);
        }
        return InitialState(display: left, left: left, right: nil, pendingOperation: pendingOperation);
    }

    func enterOperation(_ op: Operation) -> State {
        do {
            left = try doOp(op: pendingOperation, left: left, right: right)
        } catch {
            return ErrorState(display: 0.0, left: 0.0, right: 0.0, pendingOperation: nil);
        }
        return ComputeState(display: left, left: left, right: nil, pendingOperation: op);
    }

    func enterDigit(_ num: Int) -> State {
        let s = AccumState(display: display, left: left, right: right, pendingOperation: pendingOperation);
        s.enterDigit(num);
        return s;
    }

    func enterPoint() -> State {
        return PointState(display: left, left: left, right: right, pendingOperation: pendingOperation);
    }
}

class ErrorState: State {
    var left: Double;
    var right: Double?;
    var display: Double;
    var pendingOperation: Operation?;

    init(display: Double, left: Double, right: Double?, pendingOperation: Operation?) {
        self.display = display;
        self.left = left;
        self.right = right;
        self.pendingOperation = pendingOperation;
    }

    func enterEqual() -> State {
        return self;
    }

    func enterOperation(_ op: Operation) -> State {
        return self;
    }

    func enterDigit(_ num: Int) -> State {
        return self;

    }

    func enterPoint() -> State {
        return self;
    }
}

class Calculator {
    var state: State = InitialState(display: 0, left: 0, right: nil, pendingOperation: nil);

    func value() -> Double {
        return state.display;
    }

    func enterEqual() {
        state = state.enterEqual();
    }

    func enterOperation(operation: Operation) {
        state = state.enterOperation(operation);
    }

    func enterDigit(digit: Int) {
        state = state.enterDigit(digit);
    }

    func enterPoint() {
        state = state.enterPoint();
    }

    func clear() {
        state = InitialState(display: 0, left: 0, right: nil, pendingOperation: nil);
    }
}

// https://stackoverflow.com/questions/28447732/checking-if-a-double-value-is-an-integer-swift
extension Double {
    var isInt: Bool {
        return floor(self) == self
    }
}
