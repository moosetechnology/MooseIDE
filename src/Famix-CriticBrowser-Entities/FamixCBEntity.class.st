Class {
	#name : 'FamixCBEntity',
	#superclass : 'MooseEntity',
	#category : 'Famix-CriticBrowser-Entities-Entities',
	#package : 'Famix-CriticBrowser-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixCBEntity class >> annotation [

	<FMClass: #Entity super: #MooseEntity>
	<package: #'Famix-CriticBrowser-Entities'>
	<generated>
	<abstract>
	^ self
]

{ #category : 'testing' }
FamixCBEntity class >> isAbstract [

	<generated>
	^ self == FamixCBEntity
]

{ #category : 'meta' }
FamixCBEntity class >> metamodel [

	<generated>
	^ FamixCBModel metamodel
]

{ #category : 'testing' }
FamixCBEntity >> isCBCondition [

	^ false
]

{ #category : 'testing' }
FamixCBEntity >> isCBContext [

	^ false
]

{ #category : 'testing' }
FamixCBEntity >> isCBRootContext [

	^ false
]
