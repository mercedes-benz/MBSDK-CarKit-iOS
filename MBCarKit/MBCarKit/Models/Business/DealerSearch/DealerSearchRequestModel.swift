//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a dealer search request
public struct DealerSearchRequestModel {

	// MARK: Enum
	
	/// Search type for 2 cases (location based and zip/city based)
    public enum SearchType {
		case byLocation(CoordinateModel)
        case byZipOrCity(value: String, countryIsoCode: String)
    }

	// MARK: Properties
    private let searchType: SearchType

	
	// MARK: - Init
	
    public init(searchType: SearchType) {
        self.searchType = searchType
    }
	
	
	// MARK: - Helper
	
	var zipCode: String? {
		switch self.searchType {
		case .byLocation:					return nil
		case .byZipOrCity(let value, _):	return value
		}
	}
	var countryIsoCode: String? {
		switch self.searchType {
		case .byLocation:							return nil
		case .byZipOrCity(_, let countryIsoCode):	return countryIsoCode
		}
	}
	var location: CoordinateModel? {
		switch self.searchType {
		case .byLocation(let coordinateModel):	return coordinateModel
		case .byZipOrCity:						return nil
		}
	}
}
