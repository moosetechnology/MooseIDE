Class {
	#name : 'MiCoInnerEntitiesAttributeAccessExtractor',
	#superclass : 'MiCoInnerEntitiesAbstractExtractor',
	#category : 'MooseIDE-CoUsageMap-Model',
	#package : 'MooseIDE-CoUsageMap',
	#tag : 'Model'
}

{ #category : 'accessing' }
MiCoInnerEntitiesAttributeAccessExtractor class >> description [

	^'Inner boxes are all the attributes accessed by the entities
(typically methods) represented by the container boxes'
]

{ #category : 'accessing' }
MiCoInnerEntitiesAttributeAccessExtractor class >> menuItemName [

	^'Attribute access'
]

{ #category : 'execute' }
MiCoInnerEntitiesAttributeAccessExtractor >> attributeAccessorInvocations: anEntity [
	"building the list manually instead of using 2 #flatCollect:"

	| attributes |
	attributes := OrderedCollection new.

	anEntity outgoingInvocations
		do: [ :invoc |
			invoc candidates
				do: [ :mth |
					mth isAccessor ifTrue: [ attributes  addAll: (self directAttributeAccesses: mth) ]
			]
		].

	^attributes 

]

{ #category : 'execute' }
MiCoInnerEntitiesAttributeAccessExtractor >> directAttributeAccesses: entityWithAccesses [

	^entityWithAccesses accesses
		collect: [ :access | access variable ]
		thenSelect: [ :var | var isAttribute ]
]

{ #category : 'execute' }
MiCoInnerEntitiesAttributeAccessExtractor >> innerEntitiesFor: anEntity [

	^(self directAttributeAccesses: anEntity) , (self attributeAccessorInvocations: anEntity)

]
