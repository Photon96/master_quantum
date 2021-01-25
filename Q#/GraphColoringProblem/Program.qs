namespace GraphColoringProblem {
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Convert;    

    
    operation SolveGraphColoringProblem() : Unit {
        let nVertices = 5;
        let edges = [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3), (3, 4)];

        let coloring = [false, false, true, false, false, true, true, true, true, false];
        let colors = ["red", "green", "blue", "yellow"];

        let colorBits = Chunks(2, coloring);
        for (i in 0 .. nVertices - 1) {
            let colorIndex = BoolArrayAsInt(colorBits[i]);
            Message($"Vertex {i} - color #{colorIndex} ({colors[colorIndex]})");
        }
    }

    operation MarkColorEquality(c0: Qubit [], c1: Qubit [], target: Qubit) : Unit
    is Adj + Ctl {
        within {
            for ((q0, q1) in Zipped(c0, c1)) {
                CNOT(q0, q1);
            }
        } apply {
            (ControlledOnInt(0, X))(c1, target);
        }
    }

    operation MarkValidVertexColoring(edges : (Int, Int)[], colorsRegister: Qubit[], target : Qubit) : Unit
    is Adj + Ctl {
        let nEdges = Length(edges);

        let colors = Chunks(2, colorsRegister);

        using (conflictQubits = Qubit[nEdges]) {
            within {
                for (((start, end), conflictQubit) in Zipped(edges, conflictQubits)) {
                    MarkColorEquality(colors[start], colors[end], conflictQubit);
                }
            } apply {
                ControlledOnInt(0, X)(conflictQubits, target);
            }
        }
    }

    operation ShowColorEqualityCheck() :  Unit{
        using ((c0, c1, target) = (Qubit[2], Qubit[2], Qubit())) {
            ApplyToEach(H, c1);

            Message("The starting state of qubits c1 and target:");
            DumpRegister((), c1 + [target]);
            MarkColorEquality(c0, c1, target);

            Message("");
            Message("The state of qubits c1 and target after the equality check:");
            DumpRegister((), c1 + [target]);

            ResetAll(c1 + [target]);

        }
    }

    @EntryPoint()
    operation ShowColoringValidationCheck() : Unit {
        let nVertices = 5;
        let edges = [(0, 1), (0, 2), (0, 3), (1, 2), (1, 3), (2, 3), (3, 4)];

        let coloring = [false, false, true, false, true, true, false, true, true, true];
        let colors = ["red", "green", "blue", "yellow"];

        using ((coloringRegister, target) = (Qubit[2*nVertices], Qubit())) {
            ApplyPauliFromBitString(PauliX, true, coloring, coloringRegister);

            MarkValidVertexColoring(edges, coloringRegister, target);

            let isColoringValid = M(target) == One;
            Message($"The coloring is {isColoringValid ? "valid" | "invalid"}");

            ResetAll(coloringRegister);
        }
    }
}
