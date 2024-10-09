@crear
Feature: Crear un nuevo producto usando la API /api/v1/product/

  Background:
    * url 'http://localhost:8081'
    * def ruta_crear = '/api/v1/product/'
    * def nuevo_producto =
      """
      {
        "name": "Iphone 15",
        "description": "Este es un smartphone de alta gama",
        "price": 1500,
      }
      """
    * header Authorization = 'Bearer aGFzaGRzZnNkZnNkZnNkZnNk'
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'


  @happypath
  Scenario: Crear un producto de forma exitosa con json como texto
    * def producto =
      """
      {
        "name": "Iphone 14",
        "description": "Este es un smartphone de alta gama",
        "price": 1400,
      }
      """
    Given url 'http://localhost:8081/api/v1/product/'
    And request producto
    And header Accept = 'application/json'
    And header Authorization = 'Bearer aGFzaGRzZnNkZnNkZnNkZnNk'
    When method post
    Then status 201

  @happypath
  Scenario: Crear un producto de forma exitosa usando json
    Given url 'http://localhost:8081/api/v1/product/'
    And request { name: 'Iphone 12', description: 'Este es un smartphone de alta gama', price: 1200 }
    And header Accept = 'application/json'
    And header Authorization = 'Bearer aGFzaGRzZnNkZnNkZnNkZnNk'
    When method post
    Then status 201

  @happypath
  Scenario: Crear un producto de forma exitosa, usando path y validando el response
    Given path "/api/v1/product/","/"
    And request nuevo_producto
    And header Accept = 'application/json'
    And header Authorization = 'Bearer aGFzaGRzZnNkZnNkZnNkZnNk'
    When method post
    Then status 201
    And match $ == {"sku":'#notnull',"status":true,"message":"El producto fue creado con éxito!"}

  @happypath
  Scenario: Crear un producto de forma exitosa, path, response and headers
    Given path ruta_crear,"/"
    And request nuevo_producto
    When method post
    Then status 201
    And match responseType == 'json'
    And match $ == {"sku":'#notnull',"status":true,"message":"El producto fue creado con éxito!"}

  @happypath
  Scenario Outline: Crear un producto de forma exitosa, path, response usando examples
    Given path ruta_crear,"/"
    And request <producto>
    And header Accept = 'application/json'
    And header Authorization = 'Bearer aGFzaGRzZnNkZnNkZnNkZnNk'
    When method post
    Then status 201
    And match responseType == 'json'
    And match $ == {"sku":'#notnull',"status":true,"message":"El producto fue creado con éxito!"}
    Examples:
      | producto                                                                 |
      | { name: 'Iphone 16', description: 'Telefono de alta gama', price: 1600 } |
      | { name: 'Iphone 17', description: 'Telefono de alta gama', price: 1700 } |
      | { name: 'Iphone 18', description: 'Telefono de alta gama', price: 1800 } |
      | { name: 'Iphone 19', description: 'Telefono de alta gama', price: 1900 } |


  @sadpath
  Scenario: Crear un producto con datos faltantes
    * def producto_invalido =
      """
      {
        "name": "Iphone 14"
      }
      """
    Given url 'http://localhost:8081/api/v1/product/'
    And request producto_invalido
    And header Accept = 'application/json'
    And header Authorization = 'Bearer aGFzaGRzZnNkZnNkZnNkZnNk'
    When method post
    Then status 400
    * print response
    * match response.message == 'La descripción del producto no fue proporcionada'

  @sadpath
  Scenario: Crear un producto con precio string
    * path ruta_crear
    When method post
    Then status 404
    * print response
    * match response.error == '#string'

  @sadpath
  Scenario: Crear un producto con header faltante
    * path ruta_crear,"/"
    And header Accept = ''
    When method post
    Then status 400
    * print response