Class {
	#name : 'MiCoChildrenBoxClientClassesExtractor',
	#superclass : 'MiCoChildrenBoxAbstractExtractor',
	#category : 'MooseIDE-CoUsageMap-Model',
	#package : 'MooseIDE-CoUsageMap',
	#tag : 'Model'
}

{ #category : 'accessing' }
MiCoChildrenBoxClientClassesExtractor class >> description [

	^'Inner boxes are all the classes dependending on
the entities represented by the container boxes'
]

{ #category : 'accessing' }
MiCoChildrenBoxClientClassesExtractor class >> menuItemName [

	^'Client classes'
]

{ #category : 'execute' }
MiCoChildrenBoxClientClassesExtractor >> innerBoxesFor: containerEntity [

	^containerEntity allClients
		flatCollect: [ :client | client containersOfType: FamixTClass ]
]
