@listar
Feature: Listar productos usando la API /api/v1/product/

  Background:
    * url 'http://localhost:8081'
    * def ruta_crear = '/api/v1/product/'
    * def result = callonce read('nuevo.feature')
    * print result.response

  @happypath
  Scenario: Listar un producto de forma exitosa
    Given path ruta_crear,"/",result.response.sku,"/"
    And header Accept = 'application/json'
    When method get
    Then status 200
    * print response
    * match responseType == 'json'
    * match $ == {"products":'#array',"status":true,"message":"El producto fue encontrado"}
    * match response.products[0].sku ==  result.response.sku

  @sadpath
  Scenario: Listar productos con path incorrecto
    Given path ruta_crear
    And header Accept = 'application/json'
    When method get
    Then status 404
    * print response
    * match response.error == 'Not Found'

  @sadpath
  Scenario: Listar productos con header incorrecto
    Given path ruta_crear,"/",result.response.sku,"/"
    And header Accept = 'application/jsonssss'
    When method get
    Then status 406
    * print response

  @sadpath
  Scenario: Listar productos con metodo incorrecto
    Given path ruta_crear,"/",result.response.sku,"/"
    And header Accept = 'application/json'
    And header Content-Type = 'text/plain'
    When method post
    Then status 405
    * print response
    * match response.error == 'Method Not Allowed'

  @sadpath
  Scenario: Listar productos con método incorrecto
    Given path ruta_crear,"/",result.response.sku,"/"
    And header Accept = 'application/json'
    When method post
    Then status 405
    * print response
    * match response.error == 'Method Not Allowed'