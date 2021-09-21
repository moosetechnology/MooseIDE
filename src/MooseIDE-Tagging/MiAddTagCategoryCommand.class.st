Class {
	#name : #MiAddTagCategoryCommand,
	#superclass : #MiTagCommands,
	#category : #'MooseIDE-Tagging-Manager'
}

{ #category : #default }
MiAddTagCategoryCommand class >> defaultName [
	^ 'Add category'
]

{ #category : #default }
MiAddTagCategoryCommand class >> forSpecContext: anObject [
	^ (super forSpecContext: anObject)
		iconNamed: #mooseIcon;
		beHiddenWhenCantBeRun;
		yourself
]

{ #category : #testing }
MiAddTagCategoryCommand >> canBeExecuted [

	^ true
]

{ #category : #execution }
MiAddTagCategoryCommand >> execute [

	| name |
	name := UIManager default request: 'Please enter a name'.
	name ifNil: [ ^ self ].
	self context mooseModel createTagCategoryNamed: name.
	self context refresh
]
