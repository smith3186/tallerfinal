@recuperar
Feature: Recuperar un producto usando la API /api/v1/product/

  Background:
    * url 'http://localhost:8081'
    * def ruta_crear = '/api/v1/product/'
    * def result = callonce read('nuevo.feature')
    * print result.response

  @happypath
  Scenario: Recuperar un producto de forma exitosa
    Given path ruta_crear,"/",result.response.sku,"/"
    And header Accept = 'application/json'
    And header Authorization = 'Bearer aGFzaGRzZnNkZnNkZnNkZnNk'
    When method get
    Then status 200
    * print response
    * match responseType == 'json'


  @happypath
  Scenario: Recuperar todos los productos de forma exitosa
    Given path ruta_crear,"/"
    And header Accept = 'application/json'
    And header Authorization = 'Bearer aGFzaGRzZnNkZnNkZnNkZnNk'
    When method get
    Then status 200
    * print response


  @sadpath
  Scenario: Recuperar un producto con path incorrecto
    Given path ruta_crear
    And header Accept = 'application/json'
    When method get
    Then status 404
    * print response
    * match response.error == 'Not Found'

  @sadpath
  Scenario: Recuperar un producto con metodo incorrecto
    Given path ruta_crear,"/",result.response.sku,"/"
    And header Accept = 'application/json'
    When method post
    Then status 405
    * print response
    * match response.error == 'Method Not Allowed'

