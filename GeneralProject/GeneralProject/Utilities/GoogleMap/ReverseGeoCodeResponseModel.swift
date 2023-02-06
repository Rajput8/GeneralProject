import Foundation

// MARK: - ReverseGeoCodeResponseModel
struct ReverseGeoCodeResponseModel: Codable {
    let plusCode: PlusCode?
    let results: [ResultData]?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case plusCode = "plus_code"
        case results, status
    }
}

// MARK: - PlusCode
struct PlusCode: Codable {
    let compoundCode, globalCode: String?

    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}

// MARK: - ResultData
struct ResultData: Codable {
    let addressComponents: [AddressComponent]?
    let formattedAddress: String?
    let geometry: GeometryData?
    let placeID: String?
    let types: [String]?
    let plusCode: PlusCode?

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case geometry
        case placeID = "place_id"
        case types
        case plusCode = "plus_code"
    }
}

// MARK: - AddressComponent
struct AddressComponent: Codable {
    let longName, shortName: String?
    let types: [String]?

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}

// MARK: - GeometryData
struct GeometryData: Codable {
    let bounds: Bounds?
    let location: Location?
    let locationType: String?
    let viewport: Bounds?

    enum CodingKeys: String, CodingKey {
        case bounds, location
        case locationType = "location_type"
        case viewport
    }
}

// MARK: - Bounds
struct Bounds: Codable {
    let northeast, southwest: Location?
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double?
}
