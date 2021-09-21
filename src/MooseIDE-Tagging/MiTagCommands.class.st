Class {
	#name : #MiTagCommands,
	#superclass : #CmCommand,
	#category : #'MooseIDE-Tagging-Manager'
}

{ #category : #default }
MiTagCommands class >> forSpecContext: anObject [
	^ (super forSpecContext: anObject)
		iconNamed: #mooseIcon;
		beHiddenWhenCantBeRun;
		yourself
]

{ #category : #removing }
MiTagCommands >> mooseModel [

	^ self context mooseModel
]

{ #category : #removing }
MiTagCommands >> refresh [
	^ self context refresh 
]

{ #category : #removing }
MiTagCommands >> removeTag: aTag [

	| assocs |
	assocs := (self context mooseModel allTagAssociations select: [ :a | 
		           a tagOrNil = aTag ]) asOrderedCollection.
	assocs do: [ :a | 
		[ a entity removeTag: a tag ]
			on: Error
			do: [  ] ].
	self mooseModel remove: aTag ifAbsent: [  ].
	self refresh
]
