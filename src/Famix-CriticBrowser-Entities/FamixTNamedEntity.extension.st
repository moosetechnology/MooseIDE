Extension { #name : #FamixTNamedEntity }

{ #category : #'*Famix-CriticBrowser-Entities-accessing' }
FamixTNamedEntity >> violations [
	"Relation named: #violations type: #FamixCBViolation opposite: #violatingEntity"

	<generated>
	<FMComment: 'Every violation raised by this entity.'>
	<derived>
	<source>
	<FMProperty: #violations type: #FamixCBViolation opposite: #violatingEntity>
	<package: #'Famix-CriticBrowser-Entities'>
	^ self attributeAt: #violations ifAbsentPut: [ FMMultivalueLink on: self opposite: #violatingEntity: ]
]

{ #category : #'*Famix-CriticBrowser-Entities-accessing' }
FamixTNamedEntity >> violations: anObject [

	<generated>
	self violations value: anObject
]
