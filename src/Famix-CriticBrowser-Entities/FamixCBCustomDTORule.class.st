"
I am a custom rule for rules that apply on a DTO class. I fetch the DTO classes internally, so my queries should be coded while keeping in mind that they will be executed on the DTOs only.
"
Class {
	#name : #FamixCBCustomDTORule,
	#superclass : #FamixCBRule,
	#category : #'Famix-CriticBrowser-Entities'
}

{ #category : #ston }
FamixCBCustomDTORule class >> stonAllInstVarNames [
	^ super stonAllInstVarNames \ #(#mooseID #mooseModel #cache #entityAttributes #violations)
]

{ #category : #initialization }
FamixCBCustomDTORule >> getContextFrom: aCollection [
	
	^ self getDTOFrom: (self getEndpointsFrom: (self getServicesFrom: aCollection))
]

{ #category : #accessing }
FamixCBCustomDTORule >> getDTOFrom: aCollectionOfEndpoints [
	| sizePrev dtos |
	
	dtos := MooseGroup new.
	dtos := dtos | aCollectionOfEndpoints collect: [ :e | e declaredType ] thenSelect: [ :c | c isClass and: [ (self notDTOTypes includes: c name) not ] ].
	dtos := dtos | (self selectClassesAndCollectTypesOf: (aCollectionOfEndpoints flatCollect: [ :e | e parameters ])).
	
	[ 
	sizePrev := dtos size.
	dtos := dtos | (self selectClassesAndCollectTypesOf: (dtos flatCollect: [ :d | d attributes ]))
	]
	doWhileTrue: [ sizePrev < dtos size ].
	
	^ dtos reject: [ :dto | dto isInterface or: [ aCollectionOfEndpoints includes: dto ] ]

	
]

{ #category : #accessing }
FamixCBCustomDTORule >> getEndpointsFrom: aCollectionOfServices [

	^ (aCollectionOfServices flatCollect: [ :s | s methods ]) select: [ :m | m declaredExceptions anySatisfy: [ :e | e exceptionClass name = 'RemoteException' ] ]
]

{ #category : #accessing }
FamixCBCustomDTORule >> getServicesFrom: aCollection [

	 ^ aCollection select: [ :e | e isClass and: [ e isInterface and: [ e inheritsFromClassNamed: 'Remote' ] ] ]
]

{ #category : #'as yet unclassified' }
FamixCBCustomDTORule >> notDTOTypes [
	^ { 'Object'. 'File'. 'BigDecimal'. 'Integer'. 'Float'. 'Double'. 'Short'. 'Long'. 'Char'. 'Boolean'. 'Byte'. 'String'. 'Date' }
]

{ #category : #running }
FamixCBCustomDTORule >> runOn: aCollection [
	^ ((self query runOnCollection: (self getContextFrom: aCollection)) collect: 
		[ :each | (FamixCBViolation rule: self violatedBy: each) ]) asMooseGroup specialize.
]

{ #category : #'as yet unclassified' }
FamixCBCustomDTORule >> selectClassesAndCollectTypesOf: aCollection [
	^ aCollection select: [ :each | each declaredType isClass and: [ (self notDTOTypes includes: each declaredType name) not ] ] thenCollect: [ :c | c declaredType ]
]
