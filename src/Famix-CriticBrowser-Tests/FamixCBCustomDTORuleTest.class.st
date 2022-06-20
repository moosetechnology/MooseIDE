"
A FamixCBCustomDTORuleTest is a test class for testing the behavior of FamixCBCustomDTORule
"
Class {
	#name : #FamixCBCustomDTORuleTest,
	#superclass : #TestCase,
	#instVars : [
		'dtoOne',
		'dtoTwo',
		'dtoThree',
		'notDTO',
		'service',
		'notService',
		'endpoint',
		'notEndpoint',
		'rule'
	],
	#category : #'Famix-CriticBrowser-Tests'
}

{ #category : #accessing }
FamixCBCustomDTORuleTest >> model [
	^ { dtoOne. dtoTwo. dtoThree. notDTO. service. notService. endpoint. notEndpoint. }
]

{ #category : #initialization }
FamixCBCustomDTORuleTest >> setUp [
	| remote exception parameter attributeCorrect attributeWrong validQueryMethod |	
	rule := FamixCBCustomDTORule named: 'Test rule' on: (MiCriticBrowserPharoCodeQuery on: '[ :entity | entity methods anySatisfy: [ :m | m name = ''validReturn'' ] ]').
	
	dtoOne := FamixJavaClass named: 'ReturnDTO'.
	dtoTwo := FamixJavaClass named: 'ParameterDTO'.
	dtoThree := FamixJavaClass named: 'AttributeDTO'.
	notDTO := FamixJavaClass named: 'DTOAsAttribute'.

	exception := FamixJavaDeclaredException new.
	exception exceptionClass: (FamixJavaClass named: 'RemoteException').
	
	remote := FamixJavaClass named: 'Remote'.
	service := FamixJavaClass named: 'Service'.
	service
		isInterface: true;
		addSuperInheritance: (FamixJavaInheritance source: service target: remote ).
	notService := FamixJavaClass named: 'NotService'.
	notService addSuperInheritance: (FamixJavaInheritance source: service target: remote ).
	
	parameter := FamixJavaParameter named: 'dtoParameter'.
	parameter declaredType: dtoTwo.
	
	endpoint := FamixJavaMethod named: 'endpoint'.
	endpoint
		parentType: service;
		declaredType: dtoOne;
		addParameter: parameter;
		addDeclaredException: exception.
	notEndpoint := FamixJavaMethod named: 'notEndpoint'.
	notEndpoint parentType: service.
	attributeCorrect := FamixJavaAttribute named: 'attToBecomeDTO'.
	attributeCorrect declaredType: dtoThree.
	dtoOne addAttribute: attributeCorrect.
	
	attributeWrong := FamixJavaAttribute named: 'attNotToBecomeDTO'.
	attributeWrong declaredType: dtoOne.
	notDTO addAttribute: attributeWrong.
	
	validQueryMethod := FamixJavaMethod named: 'validReturn'.
	validQueryMethod parentType: dtoOne
]

{ #category : #test }
FamixCBCustomDTORuleTest >> testGetDTOFrom [
	| res |
	res := rule getDTOFrom: (rule getEndpointsFrom: (rule getServicesFrom: self model)).
	self assert: res size equals: 3.
	self assertCollection: res includesAll: { dtoOne. dtoTwo. dtoThree } 
]

{ #category : #test }
FamixCBCustomDTORuleTest >> testGetEndpointsFrom [
	| res |
	res := rule getEndpointsFrom: (rule getServicesFrom: self model).
	self assert: res size equals: 1.
	self assertCollection: res includesAll: { endpoint }
]

{ #category : #test }
FamixCBCustomDTORuleTest >> testGetServicesFrom [
	| res |
	res := (rule getServicesFrom: self model).
	self assert: res size equals: 1.
	self assertCollection: res includesAll: { service }
	
]

{ #category : #test }
FamixCBCustomDTORuleTest >> testRunOn [
	self assert: (rule runOn: self model) size equals: 1.
	self assert: (rule runOn: self model) anyOne violatingEntity equals: dtoOne
	
]
