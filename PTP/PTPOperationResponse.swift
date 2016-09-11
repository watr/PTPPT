
import Foundation

public enum PTPResponseCode: PTPCode {
    case undefined                             = 0x2000
    case ok                                    = 0x2001
    case generalError                          = 0x2002
    case sessionNotOpen                        = 0x2003
    case invalidTransactionID                  = 0x2004
    case operationNotSupported                 = 0x2005
    case parameterNotSupported                 = 0x2006
    case incompleteTransfer                    = 0x2007
    case invalidStorageID                      = 0x2008
    case invalidObjectHandle                   = 0x2009
    case devicePropNotSupported                = 0x200A
    case invalidObjectFormatCode               = 0x200B
    case storeFull                             = 0x200C
    case objectWriteProtected                  = 0x200D
    case storeReadOnly                         = 0x200E
    case accessDenied                          = 0x200F
    case noThumbnailPresent                    = 0x2010
    case selfTestFailed                        = 0x2011
    case partialDeletion                       = 0x2012
    case storeNotAvailable                     = 0x2013
    case specificationByFormatUnsupported      = 0x2014
    case noValidObjectInfo                     = 0x2015
    case invalidCodeFormat                     = 0x2016
    case unknownVendorCode                     = 0x2017
    case captureAlreadyTerminated              = 0x2018
    case deviceBusy                            = 0x2019
    case invalidParentObject                   = 0x201A
    case invalidDevicePropFormat               = 0x201B
    case invalidDevicePropValue                = 0x201C
    case invalidParameter                      = 0x201D
    case sessionAlreadyOpen                    = 0x201E
    case transactionCancelled                  = 0x201F
    case specificationOfDestinationUnsupported = 0x2020
}

public struct PTPOperationResponse {
    public let container: PTPContainer
        
    public init?(data: Data) {
        guard let container = PTPContainer(type: PTPContainerType.response.rawValue, data: data) else {
            return nil
        }
        self.container = container
    }
}
