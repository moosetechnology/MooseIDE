Class {
	#name : 'MiCoChildrenBoxAttributeAccessExtractor',
	#superclass : 'MiCoChildrenBoxAbstractExtractor',
	#category : 'MooseIDE-CoUsageMap-Model',
	#package : 'MooseIDE-CoUsageMap',
	#tag : 'Model'
}

{ #category : 'accessing' }
MiCoChildrenBoxAttributeAccessExtractor class >> description [

	^'Inner boxes are all the attributes accessed by the entities
(typically methods) represented by the container boxes'
]

{ #category : 'accessing' }
MiCoChildrenBoxAttributeAccessExtractor class >> menuItemName [

	^'Attribute access'
]

{ #category : 'as yet unclassified' }
MiCoChildrenBoxAttributeAccessExtractor >> innerBoxesFor: containerEntity [

	^containerEntity isContainerEntity
		ifTrue: [
			containerEntity accesses
				collect: [ :access | access variable ]
				thenSelect: [ :var | var isAttribute ]
		]
		ifFalse: [ #() ]
]
