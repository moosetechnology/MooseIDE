Extension { #name : #MooseObject }

{ #category : #'*Famix-CriticBrowser-Entities-accessing' }
MooseObject >> contexts [
	"Relation named: #contexts type: #FamixCBContext opposite: #entities"

	<generated>
	<FMComment: 'Every context that the entity is a part of.'>
	<FMProperty: #contexts type: #FamixCBContext opposite: #entities>
	<package: #'Famix-CriticBrowser-Entities'>
	^ self attributeAt: #contexts ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #entities ]
]

{ #category : #'*Famix-CriticBrowser-Entities-accessing' }
MooseObject >> contexts: anObject [

	<generated>
	self contexts value: anObject
]

{ #category : #'*Famix-CriticBrowser-Entities-accessing' }
MooseObject >> removeViolation: aViolation [
	self violations remove: aViolation ifAbsent: [ ^ self ].
	aViolation violatedCondition ifNotNil: [ aViolation violatedCondition removeViolation: aViolation ]
]

{ #category : #'*Famix-CriticBrowser-Entities-accessing' }
MooseObject >> violations [
	"Relation named: #violations type: #FamixCBViolation opposite: #violatingEntity"

	<generated>
	<FMComment: 'Every violation raised by this entity.'>
	<derived>
	<FMProperty: #violations type: #FamixCBViolation opposite: #violatingEntity>
	<package: #'Famix-CriticBrowser-Entities'>
	^ self attributeAt: #violations ifAbsentPut: [ FMMultivalueLink on: self opposite: #violatingEntity: ]
]

{ #category : #'*Famix-CriticBrowser-Entities-accessing' }
MooseObject >> violations: anObject [

	<generated>
	self violations value: anObject
]
