@actualizar
Feature: Actualizar un producto usando la API /api/v1/product/

  Background:
    * url 'http://localhost:8081'
    * def ruta_crear = '/api/v1/product/'
    Given path ruta_crear,"/"
    And request { name: 'Iphone 99', description: 'Este es un smartphone de alta gama', price: 9999 }
    And header Accept = 'application/json'
    And header Authorization = 'Bearer aGFzaGRzZnNkZnNkZnNkZnNk'
    When method post
    Then status 201
    * def sku_creado = response.sku


  @happypath
  Scenario Outline: Actualizar un producto de forma exitosa
    Given path ruta_crear,"/",sku_creado,"/"
    And request <producto>
    And header Accept = 'application/json'
    When method put
    Then status 200
    And match responseType == 'json'
    And match $ == {"sku":'#notnull',"status":true,"message":"El producto fue actualizado con éxito"}
    Examples:
      | producto                                                                                       |
      | { name: 'Iphone Actualizado', description: 'Este es un smartphone de alta gama', price: 9999 } |
      | { name: 'Iphone 99', description: 'Descripcion Actualizada', price: 9999 }                     |
      | { name: 'Iphone 99', description: 'Este es un smartphone de alta gama', price: 90000 }         |


  @sadpath
  Scenario: Actualizar un producto con datos faltantes
    Given path ruta_crear,"/",sku_creado,"/"
    And request { name: 'Iphone Actualizado' }
    And header Accept = 'application/json'
    And header Authorization = 'Bearer aGFzaGRzZnNkZnNkZnNkZnNk'
    When method put
    Then status 400
    * print response
    * match response.message == 'La descripción del producto no fue proporcionada'

  @sadpath
  Scenario: Actualizar un producto path incorrecto
    Given path ruta_crear,"/",sku_creado
    And request { name: 'Iphone Actualizado', description: 'Este es un smartphone de alta gama', price: 10 }
    And header Accept = 'application/json'
    And header Authorization = 'Bearer aGFzaGRzZnNkZnNkZnNkZnNk'
    When method put
    Then status 404
    * print response
    * match response.error == '#string'
    * match response.path == '#string'

  @sadpath
  Scenario: Actualizar un producto sin sku en la ruta
    Given path ruta_crear,"/","/"
    And request { name: 'Iphone Actualizado', description: 'Este es un smartphone de alta gama', price: 9999 }
    And header Accept = 'application/json'
    When method put
    Then status 405
    * print response
    * match response.error == 'Method Not Allowed'

  @sadpath
  Scenario: Actualizar un producto con tipo de contenido incorrecto
    Given path ruta_crear,"/",sku_creado,"/"
    And request { name: 'Iphone Actualizado', description: 'Este es un smartphone de alta gama', price: 9999 }
    And header Accept = 'application/json'
    And header Authorization = 'Bearer aGFzaGRzZnNkZnNkZnNkZnNk'
    And header Content-Type = 'text/plain'
    When method put
    Then status 415
    * print response
    * match response.error == 'Unsupported Media Type'
