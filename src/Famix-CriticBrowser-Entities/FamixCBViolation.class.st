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
	^self
]

{ #category : #'as yet unclassified' }
FamixCBViolation class >> annotationFamixCBViolationGroup [
	<mooseGroup>
	^ FamixCBViolationGroup 
]

{ #category : #initialization }
FamixCBViolation class >> rule: aFamixCBRule violatedBy: anEntity [
	^ self new 
		violatedRule: aFamixCBRule;
		violatingEntity: anEntity;
		yourself
]

{ #category : #printing }
FamixCBViolation >> mooseNameOn: aStream [
	self violatingEntity ifNotNil: [ aStream nextPutAll: self violatingEntity name ].
	aStream nextPutAll: ' -> '.
	self violatedRule ifNotNil: [ aStream nextPutAll: self violatedRule name ]
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
	"Relation named: #violatingEntity type: #FamixTNamedEntity opposite: #violations"

	<generated>
	<FMComment: 'Entity raising this violation.'>
	<FMProperty: #violatingEntity type: #FamixTNamedEntity opposite: #violations>
	^ self attributeAt: #violatingEntity ifAbsent: [ nil ]
]

{ #category : #accessing }
FamixCBViolation >> violatingEntity: anObject [

	<generated>
	self attributeAt: #violatingEntity put: (FMMultivalueLink on: self update: #violations from: self violatingEntity to: anObject).
]
