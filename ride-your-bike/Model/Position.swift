

import Foundation
struct Position : Codable {
	let latitude : Double?
	let longitude : Double?

	enum CodingKeys: String, CodingKey {

		case latitude = "lat"
		case longitude = "lng"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
		longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
	}

}
