/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
public struct Station : Codable {
	let number : Int?
	let contract_name : String?
	let name : String?
	let address : String?
	let position : Position?
	let banking : Bool?
	let bonus : Bool?
	let bike_stands : Int?
	let available_bike_stands : Int?
	let available_bikes : Int?
	let status : String?
	let last_update : Int?

	enum CodingKeys: String, CodingKey {

		case number = "number"
		case contract_name = "contract_name"
		case name = "name"
		case address = "address"
		case position = "position"
		case banking = "banking"
		case bonus = "bonus"
		case bike_stands = "bike_stands"
		case available_bike_stands = "available_bike_stands"
		case available_bikes = "available_bikes"
		case status = "status"
		case last_update = "last_update"
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		number = try values.decodeIfPresent(Int.self, forKey: .number)
		contract_name = try values.decodeIfPresent(String.self, forKey: .contract_name)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		position = try values.decodeIfPresent(Position.self, forKey: .position)
		banking = try values.decodeIfPresent(Bool.self, forKey: .banking)
		bonus = try values.decodeIfPresent(Bool.self, forKey: .bonus)
		bike_stands = try values.decodeIfPresent(Int.self, forKey: .bike_stands)
		available_bike_stands = try values.decodeIfPresent(Int.self, forKey: .available_bike_stands)
		available_bikes = try values.decodeIfPresent(Int.self, forKey: .available_bikes)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		last_update = try values.decodeIfPresent(Int.self, forKey: .last_update)
	}

}
