
internal class RField: RFieldRefMut {
    var isOwned: Bool = true

    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RField$_free(ptr)
        }
    }
}
extension RField {
    class internal func r_from_string<GenericToRustStr: ToRustStr>(_ string: GenericToRustStr) -> Optional<RField> {
        return string.toRustStr({ stringAsRustStr in
            { let val = __swift_bridge__$RField$r_from_string(stringAsRustStr); if val != nil { return RField(ptr: val!) } else { return nil } }()
        })
    }
}
internal class RFieldRefMut: RFieldRef {
    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
internal class RFieldRef {
    var ptr: UnsafeMutableRawPointer

    internal init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RFieldRef {
    internal func r_to_string() -> RustString {
        RustString(ptr: __swift_bridge__$RField$r_to_string(ptr))
    }
}
extension RFieldRef: Equatable {
    public static func == (lhs: RFieldRef, rhs: RFieldRef) -> Bool {
        __swift_bridge__$RField$_partial_eq(rhs.ptr, lhs.ptr)
    }
}
extension RField: Vectorizable {
    internal static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RField$new()
    }

    internal static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RField$drop(vecPtr)
    }

    internal static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RField) {
        __swift_bridge__$Vec_RField$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    internal static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RField$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RField(ptr: pointer!) as! Self)
        }
    }

    internal static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RFieldRef> {
        let pointer = __swift_bridge__$Vec_RField$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RFieldRef(ptr: pointer!)
        }
    }

    internal static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RFieldRefMut> {
        let pointer = __swift_bridge__$Vec_RField$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RFieldRefMut(ptr: pointer!)
        }
    }

    internal static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<RFieldRef> {
        UnsafePointer<RFieldRef>(OpaquePointer(__swift_bridge__$Vec_RField$as_ptr(vecPtr)))
    }

    internal static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RField$len(vecPtr)
    }
}










internal class RAddress: RAddressRefMut {
    var isOwned: Bool = true

    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RAddress$_free(ptr)
        }
    }
}
extension RAddress {
    internal convenience init(r_private_key private_key: RPrivateKeyRef) {
        self.init(ptr: __swift_bridge__$RAddress$r_from_private_key(private_key.ptr))
    }

    internal convenience init(r_view_key view_key: RViewKeyRef) {
        self.init(ptr: __swift_bridge__$RAddress$r_from_view_key(view_key.ptr))
    }

    internal convenience init<GenericIntoRustString: IntoRustString>(r_string address: GenericIntoRustString) {
        self.init(ptr: __swift_bridge__$RAddress$r_from_string({ let rustString = address.intoRustString(); rustString.isOwned = false; return rustString.ptr }()))
    }
}
internal class RAddressRefMut: RAddressRef {
    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
internal class RAddressRef {
    var ptr: UnsafeMutableRawPointer

    internal init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RAddressRef {
    internal func r_to_string() -> RustString {
        RustString(ptr: __swift_bridge__$RAddress$r_to_string(ptr))
    }

    internal func r_verify(_ message: UnsafeBufferPointer<UInt8>, _ signature: RSignatureRef) -> Bool {
        __swift_bridge__$RAddress$r_verify(ptr, message.toFfiSlice(), signature.ptr)
    }
}
extension RAddressRef: Equatable {
    public static func == (lhs: RAddressRef, rhs: RAddressRef) -> Bool {
        __swift_bridge__$RAddress$_partial_eq(rhs.ptr, lhs.ptr)
    }
}
extension RAddress: Vectorizable {
    internal static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RAddress$new()
    }

    internal static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RAddress$drop(vecPtr)
    }

    internal static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RAddress) {
        __swift_bridge__$Vec_RAddress$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    internal static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RAddress$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RAddress(ptr: pointer!) as! Self)
        }
    }

    internal static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RAddressRef> {
        let pointer = __swift_bridge__$Vec_RAddress$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RAddressRef(ptr: pointer!)
        }
    }

    internal static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RAddressRefMut> {
        let pointer = __swift_bridge__$Vec_RAddress$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RAddressRefMut(ptr: pointer!)
        }
    }

    internal static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<RAddressRef> {
        UnsafePointer<RAddressRef>(OpaquePointer(__swift_bridge__$Vec_RAddress$as_ptr(vecPtr)))
    }

    internal static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RAddress$len(vecPtr)
    }
}






internal class RPrivateKeyCiphertext: RPrivateKeyCiphertextRefMut {
    var isOwned: Bool = true

    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RPrivateKeyCiphertext$_free(ptr)
        }
    }
}
extension RPrivateKeyCiphertext {
    class internal func r_encrypt_private_key<GenericToRustStr: ToRustStr>(_ private_key: RPrivateKeyRef, _ secret: GenericToRustStr) -> Optional<RPrivateKeyCiphertext> {
        return secret.toRustStr({ secretAsRustStr in
            { let val = __swift_bridge__$RPrivateKeyCiphertext$r_encrypt_private_key(private_key.ptr, secretAsRustStr); if val != nil { return RPrivateKeyCiphertext(ptr: val!) } else { return nil } }()
        })
    }

    class internal func r_from_string<GenericIntoRustString: IntoRustString>(_ string: GenericIntoRustString) -> Optional<RPrivateKeyCiphertext> {
        { let val = __swift_bridge__$RPrivateKeyCiphertext$r_from_string({ let rustString = string.intoRustString(); rustString.isOwned = false; return rustString.ptr }()); if val != nil { return RPrivateKeyCiphertext(ptr: val!) } else { return nil } }()
    }
}
internal class RPrivateKeyCiphertextRefMut: RPrivateKeyCiphertextRef {
    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
internal class RPrivateKeyCiphertextRef {
    var ptr: UnsafeMutableRawPointer

    internal init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RPrivateKeyCiphertextRef {
    internal func r_decrypt_to_private_key<GenericToRustStr: ToRustStr>(_ secret: GenericToRustStr) -> Optional<RPrivateKey> {
        return secret.toRustStr({ secretAsRustStr in
            { let val = __swift_bridge__$RPrivateKeyCiphertext$r_decrypt_to_private_key(ptr, secretAsRustStr); if val != nil { return RPrivateKey(ptr: val!) } else { return nil } }()
        })
    }

    internal func r_to_string() -> RustString {
        RustString(ptr: __swift_bridge__$RPrivateKeyCiphertext$r_to_string(ptr))
    }
}
extension RPrivateKeyCiphertextRef: Equatable {
    public static func == (lhs: RPrivateKeyCiphertextRef, rhs: RPrivateKeyCiphertextRef) -> Bool {
        __swift_bridge__$RPrivateKeyCiphertext$_partial_eq(rhs.ptr, lhs.ptr)
    }
}
extension RPrivateKeyCiphertext: Vectorizable {
    internal static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RPrivateKeyCiphertext$new()
    }

    internal static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RPrivateKeyCiphertext$drop(vecPtr)
    }

    internal static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RPrivateKeyCiphertext) {
        __swift_bridge__$Vec_RPrivateKeyCiphertext$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    internal static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RPrivateKeyCiphertext$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RPrivateKeyCiphertext(ptr: pointer!) as! Self)
        }
    }

    internal static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RPrivateKeyCiphertextRef> {
        let pointer = __swift_bridge__$Vec_RPrivateKeyCiphertext$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RPrivateKeyCiphertextRef(ptr: pointer!)
        }
    }

    internal static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RPrivateKeyCiphertextRefMut> {
        let pointer = __swift_bridge__$Vec_RPrivateKeyCiphertext$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RPrivateKeyCiphertextRefMut(ptr: pointer!)
        }
    }

    internal static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<RPrivateKeyCiphertextRef> {
        UnsafePointer<RPrivateKeyCiphertextRef>(OpaquePointer(__swift_bridge__$Vec_RPrivateKeyCiphertext$as_ptr(vecPtr)))
    }

    internal static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RPrivateKeyCiphertext$len(vecPtr)
    }
}












internal class RPrivateKey: RPrivateKeyRefMut {
    var isOwned: Bool = true

    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RPrivateKey$_free(ptr)
        }
    }
}
extension RPrivateKey {
    internal convenience init() {
        self.init(ptr: __swift_bridge__$RPrivateKey$new())
    }

    internal convenience init(r_seed seed: UnsafeBufferPointer<UInt8>) {
        self.init(ptr: __swift_bridge__$RPrivateKey$r_from_seed_unchecked(seed.toFfiSlice()))
    }
}
extension RPrivateKey {
    class internal func r_from_string<GenericToRustStr: ToRustStr>(_ private_key: GenericToRustStr) -> Optional<RPrivateKey> {
        return private_key.toRustStr({ private_keyAsRustStr in
            { let val = __swift_bridge__$RPrivateKey$r_from_string(private_keyAsRustStr); if val != nil { return RPrivateKey(ptr: val!) } else { return nil } }()
        })
    }

    class internal func r_new_encrypted<GenericToRustStr: ToRustStr>(_ secret: GenericToRustStr) -> Optional<RPrivateKeyCiphertext> {
        return secret.toRustStr({ secretAsRustStr in
            { let val = __swift_bridge__$RPrivateKey$r_new_encrypted(secretAsRustStr); if val != nil { return RPrivateKeyCiphertext(ptr: val!) } else { return nil } }()
        })
    }

    class internal func r_from_private_key_ciphertext<GenericToRustStr: ToRustStr>(_ ciphertext: RPrivateKeyCiphertextRef, _ secret: GenericToRustStr) -> Optional<RPrivateKey> {
        return secret.toRustStr({ secretAsRustStr in
            { let val = __swift_bridge__$RPrivateKey$r_from_private_key_ciphertext(ciphertext.ptr, secretAsRustStr); if val != nil { return RPrivateKey(ptr: val!) } else { return nil } }()
        })
    }
}
internal class RPrivateKeyRefMut: RPrivateKeyRef {
    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
internal class RPrivateKeyRef {
    var ptr: UnsafeMutableRawPointer

    internal init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RPrivateKeyRef {
    internal func r_to_string() -> RustString {
        RustString(ptr: __swift_bridge__$RPrivateKey$r_to_string(ptr))
    }

    internal func r_to_view_key() -> RViewKey {
        RViewKey(ptr: __swift_bridge__$RPrivateKey$r_to_view_key(ptr))
    }

    internal func r_to_address() -> RAddress {
        RAddress(ptr: __swift_bridge__$RPrivateKey$r_to_address(ptr))
    }

    internal func r_sign(_ message: UnsafeBufferPointer<UInt8>) -> RSignature {
        RSignature(ptr: __swift_bridge__$RPrivateKey$r_sign(ptr, message.toFfiSlice()))
    }

    internal func r_to_ciphertext<GenericToRustStr: ToRustStr>(_ secret: GenericToRustStr) -> Optional<RPrivateKeyCiphertext> {
        return secret.toRustStr({ secretAsRustStr in
            { let val = __swift_bridge__$RPrivateKey$r_to_ciphertext(ptr, secretAsRustStr); if val != nil { return RPrivateKeyCiphertext(ptr: val!) } else { return nil } }()
        })
    }
}
extension RPrivateKeyRef: Equatable {
    public static func == (lhs: RPrivateKeyRef, rhs: RPrivateKeyRef) -> Bool {
        __swift_bridge__$RPrivateKey$_partial_eq(rhs.ptr, lhs.ptr)
    }
}
extension RPrivateKey: Vectorizable {
    internal static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RPrivateKey$new()
    }

    internal static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RPrivateKey$drop(vecPtr)
    }

    internal static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RPrivateKey) {
        __swift_bridge__$Vec_RPrivateKey$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    internal static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RPrivateKey$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RPrivateKey(ptr: pointer!) as! Self)
        }
    }

    internal static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RPrivateKeyRef> {
        let pointer = __swift_bridge__$Vec_RPrivateKey$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RPrivateKeyRef(ptr: pointer!)
        }
    }

    internal static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RPrivateKeyRefMut> {
        let pointer = __swift_bridge__$Vec_RPrivateKey$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RPrivateKeyRefMut(ptr: pointer!)
        }
    }

    internal static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<RPrivateKeyRef> {
        UnsafePointer<RPrivateKeyRef>(OpaquePointer(__swift_bridge__$Vec_RPrivateKey$as_ptr(vecPtr)))
    }

    internal static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RPrivateKey$len(vecPtr)
    }
}








internal class RSignature: RSignatureRefMut {
    var isOwned: Bool = true

    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RSignature$_free(ptr)
        }
    }
}
extension RSignature {
    internal convenience init(r_sign_init private_key: RPrivateKeyRef, _ message: UnsafeBufferPointer<UInt8>) {
        self.init(ptr: __swift_bridge__$RSignature$r_sign(private_key.ptr, message.toFfiSlice()))
    }

    internal convenience init<GenericToRustStr: ToRustStr>(r_from_string_init signature: GenericToRustStr) {
        self.init(ptr: signature.toRustStr({ signatureAsRustStr in
            __swift_bridge__$RSignature$r_from_string(signatureAsRustStr)
        }))
    }
}
internal class RSignatureRefMut: RSignatureRef {
    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
internal class RSignatureRef {
    var ptr: UnsafeMutableRawPointer

    internal init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RSignatureRef {
    internal func r_verify(_ address: RAddressRef, _ message: UnsafeBufferPointer<UInt8>) -> Bool {
        __swift_bridge__$RSignature$r_verify(ptr, address.ptr, message.toFfiSlice())
    }

    internal func r_to_string() -> RustString {
        RustString(ptr: __swift_bridge__$RSignature$r_to_string(ptr))
    }
}
extension RSignature: Vectorizable {
    internal static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RSignature$new()
    }

    internal static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RSignature$drop(vecPtr)
    }

    internal static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RSignature) {
        __swift_bridge__$Vec_RSignature$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    internal static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RSignature$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RSignature(ptr: pointer!) as! Self)
        }
    }

    internal static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RSignatureRef> {
        let pointer = __swift_bridge__$Vec_RSignature$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RSignatureRef(ptr: pointer!)
        }
    }

    internal static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RSignatureRefMut> {
        let pointer = __swift_bridge__$Vec_RSignature$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RSignatureRefMut(ptr: pointer!)
        }
    }

    internal static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<RSignatureRef> {
        UnsafePointer<RSignatureRef>(OpaquePointer(__swift_bridge__$Vec_RSignature$as_ptr(vecPtr)))
    }

    internal static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RSignature$len(vecPtr)
    }
}








internal class RViewKey: RViewKeyRefMut {
    var isOwned: Bool = true

    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RViewKey$_free(ptr)
        }
    }
}
extension RViewKey {
    internal convenience init(r_private_key private_key: RPrivateKeyRef) {
        self.init(ptr: __swift_bridge__$RViewKey$r_from_private_key(private_key.ptr))
    }

    internal convenience init<GenericToRustStr: ToRustStr>(r_view_key_string view_key: GenericToRustStr) {
        self.init(ptr: view_key.toRustStr({ view_keyAsRustStr in
            __swift_bridge__$RViewKey$r_from_string(view_keyAsRustStr)
        }))
    }
}
internal class RViewKeyRefMut: RViewKeyRef {
    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
internal class RViewKeyRef {
    var ptr: UnsafeMutableRawPointer

    internal init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RViewKeyRef {
    internal func r_to_string() -> RustString {
        RustString(ptr: __swift_bridge__$RViewKey$r_to_string(ptr))
    }

    internal func r_to_address() -> RAddress {
        RAddress(ptr: __swift_bridge__$RViewKey$r_to_address(ptr))
    }

    internal func r_decrypt<GenericToRustStr: ToRustStr>(_ ciphertext: GenericToRustStr) -> Optional<RustString> {
        return ciphertext.toRustStr({ ciphertextAsRustStr in
            { let val = __swift_bridge__$RViewKey$r_decrypt(ptr, ciphertextAsRustStr); if val != nil { return RustString(ptr: val!) } else { return nil } }()
        })
    }
}
extension RViewKeyRef: Equatable {
    public static func == (lhs: RViewKeyRef, rhs: RViewKeyRef) -> Bool {
        __swift_bridge__$RViewKey$_partial_eq(rhs.ptr, lhs.ptr)
    }
}
extension RViewKey: Vectorizable {
    internal static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RViewKey$new()
    }

    internal static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RViewKey$drop(vecPtr)
    }

    internal static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RViewKey) {
        __swift_bridge__$Vec_RViewKey$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    internal static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RViewKey$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RViewKey(ptr: pointer!) as! Self)
        }
    }

    internal static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RViewKeyRef> {
        let pointer = __swift_bridge__$Vec_RViewKey$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RViewKeyRef(ptr: pointer!)
        }
    }

    internal static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RViewKeyRefMut> {
        let pointer = __swift_bridge__$Vec_RViewKey$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RViewKeyRefMut(ptr: pointer!)
        }
    }

    internal static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<RViewKeyRef> {
        UnsafePointer<RViewKeyRef>(OpaquePointer(__swift_bridge__$Vec_RViewKey$as_ptr(vecPtr)))
    }

    internal static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RViewKey$len(vecPtr)
    }
}








internal class RRecordCiphertext: RRecordCiphertextRefMut {
    var isOwned: Bool = true

    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RRecordCiphertext$_free(ptr)
        }
    }
}
extension RRecordCiphertext {
    class internal func r_from<GenericToRustStr: ToRustStr>(_ string: GenericToRustStr) -> Optional<RRecordCiphertext> {
        return string.toRustStr({ stringAsRustStr in
            { let val = __swift_bridge__$RRecordCiphertext$r_from(stringAsRustStr); if val != nil { return RRecordCiphertext(ptr: val!) } else { return nil } }()
        })
    }
}
internal class RRecordCiphertextRefMut: RRecordCiphertextRef {
    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
internal class RRecordCiphertextRef {
    var ptr: UnsafeMutableRawPointer

    internal init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RRecordCiphertextRef {
    internal func r_to_string() -> RustString {
        RustString(ptr: __swift_bridge__$RRecordCiphertext$r_to_string(ptr))
    }

    internal func r_decrypt(_ view_key: RViewKeyRef) -> Optional<RRecordPlaintext> {
        { let val = __swift_bridge__$RRecordCiphertext$r_decrypt(ptr, view_key.ptr); if val != nil { return RRecordPlaintext(ptr: val!) } else { return nil } }()
    }

    internal func r_is_owner(_ view_key: RViewKeyRef) -> Bool {
        __swift_bridge__$RRecordCiphertext$r_is_owner(ptr, view_key.ptr)
    }
}
extension RRecordCiphertext: Vectorizable {
    internal static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RRecordCiphertext$new()
    }

    internal static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RRecordCiphertext$drop(vecPtr)
    }

    internal static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RRecordCiphertext) {
        __swift_bridge__$Vec_RRecordCiphertext$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    internal static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RRecordCiphertext$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RRecordCiphertext(ptr: pointer!) as! Self)
        }
    }

    internal static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RRecordCiphertextRef> {
        let pointer = __swift_bridge__$Vec_RRecordCiphertext$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RRecordCiphertextRef(ptr: pointer!)
        }
    }

    internal static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RRecordCiphertextRefMut> {
        let pointer = __swift_bridge__$Vec_RRecordCiphertext$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RRecordCiphertextRefMut(ptr: pointer!)
        }
    }

    internal static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<RRecordCiphertextRef> {
        UnsafePointer<RRecordCiphertextRef>(OpaquePointer(__swift_bridge__$Vec_RRecordCiphertext$as_ptr(vecPtr)))
    }

    internal static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RRecordCiphertext$len(vecPtr)
    }
}








internal class RRecordPlaintext: RRecordPlaintextRefMut {
    var isOwned: Bool = true

    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RRecordPlaintext$_free(ptr)
        }
    }
}
extension RRecordPlaintext {
    class internal func r_from_string<GenericToRustStr: ToRustStr>(_ string: GenericToRustStr) -> Optional<RRecordPlaintext> {
        return string.toRustStr({ stringAsRustStr in
            { let val = __swift_bridge__$RRecordPlaintext$r_from_string(stringAsRustStr); if val != nil { return RRecordPlaintext(ptr: val!) } else { return nil } }()
        })
    }
}
internal class RRecordPlaintextRefMut: RRecordPlaintextRef {
    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
internal class RRecordPlaintextRef {
    var ptr: UnsafeMutableRawPointer

    internal init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RRecordPlaintextRef {
    internal func r_to_string() -> RustString {
        RustString(ptr: __swift_bridge__$RRecordPlaintext$r_to_string(ptr))
    }

    internal func r_microcredits() -> UInt64 {
        __swift_bridge__$RRecordPlaintext$r_microcredits(ptr)
    }

    internal func r_nonce() -> RustString {
        RustString(ptr: __swift_bridge__$RRecordPlaintext$r_nonce(ptr))
    }

    internal func r_serial_number_string<GenericToRustStr: ToRustStr>(_ private_key: RPrivateKeyRef, _ program_id: GenericToRustStr, _ record_name: GenericToRustStr) -> Optional<RustString> {
        return record_name.toRustStr({ record_nameAsRustStr in
            return program_id.toRustStr({ program_idAsRustStr in
            { let val = __swift_bridge__$RRecordPlaintext$r_serial_number_string(ptr, private_key.ptr, program_idAsRustStr, record_nameAsRustStr); if val != nil { return RustString(ptr: val!) } else { return nil } }()
        })
        })
    }

    internal func r_commitment<GenericToRustStr: ToRustStr>(_ program_id: GenericToRustStr, _ record_name: GenericToRustStr) -> Optional<RField> {
        return record_name.toRustStr({ record_nameAsRustStr in
            return program_id.toRustStr({ program_idAsRustStr in
            { let val = __swift_bridge__$RRecordPlaintext$r_commitment(ptr, program_idAsRustStr, record_nameAsRustStr); if val != nil { return RField(ptr: val!) } else { return nil } }()
        })
        })
    }
}
extension RRecordPlaintext: Vectorizable {
    internal static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RRecordPlaintext$new()
    }

    internal static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RRecordPlaintext$drop(vecPtr)
    }

    internal static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RRecordPlaintext) {
        __swift_bridge__$Vec_RRecordPlaintext$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    internal static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RRecordPlaintext$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RRecordPlaintext(ptr: pointer!) as! Self)
        }
    }

    internal static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RRecordPlaintextRef> {
        let pointer = __swift_bridge__$Vec_RRecordPlaintext$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RRecordPlaintextRef(ptr: pointer!)
        }
    }

    internal static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RRecordPlaintextRefMut> {
        let pointer = __swift_bridge__$Vec_RRecordPlaintext$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RRecordPlaintextRefMut(ptr: pointer!)
        }
    }

    internal static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<RRecordPlaintextRef> {
        UnsafePointer<RRecordPlaintextRef>(OpaquePointer(__swift_bridge__$Vec_RRecordPlaintext$as_ptr(vecPtr)))
    }

    internal static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RRecordPlaintext$len(vecPtr)
    }
}




internal class RProvingKey: RProvingKeyRefMut {
    var isOwned: Bool = true

    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RProvingKey$_free(ptr)
        }
    }
}
extension RProvingKey {
    class internal func r_from_bytes(_ bytes: UnsafeBufferPointer<UInt8>) -> Optional<RProvingKey> {
        { let val = __swift_bridge__$RProvingKey$r_from_bytes(bytes.toFfiSlice()); if val != nil { return RProvingKey(ptr: val!) } else { return nil } }()
    }
}
internal class RProvingKeyRefMut: RProvingKeyRef {
    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
internal class RProvingKeyRef {
    var ptr: UnsafeMutableRawPointer

    internal init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RProvingKeyRef {
    internal func r_to_bytes() -> Optional<RustVec<UInt8>> {
        { let val = __swift_bridge__$RProvingKey$r_to_bytes(ptr); if val != nil { return RustVec(ptr: val!) } else { return nil } }()
    }

    internal func r_copy() -> RProvingKey {
        RProvingKey(ptr: __swift_bridge__$RProvingKey$r_copy(ptr))
    }
}
extension RProvingKeyRef: Equatable {
    public static func == (lhs: RProvingKeyRef, rhs: RProvingKeyRef) -> Bool {
        __swift_bridge__$RProvingKey$_partial_eq(rhs.ptr, lhs.ptr)
    }
}
extension RProvingKey: Vectorizable {
    internal static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RProvingKey$new()
    }

    internal static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RProvingKey$drop(vecPtr)
    }

    internal static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RProvingKey) {
        __swift_bridge__$Vec_RProvingKey$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    internal static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RProvingKey$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RProvingKey(ptr: pointer!) as! Self)
        }
    }

    internal static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RProvingKeyRef> {
        let pointer = __swift_bridge__$Vec_RProvingKey$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RProvingKeyRef(ptr: pointer!)
        }
    }

    internal static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RProvingKeyRefMut> {
        let pointer = __swift_bridge__$Vec_RProvingKey$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RProvingKeyRefMut(ptr: pointer!)
        }
    }

    internal static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<RProvingKeyRef> {
        UnsafePointer<RProvingKeyRef>(OpaquePointer(__swift_bridge__$Vec_RProvingKey$as_ptr(vecPtr)))
    }

    internal static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RProvingKey$len(vecPtr)
    }
}




internal class RVerifyingKey: RVerifyingKeyRefMut {
    var isOwned: Bool = true

    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RVerifyingKey$_free(ptr)
        }
    }
}
extension RVerifyingKey {
    class internal func r_from_bytes(_ bytes: UnsafeBufferPointer<UInt8>) -> Optional<RVerifyingKey> {
        { let val = __swift_bridge__$RVerifyingKey$r_from_bytes(bytes.toFfiSlice()); if val != nil { return RVerifyingKey(ptr: val!) } else { return nil } }()
    }

    class internal func r_from_string<GenericToRustStr: ToRustStr>(_ string: GenericToRustStr) -> Optional<RVerifyingKey> {
        return string.toRustStr({ stringAsRustStr in
            { let val = __swift_bridge__$RVerifyingKey$r_from_string(stringAsRustStr); if val != nil { return RVerifyingKey(ptr: val!) } else { return nil } }()
        })
    }
}
internal class RVerifyingKeyRefMut: RVerifyingKeyRef {
    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
internal class RVerifyingKeyRef {
    var ptr: UnsafeMutableRawPointer

    internal init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RVerifyingKeyRef {
    internal func r_to_bytes() -> Optional<RustVec<UInt8>> {
        { let val = __swift_bridge__$RVerifyingKey$r_to_bytes(ptr); if val != nil { return RustVec(ptr: val!) } else { return nil } }()
    }

    internal func r_to_string() -> RustString {
        RustString(ptr: __swift_bridge__$RVerifyingKey$r_to_string(ptr))
    }

    internal func r_copy() -> RVerifyingKey {
        RVerifyingKey(ptr: __swift_bridge__$RVerifyingKey$r_copy(ptr))
    }
}
extension RVerifyingKeyRef: Equatable {
    public static func == (lhs: RVerifyingKeyRef, rhs: RVerifyingKeyRef) -> Bool {
        __swift_bridge__$RVerifyingKey$_partial_eq(rhs.ptr, lhs.ptr)
    }
}
extension RVerifyingKey: Vectorizable {
    internal static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RVerifyingKey$new()
    }

    internal static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RVerifyingKey$drop(vecPtr)
    }

    internal static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RVerifyingKey) {
        __swift_bridge__$Vec_RVerifyingKey$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    internal static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RVerifyingKey$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RVerifyingKey(ptr: pointer!) as! Self)
        }
    }

    internal static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RVerifyingKeyRef> {
        let pointer = __swift_bridge__$Vec_RVerifyingKey$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RVerifyingKeyRef(ptr: pointer!)
        }
    }

    internal static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RVerifyingKeyRefMut> {
        let pointer = __swift_bridge__$Vec_RVerifyingKey$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RVerifyingKeyRefMut(ptr: pointer!)
        }
    }

    internal static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<RVerifyingKeyRef> {
        UnsafePointer<RVerifyingKeyRef>(OpaquePointer(__swift_bridge__$Vec_RVerifyingKey$as_ptr(vecPtr)))
    }

    internal static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RVerifyingKey$len(vecPtr)
    }
}




internal class RTransaction: RTransactionRefMut {
    var isOwned: Bool = true

    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RTransaction$_free(ptr)
        }
    }
}
extension RTransaction {
    class internal func r_from_string<GenericToRustStr: ToRustStr>(_ transaction: GenericToRustStr) -> Optional<RTransaction> {
        return transaction.toRustStr({ transactionAsRustStr in
            { let val = __swift_bridge__$RTransaction$r_from_string(transactionAsRustStr); if val != nil { return RTransaction(ptr: val!) } else { return nil } }()
        })
    }
}
internal class RTransactionRefMut: RTransactionRef {
    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
internal class RTransactionRef {
    var ptr: UnsafeMutableRawPointer

    internal init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RTransactionRef {
    internal func r_to_string() -> RustString {
        RustString(ptr: __swift_bridge__$RTransaction$r_to_string(ptr))
    }

    internal func r_transaction_id() -> RustString {
        RustString(ptr: __swift_bridge__$RTransaction$r_transaction_id(ptr))
    }

    internal func r_transaction_type() -> RustString {
        RustString(ptr: __swift_bridge__$RTransaction$r_transaction_type(ptr))
    }
}
extension RTransactionRef: Equatable {
    public static func == (lhs: RTransactionRef, rhs: RTransactionRef) -> Bool {
        __swift_bridge__$RTransaction$_partial_eq(rhs.ptr, lhs.ptr)
    }
}
extension RTransaction: Vectorizable {
    internal static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RTransaction$new()
    }

    internal static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RTransaction$drop(vecPtr)
    }

    internal static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RTransaction) {
        __swift_bridge__$Vec_RTransaction$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    internal static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RTransaction$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RTransaction(ptr: pointer!) as! Self)
        }
    }

    internal static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RTransactionRef> {
        let pointer = __swift_bridge__$Vec_RTransaction$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RTransactionRef(ptr: pointer!)
        }
    }

    internal static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RTransactionRefMut> {
        let pointer = __swift_bridge__$Vec_RTransaction$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RTransactionRefMut(ptr: pointer!)
        }
    }

    internal static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<RTransactionRef> {
        UnsafePointer<RTransactionRef>(OpaquePointer(__swift_bridge__$Vec_RTransaction$as_ptr(vecPtr)))
    }

    internal static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RTransaction$len(vecPtr)
    }
}








internal class RKeyPair: RKeyPairRefMut {
    var isOwned: Bool = true

    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RKeyPair$_free(ptr)
        }
    }
}
extension RKeyPair {
    internal convenience init(_ proving_key: RProvingKey, _ verifying_key: RVerifyingKey) {
        self.init(ptr: __swift_bridge__$RKeyPair$r_new({proving_key.isOwned = false; return proving_key.ptr;}(), {verifying_key.isOwned = false; return verifying_key.ptr;}()))
    }
}
internal class RKeyPairRefMut: RKeyPairRef {
    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
extension RKeyPairRefMut {
    internal func r_proving_key() -> Optional<RProvingKey> {
        { let val = __swift_bridge__$RKeyPair$r_proving_key(ptr); if val != nil { return RProvingKey(ptr: val!) } else { return nil } }()
    }

    internal func r_verifying_key() -> Optional<RVerifyingKey> {
        { let val = __swift_bridge__$RKeyPair$r_verifying_key(ptr); if val != nil { return RVerifyingKey(ptr: val!) } else { return nil } }()
    }
}
internal class RKeyPairRef {
    var ptr: UnsafeMutableRawPointer

    internal init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RKeyPair: Vectorizable {
    internal static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RKeyPair$new()
    }

    internal static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RKeyPair$drop(vecPtr)
    }

    internal static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RKeyPair) {
        __swift_bridge__$Vec_RKeyPair$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    internal static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RKeyPair$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RKeyPair(ptr: pointer!) as! Self)
        }
    }

    internal static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RKeyPairRef> {
        let pointer = __swift_bridge__$Vec_RKeyPair$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RKeyPairRef(ptr: pointer!)
        }
    }

    internal static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RKeyPairRefMut> {
        let pointer = __swift_bridge__$Vec_RKeyPair$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RKeyPairRefMut(ptr: pointer!)
        }
    }

    internal static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<RKeyPairRef> {
        UnsafePointer<RKeyPairRef>(OpaquePointer(__swift_bridge__$Vec_RKeyPair$as_ptr(vecPtr)))
    }

    internal static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RKeyPair$len(vecPtr)
    }
}








internal class RProgram: RProgramRefMut {
    var isOwned: Bool = true

    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RProgram$_free(ptr)
        }
    }
}
extension RProgram {
    class internal func r_from_string<GenericToRustStr: ToRustStr>(_ program: GenericToRustStr) -> Optional<RProgram> {
        return program.toRustStr({ programAsRustStr in
            { let val = __swift_bridge__$RProgram$r_from_string(programAsRustStr); if val != nil { return RProgram(ptr: val!) } else { return nil } }()
        })
    }
}
internal class RProgramRefMut: RProgramRef {
    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
internal class RProgramRef {
    var ptr: UnsafeMutableRawPointer

    internal init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RProgramRef {
    internal func r_to_string() -> RustString {
        RustString(ptr: __swift_bridge__$RProgram$r_to_string(ptr))
    }

    internal func r_has_function<GenericToRustStr: ToRustStr>(_ function_name: GenericToRustStr) -> Bool {
        return function_name.toRustStr({ function_nameAsRustStr in
            __swift_bridge__$RProgram$r_has_function(ptr, function_nameAsRustStr)
        })
    }

    internal func r_get_functions() -> RustString {
        RustString(ptr: __swift_bridge__$RProgram$r_get_functions(ptr))
    }

    internal func r_get_function_inputs<GenericIntoRustString: IntoRustString>(_ function_name: GenericIntoRustString) -> Optional<RustVec<RustString>> {
        { let val = __swift_bridge__$RProgram$r_get_function_inputs(ptr, { let rustString = function_name.intoRustString(); rustString.isOwned = false; return rustString.ptr }()); if val != nil { return RustVec(ptr: val!) } else { return nil } }()
    }

    internal func r_get_mappings() -> Optional<RustString> {
        { let val = __swift_bridge__$RProgram$r_get_mappings(ptr); if val != nil { return RustString(ptr: val!) } else { return nil } }()
    }

    internal func r_get_record_members<GenericIntoRustString: IntoRustString>(_ record_name: GenericIntoRustString) -> Optional<RustString> {
        { let val = __swift_bridge__$RProgram$r_get_record_members(ptr, { let rustString = record_name.intoRustString(); rustString.isOwned = false; return rustString.ptr }()); if val != nil { return RustString(ptr: val!) } else { return nil } }()
    }

    internal func r_get_struct_members<GenericIntoRustString: IntoRustString>(_ struct_name: GenericIntoRustString) -> Optional<RustString> {
        { let val = __swift_bridge__$RProgram$r_get_struct_members(ptr, { let rustString = struct_name.intoRustString(); rustString.isOwned = false; return rustString.ptr }()); if val != nil { return RustString(ptr: val!) } else { return nil } }()
    }

    class internal func r_get_credits_program() -> Optional<RProgram> {
        { let val = __swift_bridge__$RProgram$r_get_credits_program(); if val != nil { return RProgram(ptr: val!) } else { return nil } }()
    }

    internal func r_id() -> RustString {
        RustString(ptr: __swift_bridge__$RProgram$r_id(ptr))
    }

    internal func r_is_equal(_ other: RProgramRef) -> Bool {
        __swift_bridge__$RProgram$r_is_equal(ptr, other.ptr)
    }

    internal func r_get_imports() -> RustVec<RustString> {
        RustVec(ptr: __swift_bridge__$RProgram$r_get_imports(ptr))
    }
}
extension RProgramRef: Equatable {
    public static func == (lhs: RProgramRef, rhs: RProgramRef) -> Bool {
        __swift_bridge__$RProgram$_partial_eq(rhs.ptr, lhs.ptr)
    }
}
extension RProgram: Vectorizable {
    internal static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RProgram$new()
    }

    internal static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RProgram$drop(vecPtr)
    }

    internal static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RProgram) {
        __swift_bridge__$Vec_RProgram$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    internal static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RProgram$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RProgram(ptr: pointer!) as! Self)
        }
    }

    internal static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RProgramRef> {
        let pointer = __swift_bridge__$Vec_RProgram$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RProgramRef(ptr: pointer!)
        }
    }

    internal static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RProgramRefMut> {
        let pointer = __swift_bridge__$Vec_RProgram$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RProgramRefMut(ptr: pointer!)
        }
    }

    internal static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<RProgramRef> {
        UnsafePointer<RProgramRef>(OpaquePointer(__swift_bridge__$Vec_RProgram$as_ptr(vecPtr)))
    }

    internal static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RProgram$len(vecPtr)
    }
}














internal class RTransactionWrapper: RTransactionWrapperRefMut {
    var isOwned: Bool = true

    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RTransactionWrapper$_free(ptr)
        }
    }
}
internal class RTransactionWrapperRefMut: RTransactionWrapperRef {
    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
internal class RTransactionWrapperRef {
    var ptr: UnsafeMutableRawPointer

    internal init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RTransactionWrapper: Vectorizable {
    internal static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RTransactionWrapper$new()
    }

    internal static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RTransactionWrapper$drop(vecPtr)
    }

    internal static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RTransactionWrapper) {
        __swift_bridge__$Vec_RTransactionWrapper$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    internal static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RTransactionWrapper$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RTransactionWrapper(ptr: pointer!) as! Self)
        }
    }

    internal static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RTransactionWrapperRef> {
        let pointer = __swift_bridge__$Vec_RTransactionWrapper$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RTransactionWrapperRef(ptr: pointer!)
        }
    }

    internal static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RTransactionWrapperRefMut> {
        let pointer = __swift_bridge__$Vec_RTransactionWrapper$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RTransactionWrapperRefMut(ptr: pointer!)
        }
    }

    internal static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<RTransactionWrapperRef> {
        UnsafePointer<RTransactionWrapperRef>(OpaquePointer(__swift_bridge__$Vec_RTransactionWrapper$as_ptr(vecPtr)))
    }

    internal static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RTransactionWrapper$len(vecPtr)
    }
}


internal class RKVPair: RKVPairRefMut {
    var isOwned: Bool = true

    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RKVPair$_free(ptr)
        }
    }
}
internal class RKVPairRefMut: RKVPairRef {
    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
internal class RKVPairRef {
    var ptr: UnsafeMutableRawPointer

    internal init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RKVPair: Vectorizable {
    internal static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RKVPair$new()
    }

    internal static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RKVPair$drop(vecPtr)
    }

    internal static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RKVPair) {
        __swift_bridge__$Vec_RKVPair$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    internal static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RKVPair$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RKVPair(ptr: pointer!) as! Self)
        }
    }

    internal static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RKVPairRef> {
        let pointer = __swift_bridge__$Vec_RKVPair$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RKVPairRef(ptr: pointer!)
        }
    }

    internal static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RKVPairRefMut> {
        let pointer = __swift_bridge__$Vec_RKVPair$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RKVPairRefMut(ptr: pointer!)
        }
    }

    internal static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<RKVPairRef> {
        UnsafePointer<RKVPairRef>(OpaquePointer(__swift_bridge__$Vec_RKVPair$as_ptr(vecPtr)))
    }

    internal static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RKVPair$len(vecPtr)
    }
}


internal class RHashMapStrings: RHashMapStringsRefMut {
    var isOwned: Bool = true

    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RHashMapStrings$_free(ptr)
        }
    }
}
extension RHashMapStrings {
    class internal func new(_ vector: RustVec<RKVPair>) -> RHashMapStrings {
        RHashMapStrings(ptr: __swift_bridge__$RHashMapStrings$new({ let val = vector; val.isOwned = false; return val.ptr }()))
    }
}
internal class RHashMapStringsRefMut: RHashMapStringsRef {
    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
internal class RHashMapStringsRef {
    var ptr: UnsafeMutableRawPointer

    internal init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RHashMapStrings: Vectorizable {
    internal static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RHashMapStrings$new()
    }

    internal static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RHashMapStrings$drop(vecPtr)
    }

    internal static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RHashMapStrings) {
        __swift_bridge__$Vec_RHashMapStrings$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    internal static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RHashMapStrings$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RHashMapStrings(ptr: pointer!) as! Self)
        }
    }

    internal static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RHashMapStringsRef> {
        let pointer = __swift_bridge__$Vec_RHashMapStrings$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RHashMapStringsRef(ptr: pointer!)
        }
    }

    internal static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RHashMapStringsRefMut> {
        let pointer = __swift_bridge__$Vec_RHashMapStrings$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RHashMapStringsRefMut(ptr: pointer!)
        }
    }

    internal static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<RHashMapStringsRef> {
        UnsafePointer<RHashMapStringsRef>(OpaquePointer(__swift_bridge__$Vec_RHashMapStrings$as_ptr(vecPtr)))
    }

    internal static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RHashMapStrings$len(vecPtr)
    }
}


internal class RProgramManager: RProgramManagerRefMut {
    var isOwned: Bool = true

    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RProgramManager$_free(ptr)
        }
    }
}
extension RProgramManager {
    class internal func r_execute<GenericToRustStr: ToRustStr, GenericIntoRustString: IntoRustString>(_ private_key: RPrivateKeyRef, _ program: GenericToRustStr, _ function: GenericToRustStr, _ inputs: RustVec<GenericIntoRustString>, _ fee_credits: Double, _ fee_record: Optional<RRecordPlaintext>, _ url: Optional<GenericIntoRustString>, _ imports: Optional<RHashMapStrings>, _ proving_key: Optional<RProvingKey>, _ verifying_key: Optional<RVerifyingKey>, _ fee_proving_key: Optional<RProvingKey>, _ fee_verifying_key: Optional<RVerifyingKey>) -> Optional<RTransaction> {
        return function.toRustStr({ functionAsRustStr in
            return program.toRustStr({ programAsRustStr in
            { let val = __swift_bridge__$RProgramManager$r_execute(private_key.ptr, programAsRustStr, functionAsRustStr, { let val = inputs; val.isOwned = false; return val.ptr }(), fee_credits, { if let val = fee_record { val.isOwned = false; return val.ptr } else { return nil } }(), { if let rustString = optionalStringIntoRustString(url) { rustString.isOwned = false; return rustString.ptr } else { return nil } }(), { if let val = imports { val.isOwned = false; return val.ptr } else { return nil } }(), { if let val = proving_key { val.isOwned = false; return val.ptr } else { return nil } }(), { if let val = verifying_key { val.isOwned = false; return val.ptr } else { return nil } }(), { if let val = fee_proving_key { val.isOwned = false; return val.ptr } else { return nil } }(), { if let val = fee_verifying_key { val.isOwned = false; return val.ptr } else { return nil } }()); if val != nil { return RTransaction(ptr: val!) } else { return nil } }()
        })
        })
    }
}
internal class RProgramManagerRefMut: RProgramManagerRef {
    internal override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
internal class RProgramManagerRef {
    var ptr: UnsafeMutableRawPointer

    internal init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RProgramManager: Vectorizable {
    internal static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RProgramManager$new()
    }

    internal static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RProgramManager$drop(vecPtr)
    }

    internal static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RProgramManager) {
        __swift_bridge__$Vec_RProgramManager$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    internal static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RProgramManager$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RProgramManager(ptr: pointer!) as! Self)
        }
    }

    internal static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RProgramManagerRef> {
        let pointer = __swift_bridge__$Vec_RProgramManager$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RProgramManagerRef(ptr: pointer!)
        }
    }

    internal static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RProgramManagerRefMut> {
        let pointer = __swift_bridge__$Vec_RProgramManager$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RProgramManagerRefMut(ptr: pointer!)
        }
    }

    internal static func vecOfSelfAsPtr(vecPtr: UnsafeMutableRawPointer) -> UnsafePointer<RProgramManagerRef> {
        UnsafePointer<RProgramManagerRef>(OpaquePointer(__swift_bridge__$Vec_RProgramManager$as_ptr(vecPtr)))
    }

    internal static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RProgramManager$len(vecPtr)
    }
}



