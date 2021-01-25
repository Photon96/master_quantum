namespace ExploringSuperposition {
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;

    function DumpMachineMsg(message : String) : Unit{
        Message(message);
        DumpMachine();
        Message("\n");
    }
    //@EntryPoint()
    operation GenerateRandomBit() : Result {
        
        using (q = Qubit()) {
            Message("Qubit after intialization:");
            DumpMachine();
            Message("\n");
            H(q);
            Message("Qubit after applying H:");
            DumpMachine();
            Message("\n");

            let randomBit = M(q);
            Message("Qubit after measuring:");
            DumpMachine();
            Message("\n");
            Reset(q);

            Message("Qubit after reseting:");
            DumpMachine();
            Message("\n");
            return randomBit;
        }
    }

    
    operation SkewedRandomBit(alpha : Double) : Result {
        using (q = Qubit()) {
            Ry(2.0 * ArcCos(Sqrt(alpha)), q);
            Message("Qubit after intialization:");
            DumpMachine();
            Message("\n");
            return M(q);
        }
    }

    //@EntryPoint()
    operation GenerateRandomNumber () : Int {
        using (qubits = Qubit[3]) {
            ApplyToEach(H, qubits);
            DumpMachineMsg("Qubits after initialization");
            mutable results = new Result [0];
            for (q in qubits) {
                set results += [M(q)];
                DumpMachineMsg(" ");

            }
            //let result = ForEach(M, qubits);
            DumpMachineMsg("Qubits after measurement");

            return BoolArrayAsInt(ResultArrayAsBoolArray(results));
        }
    }

    //@EntryPoint()
    operation ApplyHTwice() : Result {
        using (q = Qubit()) {
            H(q);
            DumpMachineMsg("After first H gate application");
            H(q);
            DumpMachineMsg("After second H gate application");

            Message("Measurement:");
            return MResetZ(q);
        }
    }

    //@EntryPoint()
    operation  TestInterference() : Result {
        using (q = Qubit()) {
            X(q);
            H(q);
            DumpMachineMsg("After interference");
            Message("Measurement:");
            return M(q);
        }
    }

    //@EntryPoint()
    operation TestEntanglement() : Result[] {
        using (qubits = Qubit[2]) {
            X(qubits[1]);
            H(qubits[0]);
            CNOT(qubits[0], qubits[1]);
            DumpMachineMsg("Entangled state before measurement");

            let result = MultiM(qubits);
            DumpMachineMsg("State after measurement");
            return result;
        }
    }

    @EntryPoint() 
    operation TestEntanglemenControlledt() : Result[] {
        using (qubits = Qubit[2]) {
            H(qubits[0]);
            Controlled X([qubits[0]], qubits[1]);
            DumpMachineMsg("Entangled state before measurement");

            let result = MultiM(qubits);
            DumpMachineMsg("State after measurement");
            return result;
        }
    }
    
}
