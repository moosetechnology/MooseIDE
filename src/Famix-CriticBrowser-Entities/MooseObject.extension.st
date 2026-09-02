Extension { #name : 'MooseObject' }

{ #category : '*Famix-CriticBrowser-Entities' }
MooseObject >> contexts [
	"Relation named: #contexts type: #FamixCBContext opposite: #entities"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Every context that the entity is a part of.'>
	<FMProperty: #contexts type: #FamixCBContext opposite: #entities>
	<multivalued>
	<package: #'Famix-CriticBrowser-Entities'>
	^ self attributeAt: #contexts ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #entities ]
]

{ #category : '*Famix-CriticBrowser-Entities' }
MooseObject >> contexts: anObject [

	<ignoreForCoverage>
	<generated>
	<package: #'Famix-CriticBrowser-Entities'>

	self contexts value: anObject
]

{ #category : '*Famix-CriticBrowser-Entities-accessing' }
MooseObject >> removeViolation: aViolation [
	self violations remove: aViolation ifAbsent: [ ^ self ].
	aViolation violatedCondition ifNotNil: [ aViolation violatedCondition removeViolation: aViolation ]
]

{ #category : '*Famix-CriticBrowser-Entities' }
MooseObject >> violations [
	"Relation named: #violations type: #FamixCBViolation opposite: #violatingEntity"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'Every violation raised by this entity.'>
	<derived>
	<FMProperty: #violations type: #FamixCBViolation opposite: #violatingEntity>
	<multivalued>
	<package: #'Famix-CriticBrowser-Entities'>
	^ self attributeAt: #violations ifAbsentPut: [ FMMultivalueLink on: self opposite: #violatingEntity: ]
]

{ #category : '*Famix-CriticBrowser-Entities' }
MooseObject >> violations: anObject [

	<ignoreForCoverage>
	<generated>
	<package: #'Famix-CriticBrowser-Entities'>

	self violations value: anObject
]
