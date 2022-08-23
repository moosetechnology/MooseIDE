Class {
	#name : #FamixCBEntity,
	#superclass : #MooseEntity,
	#category : #'Famix-CriticBrowser-Entities-Entities'
}

{ #category : #meta }
FamixCBEntity class >> annotation [

	<FMClass: #Entity super: #MooseEntity>
	<package: #'Famix-CriticBrowser-Entities'>
	<generated>
	^self
]

{ #category : #meta }
FamixCBEntity class >> metamodel [

	<generated>
	^ FamixCBModel metamodel
]
