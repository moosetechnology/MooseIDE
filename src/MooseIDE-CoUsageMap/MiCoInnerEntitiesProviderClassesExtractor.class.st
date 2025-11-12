Class {
	#name : 'MiCoInnerEntitiesProviderClassesExtractor',
	#superclass : 'MiCoInnerEntitiesAbstractExtractor',
	#category : 'MooseIDE-CoUsageMap-Model',
	#package : 'MooseIDE-CoUsageMap',
	#tag : 'Model'
}

{ #category : 'accessing' }
MiCoInnerEntitiesProviderClassesExtractor class >> description [

	^'Inner boxes are all the classes accessed by
the entities represented by the container boxes'
]

{ #category : 'accessing' }
MiCoInnerEntitiesProviderClassesExtractor class >> menuItemName [

	^'Classes used'
]

{ #category : 'execute' }
MiCoInnerEntitiesProviderClassesExtractor >> innerEntitiesFor: containerEntity [

	^containerEntity allProviders
		flatCollect: [ :prov | prov containersOfType: FamixTClass ]
]
