Class {
	#name : #FamixCBViolation,
	#superclass : #FamixCBEntity,
	#instVars : [
		'#violatedCondition => FMOne type: #FamixCBCondition opposite: #violations'
	],
	#category : #'Famix-CriticBrowser-Entities-Entities'
}

{ #category : #meta }
FamixCBViolation class >> annotation [

	<FMClass: #Violation super: #FamixCBEntity>
	<package: #'Famix-CriticBrowser-Entities'>
	<generated>
	^ self
]

{ #category : #'as yet unclassified' }
FamixCBViolation class >> annotationFamixCBViolationGroup [
	<mooseGroup>
	^ FamixCBViolationGroup 
]

{ #category : #initialization }
FamixCBViolation class >> condition: aCondition violatedBy: anEntity [
	^ self new 
		violatedCondition: aCondition;
		violatingEntity: anEntity;
		yourself
]

{ #category : #comparing }
FamixCBViolation >> = anObject [
	self class = anObject class ifFalse: [ ^ false ].
	^ self violatingEntity = anObject violatingEntity and: [ violatedCondition = anObject violatedCondition ]
]

{ #category : #comparing }
FamixCBViolation >> hash [
	^ self violatingEntity hash + violatedCondition 
]

{ #category : #printing }
FamixCBViolation >> mooseNameOn: aStream [
	self violatingEntity ifNotNil: [ self violatingEntity displayStringOn: aStream ].
	aStream nextPutAll: ' -> '.
	self violatedCondition ifNotNil: [ self violatedCondition displayStringOn: aStream ]
]

{ #category : #accessing }
FamixCBViolation >> violatedCondition [
	"Relation named: #violatedCondition type: #FamixCBCondition opposite: #violations"

	<generated>
	<FMComment: 'Condition violated by this entity.'>
	^ violatedCondition
]

{ #category : #accessing }
FamixCBViolation >> violatedCondition: anObject [

	<generated>
	violatedCondition := anObject
]

{ #category : #accessing }
FamixCBViolation >> violatingEntity [
	"Relation named: #violatingEntity type: #MooseObject opposite: #violations"

	<generated>
	<FMComment: 'Entity raising this violation.'>
	<FMProperty: #violatingEntity type: #MooseObject opposite: #violations>
	^ self attributeAt: #violatingEntity ifAbsent: [ nil ]
]

{ #category : #accessing }
FamixCBViolation >> violatingEntity: anObject [

	<generated>
	self attributeAt: #violatingEntity put: (FMMultivalueLink on: self update: #violations from: self violatingEntity to: anObject).
]
