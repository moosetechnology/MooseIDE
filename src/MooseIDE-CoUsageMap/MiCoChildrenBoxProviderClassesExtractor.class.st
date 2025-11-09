Class {
	#name : 'MiCoChildrenBoxProviderClassesExtractor',
	#superclass : 'MiCoChildrenBoxAbstractExtractor',
	#category : 'MooseIDE-CoUsageMap-Model',
	#package : 'MooseIDE-CoUsageMap',
	#tag : 'Model'
}

{ #category : 'accessing' }
MiCoChildrenBoxProviderClassesExtractor class >> description [

	^'Inner boxes are all the classes accessed by
the entities represented by the container boxes'
]

{ #category : 'accessing' }
MiCoChildrenBoxProviderClassesExtractor class >> menuItemName [

	^'Classes used'
]

{ #category : 'execute' }
MiCoChildrenBoxProviderClassesExtractor >> innerBoxesFor: containerEntity [

	^containerEntity allProviders
		flatCollect: [ :prov | prov containersOfType: FamixTClass ]
]
