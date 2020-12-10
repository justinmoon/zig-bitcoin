const expect = @import("std").testing.expect;
const std = @import("std");

const Error = error {
    BadArgs,
    InvalidPrime,
};


const FieldElement = struct {
    num: u32,
    prime: u32,

    pub fn init(num: u32, prime: u32) !FieldElement {
        if (num >= prime) {
            return Error.BadArgs;
        }
        return FieldElement {
            .num = num,
            .prime = prime,
        };
    }

    pub fn eq(self: FieldElement, other: FieldElement) bool {
        return self.num == other.num and self.prime == other.prime;
    }

    pub fn add(self: FieldElement, other: FieldElement) !FieldElement {
        if (self.prime != other.prime) {
            return Error.InvalidPrime;
        }
        const num = (self.num + other.num) % self.prime;
        return FieldElement.init(num, self.prime);
    }
};

test "field elements" {
    // Constructor works
    var fe = FieldElement.init(7, 13) catch unreachable;
    expect(fe.num == 7);
    expect(fe.prime == 13);

    var fe2 = FieldElement.init(7, 13) catch unreachable;
    var fe3 = FieldElement.init(7, 19) catch unreachable;

    expect(fe.eq(fe2));
    expect(fe2.eq(fe));
    expect(!fe.eq(fe3));
    expect(!fe3.eq(fe));

    // add
    const sum = fe.add(fe) catch unreachable;
    expect(sum.eq(FieldElement.init(1, 13) catch unreachable));
}


pub fn main() !void {

}