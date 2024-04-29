import Foundation

// MARK: Standard
public extension Networking {

    func sendCodableRequest<T: Codable>(
        _ objectType: T.Type,
        _ request: Request,
        completion handler: @escaping NetworkGenericHandler<T>
    ) {
        do {
            debugPrint("begin reqest \(request.method) \(request.baseURL) \(String(describing: request.parameters)) \(String(describing: request.authorization))")
            let request = try request.urlRequest()

            session.dataTask(with: request) { data, response, error in

                // handle transport error
                if let error = error {
                    DispatchQueue.main.async {
                        return handler(.failure(error))
                    }
                }

                guard
                    let response = response as? HTTPURLResponse,
                    let responseBody = data
                    else {
                    DispatchQueue.main.async {
                        handler(.failure(NetworkError.transportError))
                    }
                    return
                }

                let statusCode = HTTPStatus(response.statusCode)

                if case .success = statusCode {
                    if let responseString = String(bytes: responseBody, encoding: .utf8) {
                        debugPrint("\(request) \(responseString)")
                    } else {
                        // Otherwise print a hex dump of the body.
                        debugPrint("😳 hex dump of the body")
                        debugPrint(responseBody as NSData)
                    }
                    /// success handling
                    DispatchQueue.main.async {
                        do {
                            let object = try JSONDecoder()
                                .decode(T.self, from: responseBody)
                            handler(.success(object))
                        } catch {
                            handler(.failure(error))
                        }
                    }
                } else if case .forbidden = statusCode {
                    if let responseJson = try? JSONSerialization.jsonObject(with: responseBody, options: []) as? [String: Any],
                        let code = responseJson["status"] as? Int,
                       code == 0 {
                        NotificationCenter.default.post(name: Notification.Name("SUSPENDACCOUNT"), object: nil)
                    }
                    DispatchQueue.main.async {
                        handler(
                                .failure(
                                NetworkError
                                    .httpSeverSideError(responseBody, statusCode: statusCode)
                            )
                        )
                    }
                    return
                    
                } else {
                    /// HTTP server-side error handling
                    // Printout the information
                    if let responseString = String(bytes: responseBody, encoding: .utf8) {
                        debugPrint("\(request) \(responseString)")
                    } else {
                        // Otherwise print a hex dump of the body.
                        debugPrint("😳 hex dump of the body")
                        debugPrint(responseBody as NSData)
                    }

                    // return with error handler
                    DispatchQueue.main.async {
                        handler(
                                .failure(
                                NetworkError
                                    .httpSeverSideError(responseBody, statusCode: statusCode)
                            )
                        )
                    }
                    return
                }
            }.resume()

        } catch {
            return handler(.failure(error))
        }
    }

    /// Call a HTTP request. All the error handlers will stop the function immidiately
    /// - Parameters:
    ///   - request: the configured request object
    ///   - completion: handle block with result type
    func sendRequest(
        _ request: Request,
        completion handler: @escaping NetworkHandler
    ) {
        do {
            debugPrint("begin reqest \(request.method) \(request.baseURL) \(String(describing: request.parameters)) \(String(describing: request.authorization))")
            let request = try request.urlRequest()

            session.dataTask(with: request) { data, response, error in

                // handle transport error
                if let error = error {
                    DispatchQueue.main.async {
                        return handler(.failure(error))
                    }
                }

                guard
                    let response = response as? HTTPURLResponse,
                    let responseBody = data
                    else {
                    DispatchQueue.main.async {
                        handler(.failure(NetworkError.transportError))
                    }
                    return
                }

                let statusCode = HTTPStatus(response.statusCode)

                if case .success = statusCode {
                    if let responseString = String(bytes: responseBody, encoding: .utf8) {
                        debugPrint("\(request) \(responseString)")
                    } else {
                        // Otherwise print a hex dump of the body.
                        debugPrint("😳 hex dump of the body")
                        debugPrint(responseBody as NSData)
                    }
                    /// success handling
                    DispatchQueue.main.async {
                        handler(.success(responseBody))
                    }
                } else if case .forbidden = statusCode {
                    if let responseJson = try? JSONSerialization.jsonObject(with: responseBody, options: []) as? [String: Any],
                        let code = responseJson["status"] as? Int,
                       code == 0,
                       let urlString = request.url?.absoluteString,
                       !urlString.contains("login") {
                        NotificationCenter.default.post(name: Notification.Name("SUSPENDACCOUNT"), object: nil)
                    }
                    DispatchQueue.main.async {
                        handler(
                                .failure(
                                NetworkError
                                    .httpSeverSideError(responseBody, statusCode: statusCode)
                            )
                        )
                    }
                    return
                    
                } else {
                    /// HTTP server-side error handling
                    // Printout the information
                    if let responseString = String(bytes: responseBody, encoding: .utf8) {
                        debugPrint("\(request) \(responseString)")
                    } else {
                        // Otherwise print a hex dump of the body.
                        debugPrint("😳 hex dump of the body")
                        debugPrint(responseBody as NSData)
                    }

                    // return with error handler
                    DispatchQueue.main.async {
                        handler(
                                .failure(
                                NetworkError
                                    .httpSeverSideError(responseBody, statusCode: statusCode)
                            )
                        )
                    }
                    return
                }
            }.resume()

        } catch {
            return handler(.failure(error))
        }
    }

    /// Call a HTTP request with expected return JSON object.
    /// All the error handlers will stop the function immidiately
    /// - Parameters:
    ///   - objectType: The codable type of object we want to cast from the response data
    ///   - request: the configured request object
    ///   - completion: handle block with result type
    func get<ObjectType: Codable>(
        _ objectType: ObjectType.Type,
        from request: Request,
        completion handler: @escaping NetworkGenericHandler<ObjectType>
    ) {
        do {
            debugPrint("begin reqest \(request.method) \(request.baseURL) \(String(describing: request.parameters)) \(String(describing: request.authorization))")
            let request = try request.urlRequest()

            session.dataTask(with: request) { data, response, error in

                // handle transport error
                if let error = error {
                    DispatchQueue.main.async {
                        return handler(.failure(error))
                    }
                }

                guard
                    let response = response as? HTTPURLResponse,
                    let responseBody = data
                    else {
                    DispatchQueue.main.async {
                        handler(.failure(NetworkError.transportError))
                    }
                    return
                }

                let statusCode = HTTPStatus(response.statusCode)

                if case .success = statusCode {
                    if let responseString = String(bytes: responseBody, encoding: .utf8) {
                        debugPrint("\(request) \(responseString)")
                    } else {
                        // Otherwise print a hex dump of the body.
                        debugPrint("😳 hex dump of the body")
                        debugPrint(responseBody as NSData)
                    }
                    /// success handling
                    DispatchQueue.main.async {
                        //handler(.success(responseBody))
                        do {
                            let object = try JSONDecoder()
                                .decode(objectType.self, from: responseBody)
                            handler(.success(object))
                        } catch {
                            handler(.failure(error))
                        }
                    }
                } else {
                    /// HTTP server-side error handling
                    // Printout the information
                    if let responseString = String(bytes: responseBody, encoding: .utf8) {
                        debugPrint("\(request) \(responseString)")
                    } else {
                        // Otherwise print a hex dump of the body.
                        debugPrint("😳 hex dump of the body")
                        debugPrint(responseBody as NSData)
                    }

                    // return with error handler
                    DispatchQueue.main.async {
                        handler(
                                .failure(
                                NetworkError
                                    .httpSeverSideError(responseBody, statusCode: statusCode)
                            )
                        )
                    }
                    return
                }
            }.resume()

        } catch {
            return handler(.failure(error))
        }
    }
}
