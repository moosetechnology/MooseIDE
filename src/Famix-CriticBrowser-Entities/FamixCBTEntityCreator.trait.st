"
This trait is used by Famix models.
It provides an API for creating entities and adding them to the model.


"
Trait {
	#name : 'FamixCBTEntityCreator',
	#category : 'Famix-CriticBrowser-Entities-Model',
	#package : 'Famix-CriticBrowser-Entities',
	#tag : 'Model'
}

{ #category : 'meta' }
FamixCBTEntityCreator classSide >> annotation [

	<ignoreForCoverage>
	<FMClass: #TEntityCreator super: #Object>
	<package: #'Famix-CriticBrowser-Entities'>
	<generated>
]

{ #category : 'entity creation' }
FamixCBTEntityCreator >> newCondition [

	<ignoreForCoverage>
	<generated>
	^ self add: FamixCBCondition new
]

{ #category : 'entity creation' }
FamixCBTEntityCreator >> newConditionNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (FamixCBCondition named: aName)
]

{ #category : 'entity creation' }
FamixCBTEntityCreator >> newContext [

	<ignoreForCoverage>
	<generated>
	^ self add: FamixCBContext new
]

{ #category : 'entity creation' }
FamixCBTEntityCreator >> newContextNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (FamixCBContext named: aName)
]

{ #category : 'entity creation' }
FamixCBTEntityCreator >> newRootContext [

	<ignoreForCoverage>
	<generated>
	^ self add: FamixCBRootContext new
]

{ #category : 'entity creation' }
FamixCBTEntityCreator >> newRootContextNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (FamixCBRootContext named: aName)
]

{ #category : 'entity creation' }
FamixCBTEntityCreator >> newViolation [

	<ignoreForCoverage>
	<generated>
	^ self add: FamixCBViolation new
]
