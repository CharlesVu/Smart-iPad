//
//  TFLInteractor.swift
//  MKHome
//
//  Created by Charles Vu on 06/06/2019.
//  Copyright © 2019 charles. All rights reserved.
//

import Foundation
import TFLApiModels
import Alamofire
import os.log

extension TFL {
    struct TFLIntetactor {
        private var jsonDecoder: JSONDecoder {
            let result = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

            result.dateDecodingStrategy = .formatted(dateFormatter)
            return result
        }

        func getLines(mode: Mode, completion: @escaping ([Line]) -> Void) {
            let urlString = LinesURLBuilder()
                .setMode(mode: mode)
                .build()

            Alamofire.request(urlString, method: .get)
                .response { response in
                    if let data = response.data {
                        do {
                            let lines = try self.jsonDecoder.decode([Line].self, from: data)
                            completion(lines)
                        } catch let error {
                            os_log("❤️ %@", error.localizedDescription)
                        }
                    }
            }
        }

        func getLineStatus(mode: Mode, completion: @escaping ([Line]) -> Void) {
            let urlString = ModeStatusURLBuilder()
                .setMode(mode: mode)
                .build()

            Alamofire.request(urlString, method: .get)
                .response { response in
                    if let data = response.data {
                        do {
                            let lines = try self.jsonDecoder.decode([Line].self, from: data)
                            completion(lines)
                        } catch let error {
                            os_log("❤️ %@", error.localizedDescription)
                        }
                    }
            }
        }

        func getStatusDescription(completion: @escaping ([StatusSeverity]) -> Void) {
            let urlString = StatusDescriptionURLBuilder()
                .build()

            Alamofire.request(urlString, method: .get)
                .response { response in
                    if let data = response.data {
                        do {
                            let statuses = try self.jsonDecoder.decode([StatusSeverity].self, from: data)
                            completion(statuses)
                        } catch let error {
                            os_log("❤️ %@", error.localizedDescription)
                        }
                    }
            }
        }

    }
}
