"
This trait is used by Famix models.
It provides an API for creating entities and adding them to the model.
"
Trait {
	#name : #FamixCBTEntityCreator,
	#category : #'Famix-CriticBrowser-Entities-Model'
}

{ #category : #meta }
FamixCBTEntityCreator classSide >> annotation [

	<FMClass: #TEntityCreator super: #Object>
	<package: #'Famix-CriticBrowser-Entities'>
	<generated>
	^ self
]

{ #category : #'entity creation' }
FamixCBTEntityCreator >> newCondition [

	<generated>
	^ self add: FamixCBCondition new
]

{ #category : #'entity creation' }
FamixCBTEntityCreator >> newConditionNamed: aName [

	<generated>
	^ self add: (FamixCBCondition named: aName)
]

{ #category : #'entity creation' }
FamixCBTEntityCreator >> newContext [

	<generated>
	^ self add: FamixCBContext new
]

{ #category : #'entity creation' }
FamixCBTEntityCreator >> newContextNamed: aName [

	<generated>
	^ self add: (FamixCBContext named: aName)
]

{ #category : #'entity creation' }
FamixCBTEntityCreator >> newRootContext [

	<generated>
	^ self add: FamixCBRootContext new
]

{ #category : #'entity creation' }
FamixCBTEntityCreator >> newViolation [

	<generated>
	^ self add: FamixCBViolation new
]
