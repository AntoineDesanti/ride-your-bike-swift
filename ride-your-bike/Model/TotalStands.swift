import Foundation
struct TotalStands : Codable {
	let availabilities : Availabilities?
	let capacity : Int?

	enum CodingKeys: String, CodingKey {

		case availabilities = "availabilities"
		case capacity = "capacity"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		availabilities = try values.decodeIfPresent(Availabilities.self, forKey: .availabilities)
		capacity = try values.decodeIfPresent(Int.self, forKey: .capacity)
	}

}
