namespace QuantumRNG {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;

    
    operation GenerateRandomBit() : Result {
        using (q = Qubit()) {
            H(q);
            return MResetZ(q);
        }
    }

    operation SampleRandomNumberInRange(min:Int, max:Int) : Int {
        mutable output = 0;
        repeat {
            mutable bits = new Result[0];
            for (idxBit in 1..BitSizeI(max)) {
                set bits += [GenerateRandomBit()];
            }
            set output = ResultArrayAsInt(bits);
        } until(output <= max and output >= min);
        return output;
    }

    @EntryPoint()
    operation SampleRandomNumber() : Unit {
        let min = 10;
        let max = 50;
        let n = 5;
        Message($"Sampling {n} random numbers between {min} and {max}");

        for (i in 1..n) {
            Message($"{i}) {SampleRandomNumberInRange(min, max)}");
        }
        
    }
}
