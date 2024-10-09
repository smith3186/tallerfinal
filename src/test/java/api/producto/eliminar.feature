@eliminar
Feature: Eliminar un producto usando la API /api/v1/product/

  Background:
    * url 'http://localhost:8081'
    * def ruta_crear = '/api/v1/product/'
    * def result = callonce read('nuevo.feature')
    * print result.response

  @happypath
  Scenario: Eliminar un producto de forma exitosa
    Given path ruta_crear,"/",result.response.sku,"/"
    And header Accept = 'application/json'
    When method delete
    Then status 200
    And match responseType == 'json'
    And match $ == {"count":'#number',"status":true,"message":"El producto fue eliminado con éxito"}

  @sadpath
  Scenario: Eliminar un producto con SKU inexistente
    Given path ruta_crear,"/","SKU_INEXISTENTE","/"
    And header Accept = 'application/json'
    When method delete
    Then status 404
    * print response
    * match response.message == 'El producto no fue encontrado'

  @sadpath
  Scenario: Eliminar un producto con header incorrecto
    Given path ruta_crear,"/",result.response.sku,"/"
    And header Accept = 'applicationjson'
    When method delete
    Then status 406
    * print response

  @sadpath
  Scenario: Eliminar un producto con tipo de contenido incorrecto
    Given path ruta_crear,"/",result.response.sku,"/"
    And header Accept = 'application/json'
    And header Content-Type = 'text/plain'
    When method delete
    Then status 404
    * print response
    * match response.message == 'El producto no fue encontrado'

  @sadpath
  Scenario: Eliminar un producto con método incorrecto
    Given path ruta_crear,"/",result.response.sku,"/"
    And header Accept = 'application/json'
    When method post
    Then status 405
    * print response
    * match response.error == 'Method Not Allowed'