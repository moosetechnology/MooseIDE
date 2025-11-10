Class {
	#name : 'MiCoInnerEntitiesClientClassesExtractor',
	#superclass : 'MiCoInnerEntitiesAbstractExtractor',
	#category : 'MooseIDE-CoUsageMap-Model',
	#package : 'MooseIDE-CoUsageMap',
	#tag : 'Model'
}

{ #category : 'accessing' }
MiCoInnerEntitiesClientClassesExtractor class >> description [

	^'Inner boxes are all the classes dependending on
the entities represented by the container boxes'
]

{ #category : 'accessing' }
MiCoInnerEntitiesClientClassesExtractor class >> menuItemName [

	^'Client classes'
]

{ #category : 'execute' }
MiCoInnerEntitiesClientClassesExtractor >> innerEntitiesFor: containerEntity [

	^containerEntity allClients
		flatCollect: [ :client | client containersOfType: FamixTClass ]
]
